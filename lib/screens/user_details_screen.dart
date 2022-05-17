import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_three_broomsticks/support/user_support.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0181A20),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0181A20),
        title: Text(
          'Users Details',
          style: GoogleFonts.dancingScript(
            color: Colors.white,
            fontSize: 22.0,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: Get.arguments[0]['uid'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const SpinKitDoubleBounce(
              color: Colors.white,
              size: 30.0,
            );
          }

          return Center(
            child: Container(
              width: 350,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot user = snapshot.data!.docs[index];

                  String accessControl = '${user['userAccessControl']}';
                  String disabilityLevel = '${user['disable']}';
                  bool verified = user['verified'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: 350,
                      decoration: BoxDecoration(
                        color: const Color(0xFF262A34),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(
                              height: 16.0,
                            ),
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.deepOrangeAccent,
                              backgroundImage: NetworkImage(user['imageUrl']),
                            ),
                            const SizedBox(
                              height: 14.0,
                            ),
                            Text(
                              user['nickname'],
                              style: GoogleFonts.patrickHandSc(
                                color: Colors.white,
                                fontSize: 26.0,
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              user['house'],
                              style: GoogleFonts.dancingScript(
                                color: Colors.white,
                                fontSize: 24.0,
                              ),
                            ),
                            const SizedBox(
                              height: 14.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  user['firstName'],
                                  style: GoogleFonts.patrickHandSc(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8.0,
                                ),
                                Text(
                                  user['lastName'],
                                  style: GoogleFonts.patrickHandSc(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              user['email'],
                              style: GoogleFonts.ubuntu(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              user['mobile'],
                              style: GoogleFonts.ubuntu(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(
                              height: 14.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'User Access Control: ',
                                  style: TextStyle(
                                    color: Color(0xFF6F7075),
                                  ),
                                ),
                                DropdownButton<String>(
                                  hint: const Text('Access Control Level'),
                                  value: accessControl,
                                  elevation: 16,
                                  style: const TextStyle(
                                    color: Color(0xFF6F7075),
                                  ),
                                  underline: Container(
                                    height: 2,
                                    color: const Color(0xFF262A34),
                                  ),
                                  onChanged: (String? newValue) async {
                                    var data = {
                                      'userAccessControl': int.parse(newValue!)
                                    };
                                    await UserSupport.updateUserData(
                                        user.id, data);
                                    setState(() {
                                      accessControl = newValue;
                                    });
                                  },
                                  items: <String>['0', '1', '2', '3']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Disability Level: ',
                                  style: TextStyle(
                                    color: Color(0xFF6F7075),
                                  ),
                                ),
                                DropdownButton<String>(
                                  hint: const Text('Disability Level'),
                                  value: disabilityLevel,
                                  elevation: 16,
                                  style: const TextStyle(
                                    color: Color(0xFF6F7075),
                                  ),
                                  underline: Container(
                                    height: 2,
                                    color: const Color(0xFF262A34),
                                  ),
                                  onChanged: (String? newValue) async {
                                    var data = {
                                      'disable': int.parse(newValue!)
                                    };
                                    await UserSupport.updateUserData(
                                        user.id, data);
                                    setState(() {
                                      disabilityLevel = newValue;
                                    });
                                  },
                                  items: <String>['0', '1', '2', '3']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Verified: ',
                                  style: TextStyle(
                                    color: Color(0xFF6F7075),
                                  ),
                                ),
                                Switch(
                                  activeColor: Colors.red,
                                  value: verified,
                                  onChanged: (value) async {
                                    var data = {'verified': value};
                                    await UserSupport.updateUserData(
                                        user.id, data);
                                    setState(() {
                                      verified = value;
                                    });
                                    UserSupport.addUserGroup(value, user);
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
