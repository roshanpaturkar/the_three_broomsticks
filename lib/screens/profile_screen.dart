import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:the_three_broomsticks/screens/control_panel_screen.dart';
import 'package:the_three_broomsticks/screens/dashboard_screen.dart';
import 'package:the_three_broomsticks/screens/login_screen.dart';
import 'package:the_three_broomsticks/support/support.dart';
import 'package:the_three_broomsticks/support/user_support.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final box = GetStorage();

  bool startLogoutBouncer = false;
  bool startDeleteBouncer = false;
  bool uploading = false;
  bool userDetailsChanged = false;

  double progress = 0.0;

  SnackBar showSnackBar(var message) {
    return SnackBar(content: Text(message));
  }

  Future<void> uploadProfileImage() async {
    if (GetPlatform.isAndroid) {
      ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 60,
        maxHeight: 192.0,
        maxWidth: 192.0,
      );

      if (image != null) {
        setState(() {
          uploading = true;
        });

        userDetailsChanged = true;

        var extension = image.name.toString().split('.')[1];

        File file = File(image.path);

        try {
          final ref = FirebaseStorage.instance
              .ref('profileImages/${box.read('uid')}.$extension');
          UploadTask task = ref.putFile(file);
          task.snapshotEvents.listen((event) {
            setState(() {
              progress = ((event.bytesTransferred.toDouble() /
                          event.totalBytes.toDouble()) *
                      100)
                  .roundToDouble();

              if (progress == 100) {
                setState(() {
                  uploading = false;
                });
              }
            });
          });

          var url = await ref.getDownloadURL();
          box.write('imageUrl', url);
          var userData = {'imageUrl': url};
          UserSupport.updateUserDetails(userData);
        } on FirebaseException catch (e) {
          setState(() {
            uploading = false;
          });
          // e.g, e.code == 'canceled'
          print(e);
        }
      } else {
        setState(() {
          uploading = false;
        });
      }
    } else if (GetPlatform.isWeb) {
      Support.toast('This feature is unstable in web!');
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          uploading = true;
        });

        userDetailsChanged = true;

        Uint8List? file = result.files.first.bytes;

        if (result.files.first.size < 2000000) {
          Reference ref = FirebaseStorage.instance.ref(
              'profileImages/${box.read('uid')}.${result.files.first.extension}');
          UploadTask task = ref.putData(file!);

          task.snapshotEvents.listen((event) {
            setState(() {
              progress = ((event.bytesTransferred.toDouble() /
                          event.totalBytes.toDouble()) *
                      100)
                  .roundToDouble();

              if (progress == 100) {
                setState(() {
                  uploading = false;
                });
              }
            });
          });

          var url = await ref.getDownloadURL();
          box.write('imageUrl', url);
          var userData = {'imageUrl': url};
          UserSupport.updateUserDetails(userData);
        } else {
          setState(() {
            uploading = false;
          });
          Support.toast('Size should be less than 2 MB!');
        }
      } else {
        setState(() {
          uploading = false;
        });
      }
    } else {
      Support.toast('This feature currently not available for your device!');
    }
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
              'User Profile',
              style: GoogleFonts.dancingScript(
                color: Colors.white,
                fontSize: 22.0,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await uploadProfileImage();
                  },
                  child: uploading
                      ? SizedBox(
                          height: 84.0,
                          width: 84.0,
                          child: LiquidCircularProgressIndicator(
                            value: progress / 100,
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.blueAccent),
                            backgroundColor: Colors.white,
                            direction: Axis.vertical,
                            center: Text(
                              "$progress%",
                              style: GoogleFonts.poppins(
                                  color: Colors.black87, fontSize: 25.0),
                            ),
                          ),
                        )
                      : CircleAvatar(
                          foregroundImage: NetworkImage(box.read('imageUrl')),
                          backgroundImage: AssetImage(
                              'images/${box.read('house').toLowerCase()}.png'),
                          radius: 42,
                          backgroundColor: const Color(0xFF0181A20),
                        ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Text(
                  '{ ${box.read('nickname')} }'.toUpperCase(),
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '${box.read('fName')} ${box.read('lName')}',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '${box.read('email')}',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '${box.read('mobile')}',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 42,
                ),
                Container(
                  width: 220,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5468FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          showSnackBar('Under development!');
                          Support.toast('Under development!');
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ChangePassword(
                          //       user: widget.user,
                          //     ),
                          //   ),
                          // );
                        },
                        child: const Text(
                          'Change Password',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                Container(
                  width: 220,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5468FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Get.offAll(const LoginScreen());
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      startLogoutBouncer
                          ? const SpinKitDoubleBounce(
                              color: Colors.white,
                              size: 50.0,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                box.read('userAccessControl') == 0
                    ? Container(
                        width: 220,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.to(const ControlPanelScreen());
                              },
                              child: const Text(
                                'Control Panel',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            startDeleteBouncer
                                ? const SpinKitDoubleBounce(
                                    color: Colors.white,
                                    size: 50.0,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      )
                    : const Text(''),
                const SizedBox(
                  height: 22,
                ),
                Container(
                  width: 220,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          // setState(() {
                          //   startDeleteBouncer = true;
                          // });
                          Support.toast('Under development!');
                          showSnackBar('Under development!');
                          // createProject(context);
                        },
                        child: const Text(
                          'Delete Account',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      startDeleteBouncer
                          ? const SpinKitDoubleBounce(
                              color: Colors.white,
                              size: 50.0,
                            )
                          : const SizedBox(),
                    ],
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
