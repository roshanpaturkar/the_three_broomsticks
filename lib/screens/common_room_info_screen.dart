import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:the_three_broomsticks/screens/dashboard_screen.dart';
import 'package:the_three_broomsticks/support/chat_room_support.dart';
import 'package:the_three_broomsticks/support/support.dart';

class CommonRoomInfoScreen extends StatefulWidget {
  const CommonRoomInfoScreen({Key? key}) : super(key: key);

  @override
  State<CommonRoomInfoScreen> createState() => _CommonRoomInfoScreenState();
}

class _CommonRoomInfoScreenState extends State<CommonRoomInfoScreen> {
  bool startLogoutBouncer = false;
  bool startDeleteBouncer = false;
  bool uploading = false;
  bool userDetailsChanged = false;

  double progress = 0.0;

  List users = Get.arguments[0]['users'];

  final fireStore = FirebaseFirestore.instance;
  final box = GetStorage();

  ChatRoomSupport support = ChatRoomSupport();

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
              .ref('groupIcons/${Get.arguments[0]['roomPath']}.$extension');
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
          var roomData = {'icon': url};
          ChatRoomSupport support = ChatRoomSupport();
          support.updateCustomRoomDetails(roomData, Get.arguments[1], false);
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
              'groupIcons/${Get.arguments[0]['roomPath']}.${result.files.first.extension}');
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
          var roomData = {'icon': url};
          ChatRoomSupport support = ChatRoomSupport();
          support.updateCustomRoomDetails(roomData, Get.arguments[1], false);
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
    return Scaffold(
      backgroundColor: const Color(0xFF0181A20),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0181A20),
        title: SizedBox(
          width: 380,
          child: Text(
            '${Get.arguments[0]['name']}',
            style: GoogleFonts.dancingScript(
              color: Colors.white,
              fontSize: 22.0,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: GetPlatform.isWeb
                ? MediaQuery.of(context).size.width * 0.3
                : MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                const SizedBox(
                  height: 14,
                ),
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
                          foregroundImage:
                              NetworkImage(Get.arguments[0]['icon']),
                          backgroundImage: AssetImage(
                              'images/${Get.arguments[0]['roomPath'] == 'cafeteria' ? 'cafeteria' : box.read('house').toLowerCase()}.png'),
                          radius: 42,
                          backgroundColor: const Color(0xFF0181A20),
                        ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: fireStore
                          .collection('users')
                          .where('uid', isNotEqualTo: box.read('uid'))
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return const SpinKitDoubleBounce(
                            color: Colors.white,
                            size: 30.0,
                          );
                        }

                        return Container(
                          width: 350,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot user =
                                  snapshot.data!.docs[index];

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  width: 350,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF262A34),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 10, 30, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                              Colors.deepOrangeAccent,
                                          backgroundImage:
                                              NetworkImage(user['imageUrl']),
                                        ),
                                        const SizedBox(
                                          width: 24.0,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              user['nickname'],
                                              style: GoogleFonts.patrickHandSc(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 24.0,
                                            ),
                                            Text(
                                              user['house'],
                                              style: GoogleFonts.dancingScript(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Checkbox(
                                          checkColor: Colors.white,
                                          fillColor: MaterialStateProperty.all(
                                              Colors.red),
                                          value: users.contains(user['uid']),
                                          onChanged: (bool? value) {
                                            setState(() {
                                              if (value == true) {
                                                users.add(user['uid']);
                                              } else {
                                                users.remove(user['uid']);
                                              }
                                              print(users);
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: 350,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5468FF),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              if (users.length > 1) {
                                var roomDetails = {
                                  'users': users,
                                  'lastDetailUpdate': Timestamp.now()
                                };
                                support.updateCustomRoomDetails(
                                    roomDetails, Get.arguments[1], false);
                                Get.to(const DashboardScreen());
                              } else {
                                Support.toast('Add minimum one user!');
                              }
                            },
                            child: const Text(
                              'Save Details',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onLongPress: () {
                          var roomDetails = {
                            'users': [],
                            'isDeleted': true,
                            'lastDetailUpdate': Timestamp.now()
                          };

                          support.updateCustomRoomDetails(
                              roomDetails, Get.arguments[1], false);
                          Get.to(const DashboardScreen());
                        },
                        onTap: () {
                          Support.toast('Long press for delete the room!');
                        },
                        child: Container(
                          width: 150,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Center(
                            child: Text(
                              'Delete Room',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
