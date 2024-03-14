import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ui/models/login/login_request_model.dart';
import 'package:ui/models/login/login_response_model.dart';
import 'package:ui/models/messageModel.dart';
import 'package:ui/services/location_service.dart';
import 'package:ui/services/shared_service.dart';
import 'package:ui/utils/constants.dart';

import '../widgets/response_toast.dart';

class APIService {
  static var client = http.Client();

  static Future<int?> login(
      BuildContext context, LoginRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Constants.baseUri, "/api/login");
    //TODO add try catch
    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    if (response.statusCode == 200) {
      SharedService.setLoginDetails(
          loginResponseJson(response.body), model.sap);
      var role = SharedService.role;

      return role;
    } else if (response.statusCode == 401) {
      MessageModel messageModel = messageResponseJson(response.body);
      toast(status: response.statusCode, message: messageModel.message);
    }
    return null;
  }

  static Future<int> doPostInsert(
      {required BuildContext? context,
      required Map<String, dynamic> data,
      required String path}) async {
    LoginResponseModel? loginData = await SharedService.getLoginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginData!.accessToken}',
    };
    var url = Uri.http(Constants.baseUri, "/api$path");
    try {
      var response = await client.post(url,
          headers: requestHeaders, body: jsonEncode(data));
      MessageModel messageModel = messageResponseJson(response.body);
      if (context != null) {
        toast(status: response.statusCode, message: messageModel.message);
      }
      return response.statusCode;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return -1;
    }
  }

  static Future<int> doPut(
      {required BuildContext? context,
      required Map<String, dynamic> data,
      required String path,
      required String param}) async {
    LoginResponseModel? loginData = await SharedService.getLoginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginData!.accessToken}',
    };
    var url = Uri.http(Constants.baseUri, "/api$path/$param");
    try {
      var response = await client.put(url,
          headers: requestHeaders, body: jsonEncode(data));
      MessageModel messageModel = messageResponseJson(response.body);
      if (context != null) {
        toast(status: response.statusCode, message: messageModel.message);
      }
      return response.statusCode;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return -1;
    }
  }

  static Future<String> doGet(
      {required String path,
        String? param,
      bool inValidateCache = false}) async {
    LoginResponseModel? loginData = await SharedService.getLoginDetails();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginData!.accessToken}',
    };
    if (inValidateCache) {
      requestHeaders['Cache-Control'] = 'no-cache';
    }
     Uri url;
    if(param == null) {
      url = Uri.http(Constants.baseUri, "/api$path");
    } else{
      url = Uri.http(Constants.baseUri, "/api$path/$param");
    }

    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      return response.body;
    }
    return "";
  }

  static Future<int> doDelete(
      {required String path, required String param}) async {
    LoginResponseModel? loginData = await SharedService.getLoginDetails();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginData!.accessToken}',
    };

    Uri url = Uri.http(Constants.baseUri, "/api$path/$param");

    var response = await http.delete(url, headers: requestHeaders);

    return response.statusCode;
  }

  static Future<int> doMultipartImagePost(
      {required String path, required XFile image}) async {
    Uri url = Uri.http(Constants.baseUri, "/api$path/${SharedService.sapId}");
    var request = http.MultipartRequest('POST', url);
    LoginResponseModel? loginData = await SharedService.getLoginDetails();
    request.headers['Authorization'] = 'Bearer ${loginData!.accessToken}';
    await Geolocator.checkPermission();
    Geolocator.requestPermission();
    Position position = await LocationService.getCurrentPosition();
    String coordinates = "${position.latitude} ${position.longitude}";

    var imageStream = http.ByteStream(image.openRead());
    var length = await image.length();
    var multipartFile = http.MultipartFile('image', imageStream, length,
        filename: image.path.split('/').last);
    request.files.add(multipartFile);
    request.fields['location'] = coordinates;
    request.fields['eventId'] = SharedService.eventId;

    var response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Image uploaded successfully!');
        print('Response: ${response.body}');
      }
    } else {
      if (kDebugMode) {
        print('Failed to upload image. Error: ${response.reasonPhrase}');
      }
    }
    return response.statusCode;
  }

  static Future<int> doMultipartCsvPost({
    required String path,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    Uri url = Uri.http(Constants.baseUri, "/api$path");
    var request = http.MultipartRequest('POST', url);
    LoginResponseModel? loginData = await SharedService.getLoginDetails();

    request.headers['Authorization'] = 'Bearer ${loginData!.accessToken}';

    var fileStream = http.ByteStream(Stream.fromIterable([fileBytes]));
    var length = fileBytes.length;
    var multipartFile = http.MultipartFile(
      'csv_file',
      fileStream,
      length,
      filename: fileName,
    );
    request.files.add(multipartFile);

    var response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('CSV file uploaded successfully!');
        print('Response: ${response.body}');
      }
    } else {
      if (kDebugMode) {
        print('Failed to upload CSV file. Error: ${response.reasonPhrase}');
      }
    }
    return response.statusCode;
  }

  static Future<Uint8List?> doGetCSV({required String path, required String param}) async {
    LoginResponseModel? loginData = await SharedService.getLoginDetails();
    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer ${loginData!.accessToken}',
    };

    Uri url = Uri.http(Constants.baseUri, "/api$path" + "/$param");
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      if (kDebugMode) {
        print('Failed to fetch CSV file. Error: ${response.reasonPhrase}');
      }
      return null;
    }
  }

}
