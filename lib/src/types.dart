import 'dart:core';
import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:qr/qr.dart';
import 'package:share_kit/src/attestations_lib/attestation_types.dart'
    show AttestationTypeID;

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
