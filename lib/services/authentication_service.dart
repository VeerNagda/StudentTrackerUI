import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class AuthenticationService {
  String baseUrl = Constants.baseUri; // Replace with your API base URL

  Future<String?> authenticateUser(String uID, String pass) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/authenticate'), // Replace '/authenticate' with your authentication endpoint
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'uID': uID,
          'pass': pass,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String? accessToken = responseData['accessToken'];
        return accessToken;
      } else {
        print('Failed to authenticate user. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception while authenticating user: $e');
      return null;
    }
  }
}
