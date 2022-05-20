import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:the_three_broomsticks/screens/common_room_screen.dart';
import 'package:the_three_broomsticks/screens/create_custom_room_screen.dart';
import 'package:the_three_broomsticks/screens/custom_room_screen.dart';
import 'package:the_three_broomsticks/screens/profile_screen.dart';
import 'package:the_three_broomsticks/support/background_tasks.dart';
import 'package:the_three_broomsticks/support/support.dart';

class DashboardScreen extends StatefulWidget {
  static const String id = 'dashboard_screen';

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final box = GetStorage();

  final firestore = FirebaseFirestore.instance;

  SnackBar showSnackBar(var message) {
    return SnackBar(content: Text(message));
  }

  @override
  void initState() {
    super.initState();
    BackgroundTasks run = BackgroundTasks();

    run.backgroundTasks();
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (box.read('userAccessControl') < 3) {
              Get.to(const CreateChatRoomScreen());
            } else {
              Support.toast('You don\'t have rights to create the room!');
            }
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.group_add_rounded),
        ),
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
                      style: GoogleFonts.pacifico(
                        color: Colors.white,
                        fontSize: 26.0,
                      ),
                    ),
                    GestureDetector(
                      onLongPress: () {},
                      onTap: () {
                        Get.to(const ProfileScreen());
                      },
                      child: CircleAvatar(
                        foregroundImage: NetworkImage(box.read('imageUrl')),
                        backgroundImage: AssetImage(
                            'images/${box.read('house').toLowerCase()}.png'),
                        radius: 25,
                        backgroundColor: const Color(0xFF0181A20),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('customRoomHead')
                      .where('roomPath', isEqualTo: 'cafeteria')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }

                    var roomData;
                    String docID = '';

                    for (var element in snapshot.data!.docs) {
                      roomData = element.data();
                      docID = element.id;
                    }

                    return GestureDetector(
                      onTap: () {
                        if (box.read('disable') < 2) {
                          if (roomData['blockedUsers']
                              .contains(box.read('uid'))) {
                            Support.toast('Your blocked to access this room!');
                          } else {
                            Get.to(const CustomRoomScreen(),
                                arguments: [roomData, docID]);
                          }
                        } else {
                          Support.toast('Your blocked from cafeteria!');
                        }
                      },
                      child: Container(
                        width: 380,
                        padding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF262A34),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              foregroundImage:
                                  NetworkImage(roomData['icon'].toString()),
                              backgroundImage:
                                  const AssetImage('images/cafeteria.png'),
                              radius: 22,
                              backgroundColor: const Color(0xFF262A34),
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Text(
                              '${roomData['name']} !',
                              style: GoogleFonts.dancingScript(
                                color: roomData['lastSeen']
                                        .contains(box.read('uid'))
                                    ? Colors.white
                                    : Colors.red,
                                fontSize: 26.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('commonRoomChatHeads')
                      .where('house', isEqualTo: box.read('house'))
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }

                    var roomData;
                    String docID = '';

                    for (var element in snapshot.data!.docs) {
                      roomData = element.data();
                      docID = element.id;
                    }

                    return GestureDetector(
                      onTap: () {
                        if (box.read('disable') < 2) {
                          if (roomData['users'].contains(box.read('uid'))) {
                            if (roomData['blockedUsers']
                                .contains(box.read('uid'))) {
                              Support.toast(
                                  'Your blocked to access this room!');
                            } else {
                              Get.to(const CommonRoomScreen(),
                                  arguments: [roomData, docID]);
                            }
                          } else {
                            Support.toast('You don\'t access to this room!');
                          }
                        } else {
                          Support.toast('Your blocked from common room!');
                        }
                      },
                      child: Container(
                          width: 380,
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF262A34),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                foregroundImage: NetworkImage(roomData['icon']),
                                backgroundImage: AssetImage(
                                    'images/${box.read('house').toLowerCase()}.png'),
                                radius: 22,
                                backgroundColor: const Color(0xFF262A34),
                              ),
                              const SizedBox(
                                width: 12.0,
                              ),
                              Text(
                                '${roomData['name']} !',
                                style: GoogleFonts.dancingScript(
                                  color: roomData['lastSeen']
                                          .contains(box.read('uid'))
                                      ? Colors.white
                                      : Colors.red,
                                  fontSize: 26.0,
                                ),
                              ),
                            ],
                          )),
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: Container(
                    width: 360,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: firestore
                          .collection('customRoomHead')
                          .where('users', arrayContains: box.read('uid'))
                          .orderBy('lastMessage', descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: SpinKitDoubleBounce(
                              color: Colors.white,
                              size: 30.0,
                            ),
                          );
                        }

                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot head = snapshot.data!.docs[index];

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (box.read('disable') != 3) {
                                    if (head['users']
                                        .contains(box.read('uid'))) {
                                      if (head['blockedUsers']
                                          .contains(box.read('uid'))) {
                                        Support.toast(
                                            'Your blocked to access this room!');
                                      } else {
                                        Get.to(
                                          const CustomRoomScreen(),
                                          arguments: [head, head.id],
                                        );
                                      }
                                    } else {
                                      Support.toast(
                                          'You don\'t access to this room!');
                                    }
                                  } else {
                                    Support.toast(
                                        'Your blocked from all private room!');
                                  }
                                },
                                child: Container(
                                  width: 350,
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF262A34),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        foregroundImage:
                                            NetworkImage(head['icon']),
                                        backgroundImage: AssetImage(
                                            'images/${box.read('house').toLowerCase()}.png'),
                                        radius: 22,
                                        backgroundColor:
                                            const Color(0xFF262A34),
                                      ),
                                      const SizedBox(
                                        width: 12.0,
                                      ),
                                      Text(
                                        '${head['name']} !',
                                        style: GoogleFonts.dancingScript(
                                          color: head['lastSeen']
                                                  .contains(box.read('uid'))
                                              ? Colors.white
                                              : Colors.red,
                                          fontSize: 26.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
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
