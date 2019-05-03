import 'dart:core';
import 'dart:ui';

import 'package:convert/convert.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:merkletree/merkletree.dart' show MerkleProof;
import 'package:qr/qr.dart';
import 'package:share_kit/src/attestations_lib/attestation_types.dart'
    show AttestationTypeID;
import 'package:share_kit/src/attestations_lib/hashing_logic_types.dart'
    as HashingLogicTypes;

part 'types.g.dart';

// Request Types

enum Action { request_attestation_data }

@JsonSerializable(nullable: true)
class RequestData {
  Action action;
  String token;
  String url;
  String org_logo_url;
  String org_name;
  String org_usage_policy_url;
  String org_privacy_policy_url;
  List<AttestationTypeID> types;

  RequestData(
      {this.action,
      this.token,
      this.url,
      this.org_logo_url,
      this.org_name,
      this.org_usage_policy_url,
      this.org_privacy_policy_url,
      this.types});

  factory RequestData.fromJson(Map<String, dynamic> json) =>
      _$RequestDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RequestDataToJson(this);
}

class QROptions {
  int ecLevel;
  double size;
  Color bgColor;
  Color fgColor;
  bool hideLogo;
  double padding;
  String logoImage;
  double logoWidth;
  double logoHeight;
  double logoOpacity;

  QROptions(
      {int ecLevel,
      double size,
      Color bgColor,
      Color fgColor,
      bool hideLogo,
      double padding,
      this.logoImage,
      this.logoWidth,
      this.logoHeight,
      this.logoOpacity})
      : this.ecLevel = ecLevel ?? QrErrorCorrectLevel.L,
        this.size = size ?? 128.0,
        this.bgColor = bgColor ?? Color(0xfffffff),
        this.fgColor = fgColor ?? Color(0xff6067f1),
        this.hideLogo = hideLogo ?? false,
        this.padding = padding ?? 0;
}

// START - DO NOT EXPORT
// These are temporary until bowser defines types
class ParsedResult {
  Details browser;
  OSDetails os;
  PlatformDetails platform;
  Details engine;

  ParsedResult(this.browser, this.os, this.platform, this.engine);
}

class Details {
  String name;
  List<dynamic> version;

  Details({this.name, this.version});
}

class OSDetails extends Details {
  Details versionName;

  OSDetails({name, version, this.versionName})
      : super(name: name, version: version);
}

class PlatformDetails {
  String type;
  String vendor;
  String model;

  PlatformDetails({this.type, this.vendor, this.model});
}
// END - DO NOT EXPORT

typedef bool ShouldRenderButton(ParsedResult parsedResult);

class RequestElementResultUpdateConfig {
  RequestData requestData;
  String buttonCallbackUrl;
  QROptions qrOptions;

  RequestElementResultUpdateConfig(this.requestData, this.buttonCallbackUrl,
      {this.qrOptions});
}

typedef void RequestElementResultUpdateFunction(
    RequestElementResultUpdateConfig config);
typedef void RequestElementResultRemoveFunction();

class RequestElementResult {
  RequestElementResultUpdateFunction update;
  RequestElementResultRemoveFunction remove;
}

// Response Types

/**
 * Based on IProof from `merkletreejs`, but the data property is a String
 * which should contain the hex String representation of a Buffer for
 * compatibility when serializing / deserializing.
 */
class IProofShare {
  String position;
  String data;

  IProofShare(MerkleProof proof) {
    this.position = proof.position.toString();
    this.data = hex.encode(proof.data);
  }
}

/**
 * Represents the data shared by a user, which has been attested on the Bloom Protocol.
 * Receivers of this data can / should verity this data hasn't been tampered with.
 */
class IVerifiedData {
  /**
   * Blockchain transaction hash which emits the layer2Hash property
   */
  String tx;

  /**
   * Attestation hash that lives on chain and is formed by hashing the merkle
   * tree root hash with a nonce.
   */
  String layer2Hash;

  /**
   * Merkle tree root hash
   */
  String rootHash;

  /**
   * Nonce used to hash the `rootHash` to create the `layer2Hash`
   */
  String rootHashNonce;

  /**
   * Merkle tree leaf proof
   */
  List<IProofShare> proof;

  /**
   * The Ethereum network name on which the tx can be found
   */
  IVerifiedDataState stage;

  /**
   * Data node containing the raw verified data that was requested
   */
  HashingLogicTypes.IDataNode target;

  /**
   * Ethereum address of the attester that performed the attestation
   */
  String attester;
}

enum IVerifiedDataState { mainnet, rinkedby, local }

class ResponseData {
  /**
   * The Ethereum address of the user sharing their data
   */
  String subject;

  /**
   * Data shared to the receiving endpoint requested by the share-kit QR code.
   * This data can be verified by the receiver via functions in utils.ts.
   */
  List<IVerifiedData> data;

  /**
   * Hex String representation of the `data` being keccak256 hashed
   */
  String packedData;

  /**
   * Signature of `packedData` by the user with their mnemonic.
   */
  String signature;

  /**
   * Token that should match the one provided to the share-kit QR code.
   */
  String token;
}
