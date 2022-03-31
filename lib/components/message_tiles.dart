import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_three_broomsticks/support/support.dart';

class MessageTiles extends StatelessWidget {
  const MessageTiles(
      {Key? key, required this.messages, required this.isCommonRoom})
      : super(key: key);

  final messages;
  final bool isCommonRoom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: messages['uid'] == FirebaseAuth.instance.currentUser!.uid
          ? Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        alignment: Alignment.topRight,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.80,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(messages['nickname'],
                                      style: const TextStyle(
                                          color: Colors.white70)),
                                  const Spacer(),
                                  Text(
                                    '${isCommonRoom ? Support.getMailHeadDateTime(messages['timestamp'])['time'] : Support.getMessageDateAndTime(messages['timestamp'])['time']}',
                                    style:
                                        const TextStyle(color: Colors.white70),
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
                    backgroundColor: Colors.deepOrangeAccent,
                    backgroundImage: NetworkImage(messages['displayImage']),
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
                    backgroundColor: Colors.deepOrangeAccent,
                    backgroundImage: NetworkImage(messages['displayImage']),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xffeeeeee),
                          //0xff1e9fe2
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('${messages['nickname']}',
                                    style:
                                        const TextStyle(color: Colors.black54)),
                                const Spacer(),
                                Text(
                                  '${isCommonRoom ? Support.getMailHeadDateTime(messages['timestamp'])['time'] : Support.getMessageDateAndTime(messages['timestamp'])['time']}',
                                  style: const TextStyle(color: Colors.black54),
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
  }
}
