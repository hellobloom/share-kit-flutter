import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:share_kit/share_kit.dart';
import 'package:storyboard/storyboard.dart';

import 'button_story.dart';

class ButtonRemoveOnTapStory extends Story {
  @override
  List<Widget> get storyContent => [_ButtonRemoveStoryWidget()];
}

class _ButtonRemoveStoryWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ButtonRemoveStoryState();
  }
}

class _ButtonRemoveStoryState extends State<_ButtonRemoveStoryWidget> {
  bool _requestButtonRemoved = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(
          child: RequestButton(
            requestData: ButtonStory.defaultData,
            buttonCallbackUrl: ButtonStory.buttonCallbackUrl,
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
