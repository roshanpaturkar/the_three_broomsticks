import 'package:cloud_firestore/cloud_firestore.dart';
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

  static DateTime getDateTime(Timestamp timestamp) {
    return DateTime.fromMicrosecondsSinceEpoch(timestamp.seconds * 1000000);
  }

  static Map<String, String> getMessageDateAndTime(String dateTimeString) {
    var dateTimeStringData = dateTimeString.split(" ");
    var dateData = dateTimeStringData[0].split("-");
    var timeData = dateTimeStringData[1].split(".")[0].split(":");
    var date = '${dateData[2]}-${dateData[1]}-${dateData[0]}';
    var time =
        '${int.parse(timeData[0]) > 12 ? int.parse(timeData[0]) - 12 : timeData[0]}:${timeData[1]} ${int.parse(timeData[0]) > 12 ? 'pm' : 'am'}';
    if (int.parse(timeData[0]) > 12) {}
    var messageDateTime = {'date': date, 'time': time};
    return messageDateTime;
  }

  static Map<String, String> getMailHeadDateTime(Timestamp timestamp) {
    return getMessageDateAndTime(getDateTime(timestamp).toString());
  }
}
