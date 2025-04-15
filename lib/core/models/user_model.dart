import 'package:asrdb/core/helpers/jwt_decode_helper.dart';

class UserModel {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String municipalityId;

  UserModel(
      {required this.id,
      required this.name,
      required this.surname,
      required this.email,
      required this.municipalityId});

  factory UserModel.fromIdToken(String idToken) {
    var payload = JwtDecodeHelper.decodeJwtPayload(idToken);
    return UserModel(
      id: payload['nameid'],
      name: payload['unique_name'],
      surname: payload['family_name'],
      email: payload['email'],
      municipalityId: payload['municipality'],
    );
  }
  // Convert JSON to UserModel
  // factory UserModel.fromJson(Map<String, dynamic> json) {
  //   return UserModel(
  //     id: json['id'],
  //     name: json['name'],
  //     email: json['email'],
  //   );
  // }

  // // Convert UserModel to JSON
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'email': email,
  //   };
  // }

  // // Convert JSON string to UserModel
  // static UserModel fromJsonString(String jsonString) {
  //   return UserModel.fromJson(json.decode(jsonString));
  // }

  // // Convert UserModel to JSON string
  // String toJsonString() {
  //   return json.encode(toJson());
  // }
}
