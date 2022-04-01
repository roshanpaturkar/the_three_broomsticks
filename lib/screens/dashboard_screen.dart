import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:the_three_broomsticks/screens/cafeteria_room_screen.dart';
import 'package:the_three_broomsticks/screens/common_room_screen.dart';
import 'package:the_three_broomsticks/screens/create_chat_room_screen.dart';
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
  final _dbRef =
      FirebaseDatabase.instance.ref().child('room_heads').child('cafeteria');

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
            Get.to(const CreateChatRoomScreen());
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
                StreamBuilder(
                  stream: _dbRef.onValue,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      final cafeteria = snapshot.data!.snapshot.value;

                      if (cafeteria != null) {
                        return GestureDetector(
                          onTap: () {
                            if (!cafeteria['blockedUsers']
                                .toString()
                                .split(',')
                                .contains(box.read('uid'))) {
                              Get.to(
                                const CafeteriaRoomScreen(),
                                arguments: [
                                  cafeteria['roomPath'],
                                  cafeteria['name'],
                                  cafeteria['icon']
                                ],
                              );
                            } else {
                              Support.toast('You don\'t have access!');
                            }
                          },
                          child: Container(
                            width: 390,
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
                                      NetworkImage('${cafeteria['icon']}'),
                                  backgroundImage:
                                      const AssetImage('images/cafeteria.png'),
                                  radius: 22,
                                  backgroundColor: const Color(0xFF262A34),
                                ),
                                const SizedBox(
                                  width: 24.0,
                                ),
                                Text(
                                  '${cafeteria['name']} !',
                                  style: GoogleFonts.dancingScript(
                                    color: Colors.white,
                                    fontSize: 26.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const Text('Hello');
                      }
                    }

                    return const Center(
                      child: Text('There is something wrong!'),
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

                    String _icon = '';
                    String _name = '';
                    List _users = [];
                    List _blockedUsers = [];
                    bool _adminOnly = false;
                    String _groupId = '';

                    for (var element in snapshot.data!.docs) {
                      _name = element.get('name');
                      _icon = element.get('icon');
                      _users = element.get('users');
                      _blockedUsers = element.get('blockedUsers');
                      _adminOnly = element.get('adminOnly');
                      _groupId = element.get('groupId');
                    }

                    return GestureDetector(
                      onTap: () {
                        if (_name.isNotEmpty) {
                          if (_users.contains(box.read('uid'))) {
                            if (_blockedUsers.contains(box.read('uid'))) {
                              Support.toast(
                                  'Your blocked to access this room!');
                            } else {
                              Get.to(const CommonRoomScreen(),
                                  arguments: [_groupId, _name, _icon]);
                            }
                          } else {
                            Support.toast('You don\'t access to this room!');
                          }
                        } else {
                          Support.toast('Common Room Not Found !');
                        }
                      },
                      child: Container(
                        width: 390,
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF262A34),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: _name.isNotEmpty
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    foregroundImage: NetworkImage(_icon),
                                    backgroundImage: AssetImage(
                                        'images/${box.read('house').toLowerCase()}.png'),
                                    radius: 22,
                                    backgroundColor: const Color(0xFF262A34),
                                  ),
                                  const SizedBox(
                                    width: 24.0,
                                  ),
                                  Text(
                                    '$_name !',
                                    style: GoogleFonts.dancingScript(
                                      color: Colors.white,
                                      fontSize: 26.0,
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Text(
                                  'Common Room Not Found !',
                                  style: GoogleFonts.dancingScript(
                                    color: Colors.white,
                                    fontSize: 26.0,
                                  ),
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: Container(
                    width: 390,
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
                                  Support.toast(head['name']);
                                  // if (_name.isNotEmpty) {
                                  //   if (_users.contains(box.read('uid'))) {
                                  //     if (_blockedUsers.contains(box.read('uid'))) {
                                  //       Support.toast(
                                  //           'Your blocked to access this room!');
                                  //     } else {
                                  //       Get.to(const CommonRoomScreen(),
                                  //           arguments: [_groupId, _name, _icon]);
                                  //     }
                                  //   } else {
                                  //     Support.toast('You don\'t access to this room!');
                                  //   }
                                  // } else {
                                  //   Support.toast('Common Room Not Found !');
                                  // }
                                },
                                child: Container(
                                  width: 390,
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 10, 30, 10),
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
                                            NetworkImage(head['icon']),
                                        backgroundImage: AssetImage(
                                            'images/${box.read('house').toLowerCase()}.png'),
                                        radius: 22,
                                        backgroundColor:
                                            const Color(0xFF262A34),
                                      ),
                                      const SizedBox(
                                        width: 24.0,
                                      ),
                                      Text(
                                        '${head['name']} !',
                                        style: GoogleFonts.dancingScript(
                                          color: Colors.white,
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
