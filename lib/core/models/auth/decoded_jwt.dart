class DecodedJwt {
  final String nameId;
  final String role;
  final String uniqueName;
  final String email;
  final String familyName;
  final String municipality;
  final int nbf;
  final int exp;
  final int iat;
  final String iss;
  final String aud;

  DecodedJwt({
    required this.nameId,
    required this.role,
    required this.uniqueName,
    required this.email,
    required this.familyName,
    required this.municipality,
    required this.nbf,
    required this.exp,
    required this.iat,
    required this.iss,
    required this.aud,
  });

  factory DecodedJwt.fromMap(Map<String, dynamic> map) {
    return DecodedJwt(
      nameId: map['nameid'],
      role: map['role'],
      uniqueName: map['unique_name'],
      email: map['email'],
      familyName: map['family_name'],
      municipality: map['municipality'],
      nbf: map['nbf'],
      exp: map['exp'],
      iat: map['iat'],
      iss: map['iss'],
      aud: map['aud'],
    );
  }
}
