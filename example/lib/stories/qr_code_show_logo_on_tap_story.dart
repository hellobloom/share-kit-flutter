import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:qr/qr.dart';
import 'package:share_kit/share_kit.dart';
import 'package:storyboard/storyboard.dart';

import 'defaults.dart';

/// Basic button demo
class QrCodeShowLogoOnTapStory extends Story {
  @override
  List<Widget> get storyContent => [_QrCodeLogoStoryWidget()];
}

class _QrCodeLogoStoryWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QrCodeLogoStoryState();
  }
}

class _QrCodeLogoStoryState extends State<_QrCodeLogoStoryWidget> {
  bool hideLogo = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => setState(() => hideLogo = !hideLogo),
        child: Container(
            child: RequestQRCode(
          requestData: Defaults.defaultData,
          qrOptions: QROptions(
            hideLogo: hideLogo,
          ),
        )));
  }
}
