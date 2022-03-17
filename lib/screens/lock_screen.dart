import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({Key? key}) : super(key: key);
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  var message = Get.arguments[0];

  SnackBar showSnackBar(var message) {
    return SnackBar(content: Text(message));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showSnackBar(message);
        return false;
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(child: Image.asset("images/lock.png")),
            Text(message),
          ],
        ),
      ),
    );
  }
}
