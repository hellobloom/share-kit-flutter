import 'package:flutter/material.dart';
import 'package:storyboard/storyboard.dart';

import 'stories/stories.dart';

void main() => runApp(new MaterialApp(
    home: new Storyboard([ButtonStory(), ButtonRemoveOnTapStory()])));
