import 'dart:convert';

class UserModel {
  final int id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email});

  // Convert JSON to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  // Convert JSON string to UserModel
  static UserModel fromJsonString(String jsonString) {
    return UserModel.fromJson(json.decode(jsonString));
  }

  // Convert UserModel to JSON string
  String toJsonString() {
    return json.encode(toJson());
  }
}
