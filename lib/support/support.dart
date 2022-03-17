import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Support {
  static void toast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
      timeInSecForIosWeb: 3,
      webBgColor: '#FFFFFFFF',
      webPosition: 'center',
    );
  }
}
