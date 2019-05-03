import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:share_kit/share_kit.dart';
import 'package:storyboard/storyboard.dart';

import 'defaults.dart';
import 'button_story.dart';

/// The request button will be removed on tap
class ButtonRemoveOnTapStory extends Story {
  @override
  List<Widget> get storyContent => [_ButtonRemoveOnTapStoryWidget()];
}

class _ButtonRemoveOnTapStoryWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ButtonRemoveOnTapStoryState();
  }
}

class _ButtonRemoveOnTapStoryState
    extends State<_ButtonRemoveOnTapStoryWidget> {
  bool _requestButtonRemoved = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(
          child: RequestButton(
            requestData: Defaults.defaultData,
            buttonCallbackUrl: Defaults.buttonCallbackUrl,
            requestButtonOnTapCallback: () => setState(() {
                  _requestButtonRemoved = true;
                }),
          ),
          visible: !_requestButtonRemoved,
        ),
      ],
    );
  }
}
