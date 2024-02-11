import 'dart:convert';

class MessageModel {
  late String message;

  MessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

}
MessageModel messageResponseJson(String str) =>
    MessageModel.fromJson(jsonDecode(str));