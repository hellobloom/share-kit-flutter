import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:share_kit/share_kit.dart';
import 'package:storyboard/storyboard.dart';

import 'defaults.dart';

/// Basic button demo
class ButtonStory extends Story {
  @override
  List<Widget> get storyContent => [
        RequestButton(
          requestData: Defaults.defaultData,
          buttonCallbackUrl: Defaults.buttonCallbackUrl,
        )
      ];
}
