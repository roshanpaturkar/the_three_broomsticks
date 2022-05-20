import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_three_broomsticks/support/constants.dart';
import 'package:the_three_broomsticks/support/support.dart';

class CreateChatRoomScreen extends StatefulWidget {
  const CreateChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<CreateChatRoomScreen> createState() => _CreateChatRoomScreenState();
}

class _CreateChatRoomScreenState extends State<CreateChatRoomScreen> {
  final box = GetStorage();
  final fireStore = FirebaseFirestore.instance;
  final roomNameFieldController = TextEditingController();

  var roomName = '';
  List users = [];

  void createCustomRoom() async {
    if (roomName != '' && users.isNotEmpty) {
      users.add(box.read('uid'));
      var timestamp = Timestamp.now();

      await fireStore.collection('customRoomHead').add({
        'name': roomName,
        'icon': kHouseImagesMap[box.read('house')],
        'adminOnly': false,
        'isDeleted': false,
        'roomPath': Support.getRandomString(32),
        'users': users,
        'blockedUsers': [],
        'lastSeen': [box.read('uid')],
        'timestamp': timestamp,
        'lastMessage': timestamp,
        'lastDetailUpdate': timestamp,
        'createdBy': {
          'name': '${box.read('fName')} ${box.read('lName')}',
          'email': box.read('email'),
          'uid': box.read('uid'),
        }
      });

      roomName = '';
      users = [];
      roomNameFieldController.clear();

      Get.back();
    } else {
      Support.toast('Room name and user list is compulsory!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0181A20),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0181A20),
        title: Center(
          child: Text(
            'Create New Room',
            style: GoogleFonts.dancingScript(
              color: Colors.white,
              fontSize: 22.0,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 26,
            ),
            CircleAvatar(
              backgroundImage:
                  AssetImage('images/${box.read('house').toLowerCase()}.png'),
              radius: 42,
              backgroundColor: const Color(0xFF0181A20),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              width: 350,
              decoration: BoxDecoration(
                color: const Color(0xFF262A34),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: TextField(
                  controller: roomNameFieldController,
                  cursorColor: Colors.white,
                  obscureText: false,
                  maxLength: 22,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Room Name',
                    hintStyle: TextStyle(
                      color: Color(0xFF6F7075),
                    ),
                  ),
                  style: const TextStyle(
                    color: Color(0xFFD5D6D9),
                  ),
                  onChanged: (value) {
                    roomName = value;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 16,
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

                    return SizedBox(
                      width: 350,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot user = snapshot.data!.docs[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              width: 350,
                              decoration: BoxDecoration(
                                color: const Color(0xFF262A34),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.deepOrangeAccent,
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
                                      fillColor:
                                          MaterialStateProperty.all(Colors.red),
                                      value: users.contains(user['uid']),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            users.add(user['uid']);
                                          } else {
                                            users.remove(user['uid']);
                                          }
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
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF5468FF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    createCustomRoom();
                  },
                  child: const Text(
                    'Create Room',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 14,
            ),
          ],
        ),
      ),
    );
  }
}
