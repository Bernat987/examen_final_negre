import 'dart:convert';

class LoginModel {
  LoginModel({
    this.id,
    this.email,
    required this.password,
    required this.saveCredentials
  }) {
      this.email = email;
      this.password = password;
      this.saveCredentials = saveCredentials;
    
  }

  int? id;
  String? email;
  String password;
  bool saveCredentials;

  factory LoginModel.fromJson(String str) => LoginModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginModel.fromMap(Map<String,dynamic> json) => LoginModel(
    id: json["id"],
    email: json["email"],
    password: json["password"],
    saveCredentials: json["saveCredentials"]
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "email": email,
    "password": password,
    "saveCredentials": saveCredentials
  };
}