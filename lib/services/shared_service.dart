import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login/login_response_model.dart';

class SharedService {
  static late SharedPreferences prefs;
  static bool isAuth = false;
  static int role = -1;
  static late String sapId;
  static late DateTime eventEndTime;
  static late String eventId;
  static late bool networkConnected = false;



  static Future<void> isLoggedIn() async {
    if (!isAuth) {
      prefs = await SharedPreferences.getInstance();
      isAuth = prefs.containsKey("accessToken");
      if(isAuth){
        role = prefs.getInt('role')!;
        sapId = prefs.getString("sapId")!;
      }
    }
  }

  static Future<LoginResponseModel?> getLoginDetails() async {
    String? cacheAccessToken = prefs.getString("accessToken");
    int? cacheRole = prefs.getInt("role");
    final Map<String, dynamic> jsonData = {
      "accessToken": cacheAccessToken,
      "role": cacheRole
    };
    return loginResponseJson(json.encode(jsonData));
  }

  static void setLoginDetails(LoginResponseModel model, String sap) {
    prefs.setString("accessToken", model.accessToken);
    prefs.setInt("role", model.role);
    prefs.setString("sapId", sap);
    role=model.role;
    sapId = sap ;
  }

  static Future<void> logout(BuildContext context) async {
    prefs.clear();

    //TODO add navigator to login page
    if (kDebugMode) {
      print("logged out");
    }
  }
}
