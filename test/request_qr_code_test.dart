import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_kit/share_kit.dart';

void main() {
  testWidgets('renders the qr code', (WidgetTester tester) async {
    await tester.pumpWidget(_TestApp());
    await tester.pumpAndSettle();
    await expectLater(find.byType(RequestQRCode), findsOneWidget);
    await expectLater(
        find.byType(RequestQRCode),
        matchesGoldenFile(
            'golden/request_qr_code_test/renders_the_qr_code.png'));
  });
}

class _TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: RequestQRCode(
                    requestData: RequestData(
      action: Action.request_attestation_data,
      token: 'a08714b92346a1bba4262ed575d23de3ff3e6b5480ad0e1c82c011bab0411fdf',
      url: 'https://receive-kit.bloom.co/api/receive',
      org_logo_url: 'https://bloom.co/images/notif/bloom-logo.png',
      org_name: 'Bloom',
      org_usage_policy_url: 'https://bloom.co/legal/terms',
      org_privacy_policy_url: 'https://bloom.co/legal/privacy',
      types: [AttestationTypeID.phone, AttestationTypeID.email],
    )))));
  }
}
