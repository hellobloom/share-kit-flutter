import 'package:meta/meta.dart';

enum AttestationTypeID {
  phone,
  email,
  facebook,
  sanction_screen,
  pep_screen,
  id_document,
  google,
  linkedin,
  twitter,
  payroll,
  ssn,
  criminal,
  offense,
  driving,
  employment,
  education,
  drug,
  bank,
  utility,
  income,
  assets,
  full_name,
  birth_date,
  gender,
  group,
  meta,
  office,
  credential,
  medical,
  biometric,
  supplemental,
  vouch,
  audit,
  address,
  correction,
  account
}

class AttestationType {
  AttestationTypeID id;
  num scoreWeight;
  String nameFriendly;
  String name;

  AttestationType(
      {@required this.id,
      @required this.scoreWeight,
      @required this.nameFriendly,
      @required this.name});
}

// FIXME: AttestationTypeManifest = Map<AttestationTypeID, AttestationType>

final Map<AttestationTypeID, AttestationType> AttestationTypes =
    Map.unmodifiable(Map<AttestationTypeID, AttestationType>.fromEntries([
  MapEntry(
      AttestationTypeID.phone,
      AttestationType(
          id: AttestationTypeID.phone,
          scoreWeight: 5,
          nameFriendly: "Phone",
          name: "phone")),
  MapEntry(
      AttestationTypeID.email,
      AttestationType(
          id: AttestationTypeID.email,
          scoreWeight: 5,
          nameFriendly: "Email",
          name: "email")),
  MapEntry(
      AttestationTypeID.facebook,
      AttestationType(
          id: AttestationTypeID.facebook,
          scoreWeight: 5,
          nameFriendly: "Facebook",
          name: "facebook")),
  MapEntry(
      AttestationTypeID.sanction_screen,
      AttestationType(
          id: AttestationTypeID.sanction_screen,
          scoreWeight: 10,
          nameFriendly: "Sanction Screen",
          name: "sanction_screen")),
  MapEntry(
      AttestationTypeID.pep_screen,
      AttestationType(
          id: AttestationTypeID.pep_screen,
          scoreWeight: 10,
          nameFriendly: "PEP Screen",
          name: "pep_screen")),
  MapEntry(
      AttestationTypeID.id_document,
      AttestationType(
          id: AttestationTypeID.id_document,
          scoreWeight: 20,
          nameFriendly: "ID Document",
          name: "id_document")),
  MapEntry(
      AttestationTypeID.google,
      AttestationType(
          id: AttestationTypeID.google,
          scoreWeight: 5,
          nameFriendly: "Google",
          name: "google")),
  MapEntry(
      AttestationTypeID.linkedin,
      AttestationType(
          id: AttestationTypeID.linkedin,
          scoreWeight: 5,
          nameFriendly: "LinkedIn",
          name: "linkedin")),
  MapEntry(
      AttestationTypeID.twitter,
      AttestationType(
          id: AttestationTypeID.twitter,
          scoreWeight: 5,
          nameFriendly: "Twitter",
          name: "twitter")),
  MapEntry(
      AttestationTypeID.payroll,
      AttestationType(
          id: AttestationTypeID.payroll,
          scoreWeight: 15,
          nameFriendly: "Payroll",
          name: "payroll")),
  MapEntry(
      AttestationTypeID.ssn,
      AttestationType(
          id: AttestationTypeID.ssn,
          scoreWeight: 15,
          nameFriendly: "Social Security Number",
          name: "ssn")),
  MapEntry(
      AttestationTypeID.criminal,
      AttestationType(
          id: AttestationTypeID.criminal,
          scoreWeight: 15,
          nameFriendly: "Criminal Records",
          name: "criminal")),
  MapEntry(
      AttestationTypeID.offense,
      AttestationType(
          id: AttestationTypeID.offense,
          scoreWeight: 10,
          nameFriendly: "Offense Records",
          name: "offense")),
  MapEntry(
      AttestationTypeID.driving,
      AttestationType(
          id: AttestationTypeID.driving,
          scoreWeight: 15,
          nameFriendly: "Driving Records",
          name: "driving")),
  MapEntry(
      AttestationTypeID.employment,
      AttestationType(
          id: AttestationTypeID.employment,
          scoreWeight: 15,
          nameFriendly: "Employment",
          name: "employment")),
  MapEntry(
      AttestationTypeID.education,
      AttestationType(
          id: AttestationTypeID.education,
          scoreWeight: 10,
          nameFriendly: "Education",
          name: "education")),
  MapEntry(
      AttestationTypeID.drug,
      AttestationType(
          id: AttestationTypeID.drug,
          scoreWeight: 5,
          nameFriendly: "Drug Screen",
          name: "drug")),
  MapEntry(
      AttestationTypeID.bank,
      AttestationType(
          id: AttestationTypeID.bank,
          scoreWeight: 15,
          nameFriendly: "Bank Statement",
          name: "bank")),
  MapEntry(
      AttestationTypeID.utility,
      AttestationType(
          id: AttestationTypeID.utility,
          scoreWeight: 10,
          nameFriendly: "Utility Statements",
          name: "utility")),
  MapEntry(
      AttestationTypeID.income,
      AttestationType(
          id: AttestationTypeID.income,
          scoreWeight: 15,
          nameFriendly: "Income Verification",
          name: "income")),
  MapEntry(
      AttestationTypeID.assets,
      AttestationType(
          id: AttestationTypeID.assets,
          scoreWeight: 15,
          nameFriendly: "Assets Verification",
          name: "assets")),
  MapEntry(
      AttestationTypeID.full_name,
      AttestationType(
          id: AttestationTypeID.full_name,
          scoreWeight: 5,
          nameFriendly: "Full Name",
          name: "full_name")),
  MapEntry(
      AttestationTypeID.birth_date,
      AttestationType(
          id: AttestationTypeID.birth_date,
          scoreWeight: 5,
          nameFriendly: "Date of Birth",
          name: "birth_date")),
  MapEntry(
      AttestationTypeID.gender,
      AttestationType(
          id: AttestationTypeID.gender,
          scoreWeight: 5,
          nameFriendly: "Gender",
          name: "gender")),
  MapEntry(
      AttestationTypeID.group,
      AttestationType(
          id: AttestationTypeID.group,
          scoreWeight: 5,
          nameFriendly: "Group",
          name: "group")),
  MapEntry(
      AttestationTypeID.meta,
      AttestationType(
          id: AttestationTypeID.meta,
          scoreWeight: 20,
          nameFriendly: "Meta-attestation",
          name: "meta")),
  MapEntry(
      AttestationTypeID.office,
      AttestationType(
          id: AttestationTypeID.office,
          scoreWeight: 5,
          nameFriendly: "Office/Position",
          name: "office")),
  MapEntry(
      AttestationTypeID.credential,
      AttestationType(
          id: AttestationTypeID.credential,
          scoreWeight: 5,
          nameFriendly: "Credential",
          name: "credential")),
  MapEntry(
      AttestationTypeID.medical,
      AttestationType(
          id: AttestationTypeID.medical,
          scoreWeight: 0,
          nameFriendly: "Medical Information",
          name: "medical")),
  MapEntry(
      AttestationTypeID.biometric,
      AttestationType(
          id: AttestationTypeID.biometric,
          scoreWeight: 20,
          nameFriendly: "Biometric Information",
          name: "biometric")),
  MapEntry(
      AttestationTypeID.supplemental,
      AttestationType(
          id: AttestationTypeID.supplemental,
          scoreWeight: 0,
          nameFriendly: "Supplemental Information",
          name: "supplemental")),
  MapEntry(
      AttestationTypeID.vouch,
      AttestationType(
          id: AttestationTypeID.vouch,
          scoreWeight: 0,
          nameFriendly: "Vouching",
          name: "vouch")),
  MapEntry(
      AttestationTypeID.audit,
      AttestationType(
          id: AttestationTypeID.audit,
          scoreWeight: 0,
          nameFriendly: "Audit",
          name: "audit")),
  MapEntry(
      AttestationTypeID.address,
      AttestationType(
          id: AttestationTypeID.address,
          scoreWeight: 5,
          nameFriendly: "Address",
          name: "address")),
  MapEntry(
      AttestationTypeID.correction,
      AttestationType(
          id: AttestationTypeID.correction,
          scoreWeight: 0,
          nameFriendly: "Correction",
          name: "correction")),
  MapEntry(
      AttestationTypeID.account,
      AttestationType(
          id: AttestationTypeID.account,
          scoreWeight: 5,
          nameFriendly: "Account",
          name: "account")),
]));

String getAttestationTypeStr(AttestationTypeID id) {
  return AttestationTypes[id].name;
}

num getBloomIDStrength(AttestationTypeID id) {
  return AttestationTypes[id].scoreWeight;
}

String getFormattedName(AttestationTypeID id) {
  return AttestationTypes[id].nameFriendly;
}

enum AttestationStatus {
  initial,
  ready,
  complete,
  rejected,
}
