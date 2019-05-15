import 'package:flutter_test/flutter_test.dart';

import 'package:share_kit/src/attestations_lib/attestation_types.dart';

void main() {
  test('AttestationTypes.getAttestationTypeAttrib does not throw', () {
    AttestationTypeID.values.forEach((id) {
      expect(getAttestationTypeStr(id), AttestationTypes[id].name);
      expect(getBloomIDStrength(id), AttestationTypes[id].scoreWeight);
      expect(getFormattedName(id), AttestationTypes[id].nameFriendly);
    });
  });
}
