// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestData _$RequestDataFromJson(Map<String, dynamic> json) {
  return RequestData(
      action: _$enumDecodeNullable(_$ActionEnumMap, json['action']),
      token: json['token'] as String,
      url: json['url'] as String,
      org_logo_url: json['org_logo_url'] as String,
      org_name: json['org_name'] as String,
      org_usage_policy_url: json['org_usage_policy_url'] as String,
      org_privacy_policy_url: json['org_privacy_policy_url'] as String,
      types: (json['types'] as List)?.map((e) => _$enumDecodeNullable(_$AttestationTypeIDEnumMap, e))?.toList());
}

Map<String, dynamic> _$RequestDataToJson(RequestData instance) => <String, dynamic>{
      'action': _$ActionEnumMap[instance.action],
      'token': instance.token,
      'url': instance.url,
      'org_logo_url': instance.org_logo_url,
      'org_name': instance.org_name,
      'org_usage_policy_url': instance.org_usage_policy_url,
      'org_privacy_policy_url': instance.org_privacy_policy_url,
      'types': instance.types?.map((e) => _$AttestationTypeIDEnumMap[e])?.toList()
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError('`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$ActionEnumMap = <Action, dynamic>{Action.request_attestation_data: 'request_attestation_data'};

const _$AttestationTypeIDEnumMap = <AttestationTypeID, dynamic>{
  AttestationTypeID.phone: 'phone',
  AttestationTypeID.email: 'email',
  AttestationTypeID.facebook: 'facebook',
  AttestationTypeID.sanction_screen: 'sanction_screen',
  AttestationTypeID.pep_screen: 'pep_screen',
  AttestationTypeID.id_document: 'id_document',
  AttestationTypeID.google: 'google',
  AttestationTypeID.linkedin: 'linkedin',
  AttestationTypeID.twitter: 'twitter',
  AttestationTypeID.payroll: 'payroll',
  AttestationTypeID.ssn: 'ssn',
  AttestationTypeID.criminal: 'criminal',
  AttestationTypeID.offense: 'offense',
  AttestationTypeID.driving: 'driving',
  AttestationTypeID.employment: 'employment',
  AttestationTypeID.education: 'education',
  AttestationTypeID.drug: 'drug',
  AttestationTypeID.bank: 'bank',
  AttestationTypeID.utility: 'utility',
  AttestationTypeID.income: 'income',
  AttestationTypeID.assets: 'assets',
  AttestationTypeID.full_name: 'full_name',
  AttestationTypeID.birth_date: 'birth_date',
  AttestationTypeID.gender: 'gender',
  AttestationTypeID.group: 'group',
  AttestationTypeID.meta: 'meta',
  AttestationTypeID.office: 'office',
  AttestationTypeID.credential: 'credential',
  AttestationTypeID.medical: 'medical',
  AttestationTypeID.biometric: 'biometric',
  AttestationTypeID.supplemental: 'supplemental',
  AttestationTypeID.vouch: 'vouch',
  AttestationTypeID.audit: 'audit',
  AttestationTypeID.address: 'address',
  AttestationTypeID.correction: 'correction',
  AttestationTypeID.account: 'account'
};
