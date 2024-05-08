import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ui/models/user/user_response_model.dart';
import '../models/login/login_response_model.dart';

class SharedService {
  static late SharedPreferences prefs;
  static bool isAuth = false;
  static int role = -1;
  static late String sapId;
  static late DateTime eventEndTime;
  static late String eventId;
  static bool networkConnected = false;



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
  static void setUserDetails(UserResponseModel user) {
    SharedService.prefs.setString("fName", user.fName);
    SharedService.prefs.setString("lName", user.lName);
    SharedService.prefs.setString("phone", user.phone);
    SharedService.prefs.setString("email", user.email);
    SharedService.prefs.setString("roll_no", user.rollNo);
  }


  Future<bool> checkLocationService() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) {
        return false;
      }
    }

    permissionGranted = await Permission.location.status;
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await Permission.location.request();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    if (permissionGranted == PermissionStatus.granted) {
      // Location service is enabled and permission granted.
      // You can proceed with accessing the location.
      return true;
    } else {
      return false;
    }
  }




  static Future<void> logout(BuildContext context) async {
    prefs.clear();

    //TODO add navigator to login page
    if (kDebugMode) {
      print("logged out");
    }
  }
}
