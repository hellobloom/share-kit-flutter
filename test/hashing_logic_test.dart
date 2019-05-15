import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:ethereum_util/ethereum_util.dart' as ethUtil;
import 'package:ethereum_util/src/typed_data.dart';
import 'package:ethereum_util/src/wallet.dart';
import 'package:test/test.dart';

import 'package:share_kit/src/attestations_lib/attestation_types.dart' as AttestationTypes;
import 'package:share_kit/src/attestations_lib/hashing_logic.dart' as HashingLogic;
import 'package:share_kit/src/attestations_lib/hashing_logic_types.dart' as HashingLogicTypes;

var aliceWallet =
    Wallet.fromPrivateKey(hex.decode('c87509a1c067bbde78beb793e6fa76530b6382a4c0241e5e4a9ec0a0f44dc0d3') as Uint8List);
var alicePrivkey = aliceWallet.getPrivateKey();

var bobWallet =
    Wallet.fromPrivateKey(hex.decode('ae6ae8e5ccbfb04590405997ee2d52d2b330726137b875053c36d94e974d162f') as Uint8List);
var bobPrivkey = bobWallet.getPrivateKey();
var bobAddress = bobWallet.getAddressString();

var preComputedHashes = Map<String, String>.from(<String, String>{
  'hashTest': '0x9c22ff5f21f0b81b113e63f7db6da94fedef11b2119b4088b89664fb9a3cb658',
  'emailAttestationType': '0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6',
  'emailAttestationDataHash': '0xd1696aa0222c2ee299efa58d265eaecc4677d8c88cb3a5c7e60bc5957fff514a',
  'emailAttestationTypeHash': '0x5aa3911df2dd532a0a03c7c6b6a234bb435a31dd9616477ef6cddacf014929df',
  'phoneAttestationType': '0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563',
  'phoneAttestationDataHash': '0x1d3ad3b73cddc7948cb0adfbbf6ce74dda20e42e864ecd67088985b339557461',
  'phoneAttestationTypeHash': '0x90f61ca5746fc0223e9a7564fd75c2336f902a78c59dfeb04cf119b204f2a404',
  'treeARootHash': '0xeff7cf589aa83bb524c9daeb776d171558b77a17ada025a94a67b0086dac5ede',
  'emailDataTreeHash': '0x0ef39bc9c680c01dbf61db1186ea4632bb195b85575eb205670cb146ee181275',
  'emailClaimTreeHash': '0xf7c60d8617a2221b96f566d9251a2146315fbae08c385737d3575914dccb3d08',
  'emailDataTreeHashAliceSigned':
      '0x124af1877444cbfea5a31a323449e76ab341c4df4d9943588fbe289c5eaf1bd339216d2e34c73d8d4f8f9f7bc939b1f127591ef25c4f1ce57d2e0af1a4cd8b561b',
  'rootHash': '0xe72cf1f9a85fbc529cd17cded83d0021beb12359c7f238276d8e20aea603e928',
});

var contractAddress = '0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC';

var preComputedAgreement = TypedData(
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
    chainId: 1,
    verifyingContract: contractAddress,
  ),
  message: <String, dynamic>{
    "dataHash": '0xe72cf1f9a85fbc529cd17cded83d0021beb12359c7f238276d8e20aea603e928',
    "nonce": '0xd5d7e6ae812a8ff7bd44f928b199806446c2170412df381efb41d8f47fcd044b',
  },
);

const validComponentVersions = ['Attestation-Tree-2.0.0'];
const validBatchComponentVersions = ['Batch-Attestation-Tree-1.0.0'];

var emailAttestationData = HashingLogicTypes.IAttestationData(
  data: 'test@bloom.co',
  nonce: 'a3877038-79a9-477d-8037-9826032e6af0',
  version: '1.0.0',
);

var emailAttestationType = HashingLogicTypes.IAttestationType(
  type: AttestationTypes.AttestationTypeID.email,
  nonce: 'a3877038-79a9-477d-8037-9826032e6af1',
  provider: 'Bloom',
);

var emailRevocationLinks = HashingLogicTypes.IRevocationLinks(
  local: '0x5a35e46865c7a4e0a5443b03d17d60c528896881646e6d58d3c4ad90ef84448e',
  global: '0xe04448fe19da4c3d85d6e646188628825c86d71b30b5445a0e4a7c56864e53a7',
  dataHash: '0xd1696aa0222c2ee299efa58d265eaecc4677d8c88cb3a5c7e60bc5957fff514a',
  typeHash: '0x5aa3911df2dd532a0a03c7c6b6a234bb435a31dd9616477ef6cddacf014929df',
);

var emailIssuanceNode = HashingLogicTypes.IIssuanceNode(
  localRevocationToken: '0x5a35e46865c7a4e0a5443b03d17d60c528896881646e6d58d3c4ad90ef84448e',
  globalRevocationToken: '0xe04448fe19da4c3d85d6e646188628825c86d71b30b5445a0e4a7c56864e53a7',
  dataHash: '0xd1696aa0222c2ee299efa58d265eaecc4677d8c88cb3a5c7e60bc5957fff514a',
  typeHash: '0x5aa3911df2dd532a0a03c7c6b6a234bb435a31dd9616477ef6cddacf014929df',
  issuanceDate: '2016-02-01T00:00:00.000Z',
  expirationDate: '2018-02-01T00:00:00.000Z',
);

const emailAuxHash = '0x3a25e46865c7a4e0a5445b03b17d68c529826881647e6d58d3c4ad91ef83440f';

var emailAttestation = HashingLogicTypes.IAttestationLegacy(
  data: emailAttestationData,
  type: emailAttestationType,
  aux: emailAuxHash,
);

var emailAttestationNode = HashingLogicTypes.IAttestationNode(
  data: emailAttestationData,
  type: emailAttestationType,
  aux: emailAuxHash,
  link: emailRevocationLinks,
);

var emailIssuedClaimNode = HashingLogicTypes.IIssuedClaimNode(
  data: emailAttestationData,
  type: emailAttestationType,
  aux: emailAuxHash,
  issuance: emailIssuanceNode,
);

var phoneAttestationData = HashingLogicTypes.IAttestationData(
  data: '+17203600587',
  nonce: 'a3877038-79a9-477d-8037-9826032e6af0',
  version: '1.0.0',
);
var phoneAttestationType = HashingLogicTypes.IAttestationType(
  type: AttestationTypes.AttestationTypeID.phone,
  nonce: 'a3877038-79a9-477d-8037-9826032e6af0',
  provider: 'Bloom',
);

var phoneRevocationLinks = HashingLogicTypes.IRevocationLinks(
  local: '0xb85448fe09da4c3d85d6e646188698825c06d71d30b3445a0e4a7c56864e52a4',
  global: '0xe04448fe19da4c3d85d6e646188628825c86d71b30b5445a0e4a7c56864e53a7',
  dataHash: '0x1d3ad3b73cddc7948cb0adfbbf6ce74dda20e42e864ecd67088985b339557461',
  typeHash: '0x90f61ca5746fc0223e9a7564fd75c2336f902a78c59dfeb04cf119b204f2a404',
);

const phoneAuxHash = '0x303438fe19da4c3d85d6e746188618925c86d71b30b5443a0e4a7c56864e52b5';

var phoneAttestation = HashingLogicTypes.IAttestationLegacy(
  data: phoneAttestationData,
  type: phoneAttestationType,
  aux: phoneAuxHash,
);
var phoneAttestationNode = HashingLogicTypes.IAttestationNode(
  data: phoneAttestationData,
  type: phoneAttestationType,
  aux: phoneAuxHash,
  link: phoneRevocationLinks,
);

var sample13PaddingNodes = [
  '0x9fc2f4407a5c4d28539121adcc2b294d69eac31f6ddc82bd82fed867ade29e63',
  '0xb44f1116ecdc24656c276814ebbf5c8feebce925bda53891dc086eceab1b2d02',
  '0x3603a4be55fffb54b7bc20090ec92655c142ff6e5b5867e2a61c8dffbd232cfa',
  '0xf0214686e4f3cdfd0eb70eaab5456bd11587246677bda641c316f7825404d5ba',
  '0x1310aed20a28d0d21357bd4458766c85a363c3945a8e564ad34f1585324a5f18',
  '0x74fe469ba1ff7398eaeda42976f25bda861dd0281b9460a1c04f50b5a6c13566',
  '0x8f7dd55bfaf656bfcff6567e88311833776e7444bd433eed485e9791f4da9e33',
  '0x0ffe3ebb9d45aedf09a551b4c035940001b0b8f45cbbb3f996d2f75c750a1916',
  '0xeff79179da0425e950b168e30003ac6589a3d7de1261c61605a16cc758a1cc04',
  '0x57b916759597b63bc55eb8033cb25edf6b7a42f2098f7dd44a5e0263cccf34bb',
  '0x409203975c17a730b9ef7db829cd24504444fb386e2ead719618c3afc9aadb25',
  '0xa7c44c3ca235e9e95e4acfb653d2de2f8379e7b6f43d20a8c50c0c4fcea3ef64',
  '0xfba3ca75b60179e7b00edb36db2a2de9c917e4caad7de6dbc61dd1fbc30b3758',
];

var fourRootHashes = [
  '0x7a35e46865c7a4e0a5445b03d17d60c528896881646e6d58d3c4ad90ef84440e',
  '0xf1e980ada99fc38d5e99d95d1ba52578ebd03caca349cfa1f1d721c954882550',
  '0xb15e74e8068d54a6e69a6a2e16ab1f1652a0e4821b09e935c994bda54a0b9a4b',
  '0xfabbbef9b00916a5d0a9bdd6f92ef7053eda577ea321d0ee339aad9a31aba718',
];

var fourRootHashesDifferentOrder = [
  '0xb15e74e8068d54a6e69a6a2e16ab1f1652a0e4821b09e935c994bda54a0b9a4b',
  '0xfabbbef9b00916a5d0a9bdd6f92ef7053eda577ea321d0ee339aad9a31aba718',
  '0x7a35e46865c7a4e0a5445b03d17d60c528896881646e6d58d3c4ad90ef84440e',
  '0xf1e980ada99fc38d5e99d95d1ba52578ebd03caca349cfa1f1d721c954882550',
];

void main() {
  test('HashingLogic.hashMessage', () {
    expect(HashingLogic.hashMessage('test'), preComputedHashes["hashTest"]);
  });

  test('HashingLogic.generateNonce', () {
    var nonce = HashingLogic.generateNonce();
    expect(nonce.length, 66);
  });

  test('HashingLogic orderedStringify', () {
    var objectA = {
      "name": 'Test Flower',
      "email": 'test@bloom.co',
      "phone": '+17203600587',
    };
    var objectB = {
      "email": 'test@bloom.co',
      "name": 'Test Flower',
      "phone": '+17203600587',
    };
    var objectC = {
      "email": 'test@bloom.co',
      "phone": '+17203600587',
      "name": 'Test Flower',
    };
    var objectD = {
      "email": 'test@bloom.com', // .com instead of .co
      "phone": '+17203600587',
      "name": 'Test Flower',
    };

    // serialized objects a, b, and c should be equal because of orderedStringify
    expect(HashingLogic.orderedStringify(objectA), HashingLogic.orderedStringify(objectB));
    expect(HashingLogic.orderedStringify(objectA), HashingLogic.orderedStringify(objectC));
    expect(HashingLogic.orderedStringify(objectB), HashingLogic.orderedStringify(objectC));

    // serialized objects will not equal because the data isn't the same
    expect(HashingLogic.orderedStringify(objectA), isNot(HashingLogic.orderedStringify(objectD)));
  });

  test('HashingLogic.getMerkleTreeFromLeaves', () {
    var leaves = fourRootHashes;

    var leavesDifferentOrder = fourRootHashesDifferentOrder;

    var differentLeaves = [
      '0xc15e74e8068d54a6e69a6a2e16ab1f1652a0e4821b09e935c994bda54a0b9a4b',
      '0xfabbbef9b00916a5d0a9bdd6f92ef7053eda577ea321d0ee339aad9a31aba718',
      '0x7a35e46865c7a4e0a5445b03d17d60c528896881646e6d58d3c4ad90ef84440e',
      '0xf1e980ada99fc38d5e99d95d1ba52578ebd03caca349cfa1f1d721c954882550',
    ];

    var treeA = HashingLogic.getMerkleTreeFromLeaves(leaves);
    var treeB = HashingLogic.getMerkleTreeFromLeaves(leavesDifferentOrder);
    var treeC = HashingLogic.getMerkleTreeFromLeaves(differentLeaves);

    expect(treeA.root, treeB.root);
    expect(treeA.root, isNot(treeC.root));

    // If this doesn't match something changed
    expect(ethUtil.bufferToHex(treeA.root), preComputedHashes["treeARootHash"]);
  });

  test('HashingLogic.getClaimTree & hashClaimTree', () {
    var claimTreeA = HashingLogic.getClaimTree(emailIssuedClaimNode);
    var claimTreeHash = HashingLogic.hashClaimTree(emailIssuedClaimNode);

    var claimTreeWrongNonce = HashingLogic.getClaimTree(HashingLogicTypes.IIssuedClaimNode(
      data: HashingLogicTypes.IAttestationData(
        data: 'test@bloom.co',
        nonce: 'f4877038-79a9-477d-8037-9826032e6ag1',
        version: '1.0.0',
      ),
      type: emailAttestationType,
      aux: emailAuxHash,
      issuance: emailIssuanceNode,
    ));

    var claimTreeWrongTypeNonce = HashingLogic.getClaimTree(HashingLogicTypes.IIssuedClaimNode(
      data: emailAttestationData,
      type: HashingLogicTypes.IAttestationType(
        type: AttestationTypes.AttestationTypeID.email,
        nonce: 'b3877038-79a9-477d-8037-9826032e6af1',
        provider: 'Bloom',
      ),
      aux: emailAuxHash,
      issuance: emailIssuanceNode,
    ));

    var claimTreeWrongIssuance = HashingLogic.getClaimTree(HashingLogicTypes.IIssuedClaimNode(
      data: emailAttestationData,
      type: emailAttestationType,
      issuance: HashingLogicTypes.IIssuanceNode(
        localRevocationToken: '0x5a35e46865c7a4e0a5443b03d17d60c528896881646e6d58d3c4ad90ef84448e',
        globalRevocationToken: '0xe04448fe19da4c3d85d6e646188628825c86d71b30b5445a0e4a7c56864e53a7',
        dataHash: '0xd1696aa0222c2ee299efa58d265eaecc4677d8c88cb3a5c7e60bc5957fff514a',
        typeHash: '0x5aa3911df2dd532a0a03c7c6b6a234bb435a31dd9616477ef6cddacf014929df',
        issuanceDate: '2017-02-01T00:00:00.000Z',
        expirationDate: '2018-02-01T00:00:00.000Z',
      ),
      aux: emailAuxHash,
    ));

    var claimTreeWrongAux = HashingLogic.getClaimTree(HashingLogicTypes.IIssuedClaimNode(
      data: emailAttestationData,
      type: emailAttestationType,
      issuance: emailIssuanceNode,
      aux: '0xf04448fe19da4c3d85d6e646188628825c86d71b30b5445a0e4a7c56864e53a7',
    ));

    expect(claimTreeA.root, isNot(claimTreeWrongNonce.root));
    expect(claimTreeA.root, isNot(claimTreeWrongTypeNonce.root));
    expect(claimTreeA.root, isNot(claimTreeWrongIssuance.root));
    expect(claimTreeA.root, isNot(claimTreeWrongAux.root));

    // If this doesn't match something changed
    expect(ethUtil.bufferToHex(claimTreeA.root), preComputedHashes["emailClaimTreeHash"]);

    expect(claimTreeA.root, claimTreeHash);
  });

  test('HashingLogic.getDataTree & hashAttestationNode', () {
    var dataTreeA = HashingLogic.getDataTree(emailAttestationNode);
    var dataTreeHash = HashingLogic.hashAttestationNode(emailAttestationNode);

    var dataTreeWrongDataNonce = HashingLogic.getDataTree(HashingLogicTypes.IAttestationNode(
      data: HashingLogicTypes.IAttestationData(
        data: 'test@bloom.co',
        nonce: 'b3877038-79a9-477d-8037-9826032e6af0',
        version: '1.0.0',
      ),
      type: emailAttestationType,
      link: emailRevocationLinks,
      aux: emailAuxHash,
    ));

    var dataTreeWrongTypeNonce = HashingLogic.getDataTree(HashingLogicTypes.IAttestationNode(
      data: emailAttestationData,
      type: HashingLogicTypes.IAttestationType(
        type: AttestationTypes.AttestationTypeID.email,
        nonce: 'b3877038-79a9-477d-8037-9826032e6af1',
        provider: 'Bloom',
      ),
      link: emailRevocationLinks,
      aux: emailAuxHash,
    ));

    var dataTreeWrongLink = HashingLogic.getDataTree(HashingLogicTypes.IAttestationNode(
      data: emailAttestationData,
      type: emailAttestationType,
      link: HashingLogicTypes.IRevocationLinks(
        local: '0x6a35e46865c7a4e0a5443b03d17d60c528896881646e6d58d3c4ad90ef84448e',
        global: '0xe04448fe19da4c3d85d6e646188628825c86d71b30b5445a0e4a7c56864e53a7',
        dataHash: '0xd1696aa0222c2ee299efa58d265eaecc4677d8c88cb3a5c7e60bc5957fff514a',
        typeHash: '0x5aa3911df2dd532a0a03c7c6b6a234bb435a31dd9616477ef6cddacf014929df',
      ),
      aux: emailAuxHash,
    ));

    var dataTreeWrongAux = HashingLogic.getDataTree(HashingLogicTypes.IAttestationNode(
      data: emailAttestationData,
      type: emailAttestationType,
      link: emailRevocationLinks,
      aux: '0xf04448fe19da4c3d85d6e646188628825c86d71b30b5445a0e4a7c56864e53a7',
    ));

    expect(dataTreeA.root, isNot(dataTreeWrongDataNonce.root));
    expect(dataTreeA.root, isNot(dataTreeWrongTypeNonce.root));
    expect(dataTreeA.root, isNot(dataTreeWrongLink.root));
    expect(dataTreeA.root, isNot(dataTreeWrongAux.root));

    // If this doesn't match something changed
    expect(ethUtil.bufferToHex(dataTreeA.root), preComputedHashes["emailDataTreeHash"]);

    expect(dataTreeA.root, dataTreeHash);
  });

  test('HashingLogic.signHash & recoverHashSigner', () {
    var emailDataRoot = HashingLogic.hashAttestationNode(emailAttestationNode);
    var signedEmailRoot = HashingLogic.signHash(emailDataRoot, alicePrivkey);

    var sender = HashingLogic.recoverHashSigner(emailDataRoot, signedEmailRoot);

    expect(sender.toLowerCase(), aliceWallet.getAddressString().toLowerCase());
    expect(sender.toLowerCase(), isNot(bobWallet.getAddressString().toLowerCase()));

    // If this doesn't match something changed
    expect(signedEmailRoot, preComputedHashes["emailDataTreeHashAliceSigned"]);
  });

  test('HashingLogic.getBloomMerkleTree', () {
    var emailDataRoot = HashingLogic.hashAttestationNode(emailAttestationNode);
    var signedEmailRoot = HashingLogic.signHash(emailDataRoot, alicePrivkey);
    var phoneDataRoot = HashingLogic.hashAttestationNode(phoneAttestationNode);
    var signedPhoneRoot = HashingLogic.signHash(phoneDataRoot, alicePrivkey);

    var dataHashes = [
      HashingLogic.hashMessage(signedEmailRoot),
      HashingLogic.hashMessage(signedPhoneRoot),
    ];

    var checksum = HashingLogic.getChecksum(dataHashes);
    var signedChecksumHash = HashingLogic.hashMessage(HashingLogic.signHash(checksum, alicePrivkey));

    var tree = HashingLogic.getBloomMerkleTree(dataHashes, sample13PaddingNodes, signedChecksumHash);
    expect(ethUtil.bufferToHex(tree.root), preComputedHashes["rootHash"]);

    var leaves = tree.leaves;
    expect(leaves.length, 16);

    // leaves should be in alphabetical order
    var leavesAsStrings = leaves.map((l) => ethUtil.bufferToHex(l)).toList();
    var leavesStringified = jsonEncode(leavesAsStrings);
    leavesAsStrings.sort();
    var leavesSortedStringified = jsonEncode(leavesAsStrings);
    expect(leavesStringified, leavesSortedStringified);
  });

  test('HashingLogic.getChecksum', () {
    var fourRootChecksum = HashingLogic.getChecksum(fourRootHashes);
    var fourRootChecksumDifferentOrder = HashingLogic.getChecksum(fourRootHashesDifferentOrder);

    expect(ethUtil.bufferToHex(fourRootChecksum).length, 66);
    expect(fourRootChecksumDifferentOrder, fourRootChecksum);

    var oneRootHash = [
      '0x7a35e46865c7a4e0a5445b03d17d60c528896881646e6d58d3c4ad90ef84440e',
    ];
    var oneRootChecksum = HashingLogic.getChecksum(oneRootHash);
    expect(ethUtil.bufferToHex(oneRootChecksum).length, 66);

    var noRootChecksum = HashingLogic.getChecksum([]);
    expect(ethUtil.bufferToHex(noRootChecksum), '0x518674ab2b227e5f11e9084f615d57663cde47bce1ba168b4c19c7ee22a73d70');
  });

  test('HashingLogic.getSignedChecksum', () {
    var signedChecksumHash = HashingLogic.signChecksum(fourRootHashes, alicePrivkey);
    var sender = HashingLogic.recoverHashSigner(HashingLogic.getChecksum(fourRootHashes), signedChecksumHash);

    expect(sender.toLowerCase(), aliceWallet.getAddressString().toLowerCase());
    expect(sender.toLowerCase(), isNot(bobWallet.getAddressString().toLowerCase()));
  });

  test('HashingLogic.getPadding', () {
    // If 0 data node padding should be 0
    var padding = HashingLogic.getPadding(0);
    expect(padding.length, 0);

    // If 1 data node padding should be 14
    padding = HashingLogic.getPadding(1);
    padding.forEach((p) => expect(p.length, 66));
    expect(padding.length, 14);

    // If 10 data node padding should be 5
    padding = HashingLogic.getPadding(10);
    padding.forEach((p) => expect(p.length, 66));
    expect(padding.length, 5);

    // If 15 data node padding should be 0
    padding = HashingLogic.getPadding(15);
    expect(padding.length, 0);

    // If 16 data node padding should be 495
    padding = HashingLogic.getPadding(16);
    padding.forEach((p) => expect(p.length, 66));
    expect(padding.length, 495);

    // If 511 data node padding should be 0
    padding = HashingLogic.getPadding(511);
    expect(padding.length, 0);

    // If 512 data node padding should be 15871
    padding = HashingLogic.getPadding(512);
    expect(padding.length, 15871);
  });

  test('Bloom Merkle Tree Proofs', () {
    var emailDataRoot = HashingLogic.hashAttestationNode(emailAttestationNode);
    var signedEmailRoot = HashingLogic.signHash(emailDataRoot, alicePrivkey);
    var phoneDataRoot = HashingLogic.hashAttestationNode(phoneAttestationNode);
    var signedPhoneRoot = HashingLogic.signHash(phoneDataRoot, alicePrivkey);

    var hashedEmailAttestation = HashingLogic.hashMessage(signedEmailRoot);
    var hashedPhoneAttestation = HashingLogic.hashMessage(signedPhoneRoot);

    var dataHashes = [hashedEmailAttestation, hashedPhoneAttestation];

    var checksum = HashingLogic.getChecksum(dataHashes);
    var signedChecksumHash = HashingLogic.hashMessage(HashingLogic.signHash(checksum, alicePrivkey));

    var tree = HashingLogic.getBloomMerkleTree(dataHashes, sample13PaddingNodes, signedChecksumHash);
    var root = tree.root;
    var leaves = tree.leaves;
    var emailProof = tree.getProof(leaf: ethUtil.toBuffer(hashedEmailAttestation));
    var phoneProof = tree.getProof(leaf: ethUtil.toBuffer(hashedPhoneAttestation));
    var checksumProof = tree.getProof(leaf: ethUtil.toBuffer(signedChecksumHash));

    var stringLeaves = leaves.map((x) => ethUtil.bufferToHex(x)).toList();

    var emailPosition = stringLeaves.indexOf(hashedEmailAttestation);
    var checksumPosition = stringLeaves.indexOf(signedChecksumHash);
    var phonePosition = stringLeaves.indexOf(hashedPhoneAttestation);

    expect(HashingLogic.verifyMerkleProof(emailProof, tree.leaves[emailPosition], root), true);
    expect(HashingLogic.verifyMerkleProof(emailProof, tree.leaves[phonePosition], root), false);
    expect(HashingLogic.verifyMerkleProof(emailProof, tree.leaves[checksumPosition], root), false);

    expect(HashingLogic.verifyMerkleProof(checksumProof, leaves[emailPosition], root), false);
    expect(HashingLogic.verifyMerkleProof(checksumProof, leaves[checksumPosition], root), true);
    expect(HashingLogic.verifyMerkleProof(checksumProof, leaves[phonePosition], root), false);

    expect(HashingLogic.verifyMerkleProof(phoneProof, leaves[checksumPosition], root), false);
    expect(HashingLogic.verifyMerkleProof(phoneProof, leaves[emailPosition], root), false);
    expect(HashingLogic.verifyMerkleProof(phoneProof, leaves[phonePosition], root), true);

    expect(HashingLogic.verifyMerkleProof([], ethUtil.toBuffer(''), ethUtil.toBuffer('')), false);
  });

  test('Attestation Data Tree Proofs', () {
    var dataHash = HashingLogic.hashMessage(HashingLogic.orderedStringify(emailAttestationNode.data));
    var typeHash = HashingLogic.hashMessage(HashingLogic.orderedStringify(emailAttestationNode.type));
    var linkHash = HashingLogic.hashMessage(HashingLogic.orderedStringify(emailAttestationNode.link));
    var auxHash = HashingLogic.hashMessage(emailAttestationNode.aux);

    var tree = HashingLogic.getDataTree(emailAttestationNode);
    var root = tree.root;
    var leaves = tree.leaves;
    var dataProof = tree.getProof(leaf: ethUtil.toBuffer(dataHash));
    var typeProof = tree.getProof(leaf: ethUtil.toBuffer(typeHash));
    var linkProof = tree.getProof(leaf: ethUtil.toBuffer(linkHash));
    var auxProof = tree.getProof(leaf: ethUtil.toBuffer(auxHash));

    var stringLeaves = leaves.map((x) => ethUtil.bufferToHex(x)).toList();

    var dataPosition = stringLeaves.indexOf(dataHash);
    var typePosition = stringLeaves.indexOf(typeHash);
    var linkPosition = stringLeaves.indexOf(linkHash);
    var auxPosition = stringLeaves.indexOf(auxHash);

    expect(HashingLogic.verifyMerkleProof(dataProof, tree.leaves[dataPosition], root), true);
    expect(HashingLogic.verifyMerkleProof(dataProof, tree.leaves[typePosition], root), false);
    expect(HashingLogic.verifyMerkleProof(dataProof, tree.leaves[linkPosition], root), false);
    expect(HashingLogic.verifyMerkleProof(dataProof, tree.leaves[auxPosition], root), false);

    expect(HashingLogic.verifyMerkleProof(typeProof, tree.leaves[typePosition], root), true);
    expect(HashingLogic.verifyMerkleProof(typeProof, tree.leaves[dataPosition], root), false);
    expect(HashingLogic.verifyMerkleProof(typeProof, tree.leaves[linkPosition], root), false);
    expect(HashingLogic.verifyMerkleProof(typeProof, tree.leaves[auxPosition], root), false);

    expect(HashingLogic.verifyMerkleProof(linkProof, tree.leaves[linkPosition], root), true);
    expect(HashingLogic.verifyMerkleProof(linkProof, tree.leaves[dataPosition], root), false);
    expect(HashingLogic.verifyMerkleProof(linkProof, tree.leaves[typePosition], root), false);
    expect(HashingLogic.verifyMerkleProof(linkProof, tree.leaves[auxPosition], root), false);

    expect(HashingLogic.verifyMerkleProof(auxProof, tree.leaves[auxPosition], root), true);
    expect(HashingLogic.verifyMerkleProof(auxProof, tree.leaves[dataPosition], root), false);
    expect(HashingLogic.verifyMerkleProof(auxProof, tree.leaves[typePosition], root), false);
    expect(HashingLogic.verifyMerkleProof(auxProof, tree.leaves[linkPosition], root), false);
  });

  test('HashingLogic.getSignedClaimNode', () {
    var globalLink = HashingLogic.generateNonce();
    var issuedClaimNode = HashingLogic.getSignedClaimNode(emailAttestation, globalLink, alicePrivkey,
        emailIssuedClaimNode.issuance.issuanceDate, emailIssuedClaimNode.issuance.expirationDate);

    expect(issuedClaimNode.claimNode.issuance.globalRevocationToken, globalLink);
    expect(issuedClaimNode.claimNode.issuance.localRevocationToken.length, 66);
    expect(issuedClaimNode.claimNode.data, emailAttestation.data);
    expect(issuedClaimNode.claimNode.type, emailAttestation.type);
    expect(issuedClaimNode.claimNode.aux, emailAttestation.aux);

    var claimHash = HashingLogic.hashClaimTree(issuedClaimNode.claimNode);
    var sender = HashingLogic.recoverHashSigner(claimHash, issuedClaimNode.attesterSig);
    expect(sender.toLowerCase(), aliceWallet.getAddressString().toLowerCase());
  });

  test('HashingLogic.getSignedClaimNode date validation', () {
    var globalLink = HashingLogic.generateNonce();
    expect(
        () => HashingLogic.getSignedClaimNode(
            emailAttestation, globalLink, alicePrivkey, 'March 2, 2016', emailIssuedClaimNode.issuance.expirationDate),
        throwsArgumentError);

    expect(
        () => HashingLogic.getSignedClaimNode(
            emailAttestation, globalLink, alicePrivkey, emailIssuedClaimNode.issuance.issuanceDate, 'March 2, 2018'),
        throwsArgumentError);
  });

  test('HashingLogic.getSignedDataNodes', () {
    var globalLink = HashingLogic.generateNonce();
    var dataNode = HashingLogic.getSignedDataNode(emailAttestation, globalLink, alicePrivkey);

    expect(dataNode.attestationNode.link.global, globalLink);
    expect(dataNode.attestationNode.link.local.length, 66);
    expect(dataNode.attestationNode.data, emailAttestation.data);
    expect(dataNode.attestationNode.type, emailAttestation.type);
    expect(dataNode.attestationNode.aux, emailAttestation.aux);

    var attestationHash = HashingLogic.hashAttestationNode(dataNode.attestationNode);
    var sender = HashingLogic.recoverHashSigner(attestationHash, dataNode.signedAttestation);
    expect(sender.toLowerCase(), aliceWallet.getAddressString().toLowerCase());
  });

  test('HashingLogic.getSignedMerkleTreeComponents', () {
    var components = HashingLogic.getSignedMerkleTreeComponents([emailAttestation, phoneAttestation],
        emailIssuedClaimNode.issuance.issuanceDate, emailIssuedClaimNode.issuance.expirationDate, alicePrivkey);

    expect(validComponentVersions.indexOf(components.version), greaterThan(-1));

    expect(components.paddingNodes.length, 13);
    components.paddingNodes.forEach((p) => expect(p.length, 66));

    var checksum =
        HashingLogic.getChecksum(components.claimNodes.map((a) => HashingLogic.hashMessage(a.attesterSig)).toList());
    var checksumSigner = HashingLogic.recoverHashSigner(checksum, components.checksumSig);
    expect(checksumSigner.toLowerCase(), aliceWallet.getAddressString().toLowerCase());

    var rootHash = HashingLogic.getBloomMerkleTree(
            components.claimNodes.map((a) => HashingLogic.hashMessage(a.attesterSig)).toList(),
            components.paddingNodes,
            HashingLogic.hashMessage(components.checksumSig))
        .root;

    expect(ethUtil.bufferToHex(rootHash), components.rootHash);

    var rootHashSigner = HashingLogic.recoverHashSigner(rootHash, components.attesterSig);
    expect(rootHashSigner.toLowerCase(), aliceWallet.getAddressString().toLowerCase());

    var layer2Hash = HashingLogic.hashMessage(HashingLogic.orderedStringify({
      "rootHash": ethUtil.bufferToHex(rootHash),
      "nonce": components.rootHashNonce,
    }));
    expect(layer2Hash, components.layer2Hash);

    var rootHashFromComponents = HashingLogic.getMerkleTreeFromComponents(components).root;
    expect(rootHashFromComponents, rootHash);
  });

  test('HashingLogic.getSignedBatchMerkleTreeComponents', () {
    var components = HashingLogic.getSignedMerkleTreeComponents([emailAttestation, phoneAttestation],
        emailIssuedClaimNode.issuance.issuanceDate, emailIssuedClaimNode.issuance.expirationDate, alicePrivkey);

    var requestNonce = HashingLogic.generateNonce();

    var bobSubjectSig = signTypedData(
        bobPrivkey,
        MsgParams(
          data: HashingLogic.getAttestationAgreement(contractAddress, 1, components.layer2Hash, requestNonce)
              as TypedData,
        ));

    var batchComponents = HashingLogic.getSignedBatchMerkleTreeComponents(
        components, contractAddress, bobSubjectSig, bobAddress, requestNonce, alicePrivkey);

    expect(validBatchComponentVersions.indexOf(batchComponents.version), greaterThan(-1));

    // batch should have same length as non-batch
    expect(batchComponents.paddingNodes.length, components.paddingNodes.length);

    batchComponents.paddingNodes.forEach((p) => expect(p.length, 66));

    // checksum should be the same as non-batch
    var checksum = HashingLogic.getChecksum(
        batchComponents.claimNodes.map((a) => HashingLogic.hashMessage(a.attesterSig)).toList());
    expect(
        ethUtil.bufferToHex(checksum),
        ethUtil.bufferToHex(HashingLogic.getChecksum(
            components.claimNodes.map((a) => HashingLogic.hashMessage(a.attesterSig)).toList())));

    expect(batchComponents.checksumSig, components.checksumSig);

    expect(batchComponents.rootHash, components.rootHash);
    expect(batchComponents.requestNonce, requestNonce);
    expect(batchComponents.requestNonce, isNot(components.rootHashNonce));

    var layer2Hash = HashingLogic.hashMessage(HashingLogic.orderedStringify({
      "subjectSig": batchComponents.subjectSig,
      "attesterSig": batchComponents.batchAttesterSig,
    }));
    expect(layer2Hash, batchComponents.batchLayer2Hash);
    expect(batchComponents.batchLayer2Hash, isNot(components.layer2Hash));

    var rootHashFromComponents = HashingLogic.getMerkleTreeFromComponents(batchComponents).root;
    expect(rootHashFromComponents, HashingLogic.getMerkleTreeFromComponents(components).root);

    var recoveredAttester = HashingLogic.recoverHashSigner(
        ethUtil.toBuffer(HashingLogic.hashMessage(HashingLogic.orderedStringify({
          "subject": bobAddress,
          "rootHash": batchComponents.layer2Hash,
        }))),
        batchComponents.batchAttesterSig);
    expect(recoveredAttester.toLowerCase(), aliceWallet.getAddressString().toLowerCase());
    var recoveredSubject = recoverTypedSignature(MsgParams(
      data: HashingLogic.getAttestationAgreement(
          batchComponents.contractAddress, 1, batchComponents.layer2Hash, batchComponents.requestNonce) as TypedData,
      sig: batchComponents.subjectSig,
    ));
    expect(recoveredSubject.toLowerCase(), batchComponents.subject);
  });

  test('HashingLogic.getSignedBatchMerkleTreeComponents sig validation', () {
    var components = HashingLogic.getSignedMerkleTreeComponents([emailAttestation, phoneAttestation],
        emailIssuedClaimNode.issuance.issuanceDate, emailIssuedClaimNode.issuance.expirationDate, alicePrivkey);

    var requestNonce = HashingLogic.generateNonce();

    var bobInvalidSubjectSig = signTypedData(
        bobPrivkey,
        MsgParams(
          data: HashingLogic.getAttestationAgreement(contractAddress, 1,
              '0xe6d7e6ae812a8ff7bd44f928b199806446c2170412df381efb41d8f47fcd045c', requestNonce) as TypedData,
        ));

    expect(
        () => HashingLogic.getSignedBatchMerkleTreeComponents(
            components, contractAddress, bobInvalidSubjectSig, bobAddress, requestNonce, alicePrivkey),
        throwsArgumentError);
  });

  test('HashingLogic getAttestationAgreement' + ' - has not been modified', () {
    var dataHash = preComputedHashes["rootHash"];
    const nonce = '0xd5d7e6ae812a8ff7bd44f928b199806446c2170412df381efb41d8f47fcd044b';

    // If this fails something changed
    expect(jsonEncode(HashingLogic.getAttestationAgreement(contractAddress, 1, dataHash, nonce).toJson()),
        jsonEncode(preComputedAgreement.toJson()));
  });
}
