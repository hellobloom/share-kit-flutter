import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:ethereum_util/ethereum_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:bloom_share_kit/bloom_share_kit.dart' show RequestButton, RequestData;
import 'package:storyboard/storyboard.dart';

import 'defaults.dart';

/// The request token is updated every time on tap
class ButtonUpdateOnTapStory extends Story {
  @override
  List<Widget> get storyContent => [_ButtonUpdateOnTapStoryWidget()];
}

class _ButtonUpdateOnTapStoryWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ButtonUpdateOnTapStoryState();
  }
}

class _ButtonUpdateOnTapStoryState extends State<_ButtonUpdateOnTapStoryWidget> {
  RequestData _requestData = Defaults.defaultData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RequestButton(
          requestData: _requestData,
          buttonCallbackUrl: Defaults.buttonCallbackUrl,
          requestButtonOnTapCallback: () => setState(() {
                _requestData.token = hex.encode(DartRandom(Random.secure()).nextBytes(32));
              }),
        ),
        Container(width: 200, child: Text(jsonEncode(_requestData.toJson())))
      ],
    );
  }
}
