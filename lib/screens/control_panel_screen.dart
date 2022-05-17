import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_three_broomsticks/screens/all_users_screeen.dart';
import 'package:the_three_broomsticks/screens/dashboard_screen.dart';
import 'package:the_three_broomsticks/screens/unverified_users_screen.dart';

class ControlPanelScreen extends StatefulWidget {
  const ControlPanelScreen({Key? key}) : super(key: key);

  @override
  _ControlPanelScreenState createState() => _ControlPanelScreenState();
}

class _ControlPanelScreenState extends State<ControlPanelScreen> {
  final box = GetStorage();

  bool startLogoutBouncer = false;
  bool startDeleteBouncer = false;
  bool uploading = false;
  bool userDetailsChanged = false;

  double progress = 0.0;

  SnackBar showSnackBar(var message) {
    return SnackBar(content: Text(message));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (userDetailsChanged) {
          Get.offAll(const DashboardScreen());
        } else {
          return true;
        }

        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0181A20),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF0181A20),
          title: SizedBox(
            width: 380,
            child: Text(
              'Control Panel',
              style: GoogleFonts.dancingScript(
                color: Colors.white,
                fontSize: 22.0,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 22.0,
                  ),
                  Container(
                    width: 220,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5468FF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        Get.to(const UnverifiedUsersScreen());
                      },
                      child: const Text(
                        'Verify Users',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Container(
                    width: 220,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5468FF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        Get.to(const AllUsersScreen());
                      },
                      child: const Text(
                        'Users',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
