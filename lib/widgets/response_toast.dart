import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> toast({required int status, required String message}) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    //TODO change location
    gravity: ToastGravity.TOP,

    /*TODO Parinaz add color for toast also change it based on status, if in 200
    family different, 400 family different & 500 family different
    */
    backgroundColor: Colors.grey,
    textColor: Colors.white,
  );
}
