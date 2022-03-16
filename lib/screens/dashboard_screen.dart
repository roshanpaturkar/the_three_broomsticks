import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_to_background/move_to_background.dart';

class DashboardScreen extends StatefulWidget {
  static const String id = 'dashboard_screen';

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final box = GetStorage();

  SnackBar showSnackBar(var message) {
    return SnackBar(content: Text(message));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid || Platform.isIOS) {
          MoveToBackground.moveTaskToBack();
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0181A20),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "Hello ${box.read('nickname').toString().split(' ')[0]}!",
                      style: GoogleFonts.workSans(
                        color: Colors.white,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onLongPress: () {},
                      onTap: () {
                        print('Profile hit!');
                      },
                      child: CircleAvatar(
                        foregroundImage: NetworkImage(box.read('imageUrl')),
                        // backgroundImage: AssetImage('images/gf.png'),
                        radius: 25,
                        backgroundColor: const Color(0xFF0181A20),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Other Features are coming soon!!',
                  style: GoogleFonts.workSans(
                    color: Colors.white,
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
