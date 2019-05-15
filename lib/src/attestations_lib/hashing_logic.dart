import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:buffer/buffer.dart';
import 'package:collection/collection.dart';
import 'package:ethereum_util/ethereum_util.dart';
import 'package:merkletree/merkletree.dart';
import 'package:share_kit/src/attestations_lib/hashing_logic_types.dart';
import 'package:share_kit/src/attestations_lib/rfc3339_date_time.dart';
import 'package:sortedmap/sortedmap.dart';

String hashMessage(dynamic message) {
  if (message is String) {
    message = utf8.encode(message as String);
  }
  return bufferToHex(keccak256(message));
}

/// Generate a random hex string with 0x prefix
String generateNonce() {
  return hashMessage(DartRandom(Random.secure()).nextBytes(20));
}

String orderedStringify(dynamic obj) {
  String jsonEncoded =
      obj is JsonEncodable ? jsonEncode(obj.toJson()) : jsonEncode(obj);
  dynamic jsonDecoded = jsonDecode(jsonEncoded);
  var sortedMap = SortedMap<String, dynamic>.from(
      Map<String, dynamic>.from(jsonDecoded as Map), Ordering.byKey());
  return jsonEncode(sortedMap);
}

/// Given an array of hashed attestations, creates a new MerkleTree with the leaves
/// after the leaves are sorted by hash and mapped into hash Buffers.
MerkleTree getMerkleTreeFromLeaves(List<String> leaves) {
  leaves.sort();
  return new MerkleTree(
    leaves: leaves.map((x) => toBuffer(x)).toList(),
    hashAlgo: (x) => keccak256(x),
  );
}

MerkleTree getClaimTree(IIssuedClaimNode claim) {
  var dataHash = hashMessage(orderedStringify(claim.data));
  var typeHash = hashMessage(orderedStringify(claim.type));
  var issuanceHash = hashMessage(orderedStringify(claim.issuance));
  var auxHash = hashMessage(claim.aux);
  return getMerkleTreeFromLeaves([dataHash, typeHash, issuanceHash, auxHash]);
}

/// Given the contents of an attestation node, return the root hash of the Merkle tree
Uint8List hashClaimTree(IIssuedClaimNode claim) {
  var dataTree = getClaimTree(claim);
  return dataTree.root;
}

/// Sign a buffer with a given private key and return a hex string of the signature
/// @param hash Any message buffer
/// @param privKey A private key buffer
String signHash(Uint8List hash, Uint8List privKey) {
  var sig = sign(hash, privKey);
  return concatSig(toBuffer(sig.r), toBuffer(sig.s), toBuffer(sig.v));
}

/// Recover the address of the signer of a given message hash
/// @param hash Buffer of the message that was signed
/// @param sig Hex string of the signature
String recoverHashSigner(Uint8List hash, String sig) {
  var sigParams = fromRpcSig(sig);
  var pubKey = recoverPublicKeyFromSignature(
      ECDSASignature(sigParams.r, sigParams.s, sigParams.v), hash);
  var sender = publicKeyToAddress(pubKey);
  return bufferToHex(sender);
}

/// Sign a complete attestation node and return an object containing the datanode and the signature
/// @param dataNode - Complete attestation data node
/// @param globalRevocationLink - Hex string referencing revocation of the whole attestation
/// @param privKey - Private key of signer
ISignedClaimNode getSignedClaimNode(
    IClaimNode claimNode,
    String globalRevocationLink,
    Uint8List privKey,
    String issuanceDate,
    String expirationDate) {
  // validateDates
  if (!validateDateTime(issuanceDate)) {
    throw new ArgumentError('Invalid issuance date');
  }
  if (!validateDateTime(expirationDate)) {
    throw new ArgumentError('Invalid expiration date');
  }
  var issuedClaimNode = IIssuedClaimNode(
    data: claimNode.data,
    type: claimNode.type,
    aux: claimNode.aux,
    issuance: IIssuanceNode(
      localRevocationToken: generateNonce(),
      globalRevocationToken: globalRevocationLink,
      dataHash: hashMessage(orderedStringify(claimNode.data)),
      typeHash: hashMessage(orderedStringify(claimNode.type)),
      issuanceDate: issuanceDate,
      expirationDate: expirationDate,
    ),
  );

  var claimHash = hashClaimTree(issuedClaimNode);
  var attesterSig = signHash(claimHash, privKey);
  var attester = Wallet.fromPrivateKey(privKey);
  return ISignedClaimNode(
    claimNode: issuedClaimNode,
    attester: attester.getAddressString(),
    attesterSig: attesterSig,
  );
}

///
/// @param attestation Given the contents of an attestation node, return a
/// Merkle tree
MerkleTree getDataTree(IAttestationNode attestation) {
  var dataHash = hashMessage(orderedStringify(attestation.data));
  var typeHash = hashMessage(orderedStringify(attestation.type));
  var linkHash = hashMessage(orderedStringify(attestation.link));
  var auxHash = hashMessage(attestation.aux);
  return getMerkleTreeFromLeaves([dataHash, typeHash, linkHash, auxHash]);
}

/// Given the contents of an attestation node, return the root hash of the Merkle tree
Uint8List hashAttestationNode(IAttestationNode attestation) {
  var dataTree = getDataTree(attestation);
  return dataTree.root;
}

/// Sign a complete attestation node and return an object containing the datanode and the signature
/// @param dataNode - Complete attestation data node
/// @param globalRevocationLink - Hex string referencing revocation of the whole attestation
/// @param privKey - Private key of signer
IDataNodeLegacy getSignedDataNode(IAttestationLegacy dataNode,
    String globalRevocationLink, Uint8List privKey) {
  var attestationNode = IAttestationNode(
    data: dataNode.data,
    type: dataNode.type,
    aux: dataNode.aux,
    link: IRevocationLinks(
      local: generateNonce(),
      global: globalRevocationLink,
      dataHash: hashMessage(orderedStringify(dataNode.data)),
      typeHash: hashMessage(orderedStringify(dataNode.type)),
    ),
  );
  var attestationHash = hashAttestationNode(attestationNode);
  var attestationSig = signHash(attestationHash, privKey);
  return IDataNodeLegacy(
    attestationNode: attestationNode,
    signedAttestation: attestationSig,
  );
}

/// Given an array of hashed dataNode signatures and a hashed checksum signature, creates a new MerkleTree
/// after padding, and sorting.
///
MerkleTree getBloomMerkleTree(
    List<String> claimHashes, List<String> paddingNodes, String checksumHash) {
  var leaves = claimHashes;
  leaves.add(checksumHash);
  leaves.addAll(paddingNodes);
  return getMerkleTreeFromLeaves(leaves);
}

/// Given an array of root hashes, sort and hash them into a checksum buffer
/// @param {string[]} dataHashes - array of dataHashes as hex strings
Uint8List getChecksum(List<String> dataHashes) {
  dataHashes.sort();
  return toBuffer(hashMessage(jsonEncode(dataHashes)));
}

/// Given an array of root hashes, get and sign the checksum
/// @param dataHashes - array of dataHashes as hex strings
/// @param privKey - private key of signer
String signChecksum(List<String> dataHashes, Uint8List privKey) {
  return signHash(getChecksum(dataHashes), privKey);
}

/// Given the number of data nodes return an array of padding nodes
/// @param {number} dataCount - number of data nodes in tree
///
/// A Bloom Merkle tree will contain at minimum one data node and one checksum node
/// In order to obscure the amount of data in the tree, the number of nodes are padded to
/// a set threshold
///
/// The Depth of the tree increments in steps of 5
/// The number of terminal nodes in a filled binary tree is 2 ^ (n - 1) where n is the depth
///
/// dataCount 1 -> 15: paddingCount: 14 -> 0 (remeber + 1 for checksum node)
/// dataCount 16 -> 511: paddingCount 495 -> 0
/// dataCount 512 -> ...: paddingCount 15871 -> ...
/// ...
List<String> getPadding(int dataCount) {
  if (dataCount < 1) return [];
  var i = 5;
  while (dataCount + 1 > pow(2, i - 1)) {
    i += 5;
  }
  int paddingCount = pow(2, (i - 1)).toInt() - (dataCount + 1);
  var ret = List<String>(paddingCount);
  var random = DartRandom(Random.secure());
  return ret.map((_) {
    return hashMessage(random.nextBytes(20));
  }).toList();
}

/// Given attestation data and the attester's private key, construct the entire Bloom Merkle tree
/// and return the components needed to generate proofs
/// @param claimNodes - Complete attestation nodes
/// @param privKey - Attester private key
IBloomMerkleTreeComponents getSignedMerkleTreeComponents(
    List<IClaimNode> claimNodes,
    String issuanceDate,
    String expirationDate,
    Uint8List privKey) {
  var globalRevocationLink = generateNonce();
  List<ISignedClaimNode> signedClaimNodes = claimNodes
      .map((a) => getSignedClaimNode(
          a, globalRevocationLink, privKey, issuanceDate, expirationDate))
      .toList();
  List<String> attesterClaimSigHashes =
      signedClaimNodes.map((a) => hashMessage(a.attesterSig)).toList();

  var paddingNodes = getPadding(attesterClaimSigHashes.length);
  var signedChecksum = signChecksum(attesterClaimSigHashes, privKey);
  var signedChecksumHash = hashMessage(signedChecksum);
  var rootHash = getBloomMerkleTree(
          attesterClaimSigHashes, paddingNodes, signedChecksumHash)
      .root;
  var signedRootHash = signHash(rootHash, privKey);
  var rootHashNonce = generateNonce();
  var layer2Hash = hashMessage(orderedStringify({
    "rootHash": bufferToHex(rootHash),
    "nonce": rootHashNonce,
  }));
  var attester = Wallet.fromPrivateKey(privKey);
  return IBloomMerkleTreeComponents(
    attester: attester.getAddressString(),
    layer2Hash: layer2Hash,
    attesterSig: signedRootHash,
    rootHashNonce: rootHashNonce,
    rootHash: bufferToHex(rootHash),
    claimNodes: signedClaimNodes,
    checksumSig: signedChecksum,
    paddingNodes: paddingNodes,
    version: 'Attestation-Tree-2.0.0',
  );
}

/// Given attestation data and the attester's private key, construct the entire Bloom Merkle tree
/// and return the components needed to generate proofs
/// @param claimNodes - Complete attestation nodes
/// @param privKey - Attester private key
IBloomBatchMerkleTreeComponents getSignedBatchMerkleTreeComponents(
    IBloomMerkleTreeComponents components,
    String contractAddress,
    String subjectSig,
    String subject,
    String requestNonce,
    Uint8List privKey) {
  if (!validateSignedAgreement(subjectSig, contractAddress,
      components.layer2Hash, requestNonce, subject)) {
    throw new ArgumentError('Invalid subject sig');
  }
  var batchAttesterSig = signHash(
      toBuffer(hashMessage(orderedStringify({
        "subject": subject,
        "rootHash": components.layer2Hash,
      }))),
      privKey);
  var batchLayer2Hash = hashMessage(orderedStringify({
    "attesterSig": batchAttesterSig,
    "subjectSig": subjectSig,
  }));
  var attester = Wallet.fromPrivateKey(privKey);
  return IBloomBatchMerkleTreeComponents(
    attesterSig: components.attesterSig,
    batchAttesterSig: batchAttesterSig,
    batchLayer2Hash: batchLayer2Hash,
    checksumSig: components.checksumSig,
    claimNodes: components.claimNodes,
    contractAddress: contractAddress,
    layer2Hash: components.layer2Hash,
    paddingNodes: components.paddingNodes,
    requestNonce: requestNonce,
    rootHash: components.rootHash,
    rootHashNonce: components.rootHashNonce,
    attester: attester.getAddressString(),
    subject: subject,
    subjectSig: subjectSig,
    version: 'Batch-Attestation-Tree-1.0.0',
  );
}

MerkleTree getMerkleTreeFromComponents(IBloomMerkleTreeComponents components) {
  var signedDataHashes =
      components.claimNodes.map((a) => hashMessage(a.attesterSig)).toList();
  return getBloomMerkleTree(signedDataHashes, components.paddingNodes,
      hashMessage(components.checksumSig));
}

/// verify
/// @desc Returns true if the proof path (array of hashes) can connect the target node
/// to the Merkle root.
/// @param {Object[]} proof - Array of proof objects that should connect
/// target node to Merkle root.
/// @param {Buffer} targetNode - Target node Buffer
/// @param {Buffer} root - Merkle root Buffer
/// @return {Boolean}
/// @example
/// var root = tree.getRoot()
/// var proof = tree.getProof(leaves[2])
/// var verified = tree.verify(proof, leaves[2], root)
///
/// standalone verify function taken from https://github.com/miguelmota/merkletreejs
bool verifyMerkleProof(
    List<MerkleProof> proofs, Uint8List targetNode, Uint8List root) {
  // Should not succeed with all empty arguments
  // Proof can be empty if single leaf tree
  if (targetNode.isEmpty || root.isEmpty) {
    return false;
  }

  // Initialize hash with only targetNode data
  var hash = targetNode;

  // Build hash using each component of proof until the root node
  proofs.forEach((MerkleProof proof) {
    var buffers = BytesBuffer();
    if (proof.position == MerkleProofPosition.left) {
      buffers.add(proof.data);
      buffers.add(hash);
    } else {
      buffers.add(hash);
      buffers.add(proof.data);
    }
    hash = keccak(buffers.toBytes());
  });

  return ListEquality<dynamic>().equals(hash, root);
}

TypedData getAttestationAgreement(
    String contractAddress, int chainId, String dataHash, String requestNonce) {
  return TypedData(
    types: {
      "EIP712Domain": [
        TypedDataField(name: 'name', type: 'string'),
        TypedDataField(name: 'version', type: 'string'),
        TypedDataField(name: 'chainId', type: 'uint256'),
        TypedDataField(name: 'verifyingContract', type: 'address'),
      ],
      "AttestationRequest": [
        TypedDataField(name: 'dataHash', type: 'bytes32'),
        TypedDataField(name: 'nonce', type: 'bytes32'),
      ],
    },
    primaryType: 'AttestationRequest',
    domain: EIP712Domain(
      name: 'Bloom Attestation Logic',
      version: '2',
      chainId: chainId,
      verifyingContract: contractAddress,
    ),
    message: <String, String>{
      "dataHash": dataHash,
      "nonce": requestNonce,
    },
  );
}

bool validateSignedAgreement(String subjectSig, String contractAddress,
    String dataHash, String nonce, String subject) {
  var recoveredEthAddress = recoverTypedSignature(MsgParams(
    data: getAttestationAgreement(contractAddress, 1, dataHash, nonce),
    sig: subjectSig,
  ));
  return recoveredEthAddress.toLowerCase() == subject.toLowerCase();
}
