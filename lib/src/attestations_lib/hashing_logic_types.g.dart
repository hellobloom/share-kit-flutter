// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hashing_logic_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IAttestationData _$IAttestationDataFromJson(Map<String, dynamic> json) {
  return IAttestationData(
      data: json['data'] as String,
      nonce: json['nonce'] as String,
      version: json['version'] as String);
}

Map<String, dynamic> _$IAttestationDataToJson(IAttestationData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'nonce': instance.nonce,
      'version': instance.version
    };

IAttestationType _$IAttestationTypeFromJson(Map<String, dynamic> json) {
  return IAttestationType(
      type: _$enumDecode(_$AttestationTypeIDEnumMap, json['type']),
      provider: json['provider'] as String,
      nonce: json['nonce'] as String);
}

Map<String, dynamic> _$IAttestationTypeToJson(IAttestationType instance) =>
    <String, dynamic>{
      'type': _$AttestationTypeIDEnumMap[instance.type],
      'provider': instance.provider,
      'nonce': instance.nonce
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

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

IClaimNode _$IClaimNodeFromJson(Map<String, dynamic> json) {
  return IClaimNode(
      data: IAttestationData.fromJson(json['data'] as Map<String, dynamic>),
      type: IAttestationType.fromJson(json['type'] as Map<String, dynamic>),
      aux: json['aux'] as String);
}

Map<String, dynamic> _$IClaimNodeToJson(IClaimNode instance) =>
    <String, dynamic>{
      'data': instance.data,
      'type': instance.type,
      'aux': instance.aux
    };

IIssuanceNode _$IIssuanceNodeFromJson(Map<String, dynamic> json) {
  return IIssuanceNode(
      localRevocationToken: json['localRevocationToken'] as String,
      globalRevocationToken: json['globalRevocationToken'] as String,
      dataHash: json['dataHash'] as String,
      typeHash: json['typeHash'] as String,
      issuanceDate: json['issuanceDate'] as String,
      expirationDate: json['expirationDate'] as String);
}

Map<String, dynamic> _$IIssuanceNodeToJson(IIssuanceNode instance) =>
    <String, dynamic>{
      'localRevocationToken': instance.localRevocationToken,
      'globalRevocationToken': instance.globalRevocationToken,
      'dataHash': instance.dataHash,
      'typeHash': instance.typeHash,
      'issuanceDate': instance.issuanceDate,
      'expirationDate': instance.expirationDate
    };

IIssuedClaimNode _$IIssuedClaimNodeFromJson(Map<String, dynamic> json) {
  return IIssuedClaimNode(
      issuance:
          IIssuanceNode.fromJson(json['issuance'] as Map<String, dynamic>),
      data: json['data'],
      type: json['type'],
      aux: json['aux']);
}

Map<String, dynamic> _$IIssuedClaimNodeToJson(IIssuedClaimNode instance) =>
    <String, dynamic>{
      'data': instance.data,
      'type': instance.type,
      'aux': instance.aux,
      'issuance': instance.issuance
    };

ISignedClaimNode _$ISignedClaimNodeFromJson(Map<String, dynamic> json) {
  return ISignedClaimNode(
      claimNode:
          IIssuedClaimNode.fromJson(json['claimNode'] as Map<String, dynamic>),
      attester: json['attester'] as String,
      attesterSig: json['attesterSig'] as String);
}

Map<String, dynamic> _$ISignedClaimNodeToJson(ISignedClaimNode instance) =>
    <String, dynamic>{
      'claimNode': instance.claimNode,
      'attester': instance.attester,
      'attesterSig': instance.attesterSig
    };

IRevocationLinks _$IRevocationLinksFromJson(Map<String, dynamic> json) {
  return IRevocationLinks(
      local: json['local'] as String,
      global: json['global'] as String,
      dataHash: json['dataHash'] as String,
      typeHash: json['typeHash'] as String);
}

Map<String, dynamic> _$IRevocationLinksToJson(IRevocationLinks instance) =>
    <String, dynamic>{
      'local': instance.local,
      'global': instance.global,
      'dataHash': instance.dataHash,
      'typeHash': instance.typeHash
    };

IAttestationLegacy _$IAttestationLegacyFromJson(Map<String, dynamic> json) {
  return IAttestationLegacy(
      data: IAttestationData.fromJson(json['data'] as Map<String, dynamic>),
      type: IAttestationType.fromJson(json['type'] as Map<String, dynamic>),
      aux: json['aux'] as String);
}

Map<String, dynamic> _$IAttestationLegacyToJson(IAttestationLegacy instance) =>
    <String, dynamic>{
      'data': instance.data,
      'type': instance.type,
      'aux': instance.aux
    };

IAttestationNode _$IAttestationNodeFromJson(Map<String, dynamic> json) {
  return IAttestationNode(
      link: IRevocationLinks.fromJson(json['link'] as Map<String, dynamic>),
      data: json['data'],
      type: json['type'],
      aux: json['aux']);
}

Map<String, dynamic> _$IAttestationNodeToJson(IAttestationNode instance) =>
    <String, dynamic>{
      'data': instance.data,
      'type': instance.type,
      'aux': instance.aux,
      'link': instance.link
    };

IDataNodeLegacy _$IDataNodeLegacyFromJson(Map<String, dynamic> json) {
  return IDataNodeLegacy(
      attestationNode: IAttestationNode.fromJson(
          json['attestationNode'] as Map<String, dynamic>),
      signedAttestation: json['signedAttestation'] as String);
}

Map<String, dynamic> _$IDataNodeLegacyToJson(IDataNodeLegacy instance) =>
    <String, dynamic>{
      'attestationNode': instance.attestationNode,
      'signedAttestation': instance.signedAttestation
    };

IBloomMerkleTreeComponents _$IBloomMerkleTreeComponentsFromJson(
    Map<String, dynamic> json) {
  return IBloomMerkleTreeComponents(
      attester: json['attester'] as String,
      attesterSig: json['attesterSig'] as String,
      checksumSig: json['checksumSig'] as String,
      claimNodes: (json['claimNodes'] as List)
          .map((e) => ISignedClaimNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      layer2Hash: json['layer2Hash'] as String,
      paddingNodes:
          (json['paddingNodes'] as List).map((e) => e as String).toList(),
      rootHash: json['rootHash'] as String,
      rootHashNonce: json['rootHashNonce'] as String,
      version: json['version'] as String);
}

Map<String, dynamic> _$IBloomMerkleTreeComponentsToJson(
        IBloomMerkleTreeComponents instance) =>
    <String, dynamic>{
      'attester': instance.attester,
      'attesterSig': instance.attesterSig,
      'checksumSig': instance.checksumSig,
      'claimNodes': instance.claimNodes,
      'layer2Hash': instance.layer2Hash,
      'paddingNodes': instance.paddingNodes,
      'rootHash': instance.rootHash,
      'rootHashNonce': instance.rootHashNonce,
      'version': instance.version
    };

IBloomBatchMerkleTreeComponents _$IBloomBatchMerkleTreeComponentsFromJson(
    Map<String, dynamic> json) {
  return IBloomBatchMerkleTreeComponents(
      batchAttesterSig: json['batchAttesterSig'] as String,
      batchLayer2Hash: json['batchLayer2Hash'] as String,
      contractAddress: json['contractAddress'] as String,
      requestNonce: json['requestNonce'] as String,
      subject: json['subject'] as String,
      subjectSig: json['subjectSig'] as String,
      attester: json['attester'],
      attesterSig: json['attesterSig'],
      checksumSig: json['checksumSig'],
      claimNodes: json['claimNodes'],
      layer2Hash: json['layer2Hash'],
      paddingNodes: json['paddingNodes'],
      rootHash: json['rootHash'],
      rootHashNonce: json['rootHashNonce'],
      version: json['version']);
}

Map<String, dynamic> _$IBloomBatchMerkleTreeComponentsToJson(
        IBloomBatchMerkleTreeComponents instance) =>
    <String, dynamic>{
      'attester': instance.attester,
      'attesterSig': instance.attesterSig,
      'checksumSig': instance.checksumSig,
      'claimNodes': instance.claimNodes,
      'layer2Hash': instance.layer2Hash,
      'paddingNodes': instance.paddingNodes,
      'rootHash': instance.rootHash,
      'rootHashNonce': instance.rootHashNonce,
      'version': instance.version,
      'batchAttesterSig': instance.batchAttesterSig,
      'batchLayer2Hash': instance.batchLayer2Hash,
      'contractAddress': instance.contractAddress,
      'requestNonce': instance.requestNonce,
      'subject': instance.subject,
      'subjectSig': instance.subjectSig
    };

ITypedDataParam _$ITypedDataParamFromJson(Map<String, dynamic> json) {
  return ITypedDataParam(
      name: json['name'] as String, type: json['type'] as String);
}

Map<String, dynamic> _$ITypedDataParamToJson(ITypedDataParam instance) =>
    <String, dynamic>{'name': instance.name, 'type': instance.type};
