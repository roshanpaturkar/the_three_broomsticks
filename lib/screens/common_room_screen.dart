import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_three_broomsticks/components/group_message_input.dart';
import 'package:the_three_broomsticks/support/support.dart';

class CommonRoomScreen extends StatefulWidget {
  const CommonRoomScreen({Key? key}) : super(key: key);

  @override
  State<CommonRoomScreen> createState() => _CommonRoomScreenState();
}

class _CommonRoomScreenState extends State<CommonRoomScreen> {
  final box = GetStorage();

  final fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0181A20),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0181A20),
        title: SizedBox(
          width: 380,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                foregroundImage: NetworkImage(Get.arguments[2]),
                backgroundImage:
                    AssetImage('images/${box.read('house').toLowerCase()}.png'),
                radius: 16,
                backgroundColor: const Color(0xFF262A34),
              ),
              Text(
                '${Get.arguments[1]} !',
                style: GoogleFonts.dancingScript(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: fireStore
                      .collection(Get.arguments[0])
                      .orderBy('timestamp', descending: true)
                      .where('isMessageDeleted', isEqualTo: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const SpinKitDoubleBounce(
                        color: Colors.white,
                        size: 30.0,
                      );
                    }

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot messages = snapshot.data!.docs[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: messages['uid'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.80,
                                              padding: const EdgeInsets.all(10),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(messages['nickname'],
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .white70)),
                                                      const Spacer(),
                                                      Text(
                                                        '${Support.getMailHeadDateTime(messages['timestamp'])}',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white70),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    '${messages['message']}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            Colors.deepOrangeAccent,
                                        backgroundImage: NetworkImage(
                                            messages['displayImage']),
                                      )
                                    ],
                                  ),
                                )
                              : Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            Colors.deepOrangeAccent,
                                        backgroundImage: NetworkImage(
                                            messages['displayImage']),
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.80,
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: BoxDecoration(
                                              color: const Color(0xffeeeeee),
                                              //0xff1e9fe2
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        '${messages['nickname']}',
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .black54)),
                                                    const Spacer(),
                                                    Text(
                                                      '${Support.getMailHeadDateTime(messages['timestamp'])}',
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  '${messages['message']}',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            GroupMessageInput(),
          ],
        ),
      ),
    );
  }
}
