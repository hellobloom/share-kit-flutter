import 'package:share_kit/share_kit.dart';
import 'package:share_kit/src/attestations_lib/attestation_types.dart';
import 'package:storyboard/storyboard.dart';

class Defaults {
  static final defaultData = RequestData(
    action: Action.request_attestation_data,
    token: 'a08714b92346a1bba4262ed575d23de3ff3e6b5480ad0e1c82c011bab0411fdf',
    url: 'https://receive-kit.bloom.co/api/receive',
    org_logo_url: 'https://bloom.co/images/notif/bloom-logo.png',
    org_name: 'Bloom',
    org_usage_policy_url: 'https://bloom.co/legal/terms',
    org_privacy_policy_url: 'https://bloom.co/legal/privacy',
    types: [AttestationTypeID.phone, AttestationTypeID.email],
  );

  static const buttonCallbackUrl = 'https://mysite.com/bloom-callback';
}
