import 'package:json_annotation/json_annotation.dart';
import 'package:share_kit/src/attestations_lib/attestation_types.dart';

part 'hashing_logic_types.g.dart';

abstract class JsonEncodable {
  Map<String, dynamic> toJson();
}

@JsonSerializable(nullable: false)
class IAttestationData implements JsonEncodable {
  // tslint:disable:max-line-length
  /**
   * String representation of the attestations data.
   *
   * ### Examples ###
   * email: "test@bloom.co"
   * sanction-screen: {\"firstName\":\"FIRSTNAME\",\"middleName\":\"MIDDLENAME\",\"lastName\":\"LASTNAME\",\"birthMonth\":1,\"birthDay\":1,\"birthYear\":1900,\"id\":\"a1a1a1a...\"}
   *
   * Any attestation that isn't a single string value will be
   * a JSON string representing the attestation data.
   */
  // tslint:enable:max-line-length
  String data;

  /**
   * Attestation data nonce
   */
  String nonce;

  /**
   * Semantic version used to keep track of attestation versions
   */
  String version;

  IAttestationData({this.data, this.nonce, this.version});

  factory IAttestationData.fromJson(Map<String, dynamic> json) =>
      _$IAttestationDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IAttestationDataToJson(this);
}

@JsonSerializable(nullable: false)
class IAttestationType implements JsonEncodable {
  /**
   * The type of attestation (phone, email, etc.)
   */
  AttestationTypeID type;

  /**
   * Optionally identifies service used to perform attestation
   */
  String provider;

  /**
   * Attestation type nonce
   */
  String nonce;

  IAttestationType({this.type, this.provider, this.nonce});

  factory IAttestationType.fromJson(Map<String, dynamic> json) =>
      _$IAttestationTypeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IAttestationTypeToJson(this);
}

@JsonSerializable(nullable: false)
class IClaimNode implements JsonEncodable {
  IAttestationData data;
  IAttestationType type;

  /**
   * aux either contains a hash of IAuxSig or just a padding node hash
   */
  String aux;

  IClaimNode({this.data, this.type, this.aux});

  factory IClaimNode.fromJson(Map<String, dynamic> json) =>
      _$IClaimNodeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IClaimNodeToJson(this);
}

@JsonSerializable(nullable: false)
class IIssuanceNode implements JsonEncodable {
  /**
   * Hex string to identify this attestation node in the event of partial revocation
   */
  String localRevocationToken;

  /**
   * Hex string to identify this attestation in the event of revocation
   */
  String globalRevocationToken;

  /**
   * hash of data node attester is verifying
   */
  String dataHash;

  /**
   * hash of type node attester is verifying
   */
  String typeHash;

  /**
   * RFC3339 timestamp of when the claim was issued
   * https://tools.ietf.org/html/rfc3339
   */
  String issuanceDate;

  /**
   * RFC3339 timestamp of when the claim should expire
   * https://tools.ietf.org/html/rfc3339
   */
  String expirationDate;

  IIssuanceNode(
      {this.localRevocationToken,
      this.globalRevocationToken,
      this.dataHash,
      this.typeHash,
      this.issuanceDate,
      this.expirationDate});

  factory IIssuanceNode.fromJson(Map<String, dynamic> json) =>
      _$IIssuanceNodeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IIssuanceNodeToJson(this);
}

@JsonSerializable(nullable: false)
class IIssuedClaimNode extends IClaimNode implements JsonEncodable {
  IIssuanceNode issuance;

  IIssuedClaimNode({this.issuance, data, type, aux})
      : super(data: data, type: type, aux: aux);

  factory IIssuedClaimNode.fromJson(Map<String, dynamic> json) =>
      _$IIssuedClaimNodeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IIssuedClaimNodeToJson(this);
}

@JsonSerializable(nullable: false)
class ISignedClaimNode implements JsonEncodable {
  IIssuedClaimNode claimNode;
  String attester;
  String attesterSig;

  ISignedClaimNode(
      {this.claimNode,
      this.attester,
      this.attesterSig}); // Root hash of claim tree signed by attester

  factory ISignedClaimNode.fromJson(Map<String, dynamic> json) =>
      _$ISignedClaimNodeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ISignedClaimNodeToJson(this);
}

/**
 * Legacy types for constructing and interpreting Bloom Merkle Tree
 */
@JsonSerializable(nullable: false)
class IRevocationLinks implements JsonEncodable {
  /**
   * Hex string to identify this attestation node in the event of partial revocation
   */
  String local;

  /**
   * Hex string to identify this attestation in the event of revocation
   */
  String global;

  /**
   * hash of data node attester is verifying
   */
  String dataHash;

  /**
   * hash of type node attester is verifying
   */
  String typeHash;

  IRevocationLinks({this.local, this.global, this.dataHash, this.typeHash});

  factory IRevocationLinks.fromJson(Map<String, dynamic> json) =>
      _$IRevocationLinksFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IRevocationLinksToJson(this);
}

@JsonSerializable(nullable: false)
class IAttestationLegacy extends IClaimNode implements JsonEncodable {
  IAttestationLegacy({data, type, aux})
      : super(data: data, type: type, aux: aux);

  factory IAttestationLegacy.fromJson(Map<String, dynamic> json) =>
      _$IAttestationLegacyFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IAttestationLegacyToJson(this);
}

@JsonSerializable(nullable: false)
class IAttestationNode extends IAttestationLegacy implements JsonEncodable {
  IRevocationLinks link;

  IAttestationNode({this.link, data, type, aux})
      : super(data: data, type: type, aux: aux);

  factory IAttestationNode.fromJson(Map<String, dynamic> json) =>
      _$IAttestationNodeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IAttestationNodeToJson(this);
}

@JsonSerializable(nullable: false)
class IDataNodeLegacy implements JsonEncodable {
  IAttestationNode attestationNode;
  String signedAttestation;

  IDataNodeLegacy(
      {this.attestationNode,
      this.signedAttestation}); // Root hash of Attestation tree signed by attester

  factory IDataNodeLegacy.fromJson(Map<String, dynamic> json) =>
      _$IDataNodeLegacyFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IDataNodeLegacyToJson(this);
}

@JsonSerializable(nullable: false)
class IBloomMerkleTreeComponents implements JsonEncodable {
  String attester;
  String attesterSig;
  String checksumSig; // Attester signature of ordered array of dataNode hashes
  List<ISignedClaimNode> claimNodes;
  String layer2Hash; // Hash of merkle root and nonce
  List<String> paddingNodes;
  String rootHash; // The root the Merkle tree
  String rootHashNonce;
  String version;

  IBloomMerkleTreeComponents(
      {this.attester,
      this.attesterSig,
      this.checksumSig,
      this.claimNodes,
      this.layer2Hash,
      this.paddingNodes,
      this.rootHash,
      this.rootHashNonce,
      this.version});

  factory IBloomMerkleTreeComponents.fromJson(Map<String, dynamic> json) =>
      _$IBloomMerkleTreeComponentsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IBloomMerkleTreeComponentsToJson(this);
}

@JsonSerializable(nullable: false)
class IBloomBatchMerkleTreeComponents extends IBloomMerkleTreeComponents
    implements JsonEncodable {
  String batchAttesterSig;
  String batchLayer2Hash; // Hash of attester sig and subject sig
  String contractAddress;
  String requestNonce;
  String subject;
  String subjectSig;

  IBloomBatchMerkleTreeComponents(
      {this.batchAttesterSig,
      this.batchLayer2Hash,
      this.contractAddress,
      this.requestNonce,
      this.subject,
      this.subjectSig,
      attester,
      attesterSig,
      checksumSig,
      claimNodes,
      layer2Hash,
      paddingNodes,
      rootHash,
      rootHashNonce,
      version})
      : super(
            attester: attester,
            attesterSig: attesterSig,
            checksumSig: checksumSig,
            claimNodes: claimNodes,
            layer2Hash: layer2Hash,
            paddingNodes: paddingNodes,
            rootHash: rootHash,
            rootHashNonce: rootHashNonce,
            version: version);

  factory IBloomBatchMerkleTreeComponents.fromJson(Map<String, dynamic> json) =>
      _$IBloomBatchMerkleTreeComponentsFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$IBloomBatchMerkleTreeComponentsToJson(this);
}

@JsonSerializable(nullable: false)
class ITypedDataParam implements JsonEncodable {
  String name;
  String type;

  ITypedDataParam({this.name, this.type});

  factory ITypedDataParam.fromJson(Map<String, dynamic> json) =>
      _$ITypedDataParamFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ITypedDataParamToJson(this);
}

enum ChainName { Main, Rinkedby }

final Map<ChainName, int> ChainId =
    Map.unmodifiable(Map.from({ChainName.Main: 1, ChainName.Rinkedby: 4}));
