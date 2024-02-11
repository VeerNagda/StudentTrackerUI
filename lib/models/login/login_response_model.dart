import 'dart:convert';

LoginResponseModel loginResponseJson(String str) =>
    LoginResponseModel.fromJson(jsonDecode(str));

class LoginResponseModel {
  late String _accessToken;
  late int _role;

  LoginResponseModel({
    required String accessToken,
    required int role,
  }) {
    _accessToken = accessToken;
    _role = role;
  }

  String get accessToken => _accessToken;

  set accessToken(String value) {
    _accessToken = value;
  }

  int get role => _role;

  set role(int value) {
    _role = value;
  }

  // Method to create class from JSON
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'],
      role: json['role'],
    );
  }

  // Method to convert class to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = _accessToken;
    data['role'] = _role;
    return data;
  }
}
