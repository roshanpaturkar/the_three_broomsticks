import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_three_broomsticks/screens/user_details_screen.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({Key? key}) : super(key: key);

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0181A20),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0181A20),
        title: Text(
          'Users',
          style: GoogleFonts.dancingScript(
            color: Colors.white,
            fontSize: 22.0,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
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
                          DocumentSnapshot user = snapshot.data!.docs[index];

                          return GestureDetector(
                            onTap: () {
                              Get.to(const UserDetailsScreen(),
                                  arguments: [user]);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                                            '${user['firstName']} ${user['lastName']}',
                                            style: GoogleFonts.patrickHandSc(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 14.0,
                                          ),
                                          Text(
                                            '[${user['nickname']}]',
                                            style: GoogleFonts.dancingScript(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
          ],
        ),
      ),
    );
  }
}
