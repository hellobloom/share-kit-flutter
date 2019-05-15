import 'package:flutter/material.dart';
import 'package:bloom_share_kit/bloom_share_kit.dart';
import 'package:bloom_share_kit/src/elements/request_qr_code.dart';
import 'package:storyboard/storyboard.dart';

import 'defaults.dart';

/// Basic button demo
class QrCodeUpdatingStory extends Story {
  @override
  List<Widget> get storyContent => [_QrCodeUpdatingStoryWidget()];
}

class _QrCodeUpdatingStoryWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QrCodeUpdatingStoryState();
  }
}

class _QrCodeUpdatingStoryState extends State<_QrCodeUpdatingStoryWidget> {
  int counter = 1;

  String orgName = "Bloom 1";

  RequestData requestData;

  _QrCodeUpdatingStoryState() {
    requestData = RequestData(
      action: Defaults.defaultData.action,
      token: Defaults.defaultData.token,
      url: Defaults.defaultData.url,
      org_logo_url: Defaults.defaultData.org_logo_url,
      org_name: orgName,
      org_usage_policy_url: Defaults.defaultData.org_usage_policy_url,
      org_privacy_policy_url: Defaults.defaultData.org_privacy_policy_url,
      types: Defaults.defaultData.types,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            counter++;
            orgName = "Bloom ${counter}";
            requestData.org_name = orgName;
          });
        },
        child: Container(child: RequestQRCode(requestData: requestData)));
  }
}
