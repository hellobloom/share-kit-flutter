import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_kit/share_kit.dart';

void main() {
  testWidgets('renders a button', (WidgetTester tester) async {
    await tester.pumpWidget(_TestApp());
    await tester.pumpAndSettle();
    expect(find.byType(RequestButton), findsOneWidget);
    await expectLater(find.byType(_TestApp),
        matchesGoldenFile('golden/request_button_test/renders_a_button.png'));
  });

  testWidgets('updates the button', (WidgetTester tester) async {
    await tester.pumpWidget(_TestApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(_TestAppState.keyUpdate));
    await tester.pumpAndSettle();
    _TestAppState testAppState = tester.state(find.byType(_TestApp));
    expect(testAppState.buttonCallbackUrl, 'http://updated.com');
    await tester.tap(find.byKey(_TestAppState.keyRequestButton));
    await tester.pumpAndSettle();
    expect(TestUrlLauncher.lanunchedUrl,
        stringContainsInOrder([Uri.encodeComponent('http://updated.com')]));
  });

  testWidgets('deletes the button', (WidgetTester tester) async {
    await tester.pumpWidget(_TestApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(_TestAppState.keyDelete));
    await tester.pumpAndSettle();
    _TestAppState testAppState = tester.state(find.byType(_TestApp));
    expect(testAppState.requestButtonDeleted, true);
    await expectLater(find.byType(_TestApp),
        matchesGoldenFile('golden/request_button_test/deletes_the_button.png'));
  });
}

class _TestApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestAppState(
        requestData: RequestData(
          action: Action.request_attestation_data,
          token:
              'a08714b92346a1bba4262ed575d23de3ff3e6b5480ad0e1c82c011bab0411fdf',
          url: 'https://receive-kit.bloom.co/api/receive',
          org_logo_url: 'https://bloom.co/images/notif/bloom-logo.png',
          org_name: 'Bloom',
          org_usage_policy_url: 'https://bloom.co/legal/terms',
          org_privacy_policy_url: 'https://bloom.co/legal/privacy',
          types: [AttestationTypeID.phone, AttestationTypeID.email],
        ),
        buttonCallbackUrl: 'https://mysite.com/bloom-callback');
  }
}

class _TestAppState extends State<_TestApp> {
  static final Key keyRequestButton = Key('RequestButton');

  static final Key keyUpdate = Key('Update');

  static final Key keyDelete = Key('Delete');

  RequestData requestData;

  String buttonCallbackUrl;

  bool requestButtonDeleted;

  _TestAppState({this.buttonCallbackUrl, this.requestData})
      : requestButtonDeleted = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Visibility(
            visible: !requestButtonDeleted,
            child: RequestButton(
              key: keyRequestButton,
              requestData: requestData,
              buttonCallbackUrl: buttonCallbackUrl,
              urlLauncher: TestUrlLauncher(),
            )),
        FlatButton(
            key: keyUpdate, child: Text("Update"), onPressed: _onUpdatePressed),
        FlatButton(
            key: keyDelete, child: Text("Delete"), onPressed: _onDeletePressed),
      ],
    ))));
  }

  @override
  void didUpdateWidget(_TestApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('updated widget');
  }

  _onUpdatePressed() {
    setState(() {
      buttonCallbackUrl = "http://updated.com";
    });
  }

  _onDeletePressed() {
    setState(() {
      requestButtonDeleted = true;
    });
  }
}

class TestUrlLauncher implements RequestButtonUrlLauncher {
  static String lanunchedUrl = '';

  @override
  void launchUrl(String url) {
    lanunchedUrl = url;
  }
}
