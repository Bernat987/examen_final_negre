import 'dart:convert';

class LoginModel {
  LoginModel({
    this.id,
    this.email,
    required this.password
  }) {
      this.email = email;
      this.password = password;
    
  }

  int? id;
  String? email;
  String password;

  factory LoginModel.fromJson(String str) => LoginModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginModel.fromMap(Map<String,dynamic> json) => LoginModel(
    id: json["id"],
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "email": email,
    "password": password
  };
}