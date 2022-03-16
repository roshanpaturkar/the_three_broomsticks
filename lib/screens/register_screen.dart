import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_three_broomsticks/screens/dashboard_screen.dart';
import 'package:the_three_broomsticks/support/user_support.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isHidden = true;
  bool startBouncer = false;
  final fNameFieldController = TextEditingController();
  final lNameFieldController = TextEditingController();
  final nickNameFieldController = TextEditingController();
  final emailFieldController = TextEditingController();
  final mobileFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();

  var fName = '';
  var lName = '';
  var nickName = '';
  var house = 'Gryffindor';
  var email = '';
  var mobile = '';
  var password = '';

  SnackBar showSnackBar(var message) {
    return SnackBar(content: Text(message));
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future<void> signUpWithEmailAndPassword(BuildContext context) async {
    if (fName != '' &&
        lName != '' &&
        nickName != '' &&
        email != '' &&
        mobile != '' &&
        password != '') {
      setState(() {
        startBouncer = true;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        var imageMap = {
          'Gryffindor':
              'https://firebasestorage.googleapis.com/v0/b/d3broomsticks.appspot.com/o/images%2Fhouses%2Fgryffindor.png?alt=media&token=4aa8f20d-fbb6-4dc5-bd47-8677e6087d7d',
          'Hufflepuff':
              'https://firebasestorage.googleapis.com/v0/b/d3broomsticks.appspot.com/o/images%2Fhouses%2Fhufflepuff.png?alt=media&token=b506e8cc-7390-4d22-9eac-c883e3d0ded3',
          'Ravenclaw':
              'https://firebasestorage.googleapis.com/v0/b/d3broomsticks.appspot.com/o/images%2Fhouses%2Fravenclaw.png?alt=media&token=2aaaccd0-b4ce-4ad5-a548-a00e569bf566',
          'Slytherin':
              'https://firebasestorage.googleapis.com/v0/b/d3broomsticks.appspot.com/o/images%2Fhouses%2Fslytherin.png?alt=media&token=6ca6e67f-9395-47f4-9281-497622eecd42'
        };

        var userData = {
          'uid': userCredential.user?.uid,
          'firstName': fName.trim(),
          'lastName': lName.trim(),
          'nickname': nickName.trim(),
          'house': house.trim(),
          'imageUrl': imageMap[house],
          'email': email.trim(),
          'mobile': mobile.trim(),
        };

        CollectionReference users =
            FirebaseFirestore.instance.collection('users');

        await users
            .add(userData)
            .then((value) => print('User added!'))
            .catchError((error) => print("Failed to add user: $error"));

        fName = '';
        lName = '';
        nickName = '';
        email = '';
        mobile = '';
        password = '';
        fNameFieldController.clear();
        lNameFieldController.clear();
        nickNameFieldController.clear();
        emailFieldController.clear();
        mobileFieldController.clear();
        passwordFieldController.clear();

        await UserSupport.refreshUserDetails();

        setState(() {
          startBouncer = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          showSnackBar("Welcome ${userData['firstName']}!"),
        );

        Get.to(const DashboardScreen());
      } on FirebaseAuthException catch (e) {
        setState(() {
          startBouncer = false;
        });
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            showSnackBar('The password provided is too weak.'),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            showSnackBar('The account already exists for that email.'),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          showSnackBar(e.toString()),
        );
        print(e);
      }
    } else {
      setState(() {
        startBouncer = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        showSnackBar('Please fill all the data!'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0181A20),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create new account',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                const Text(
                  'Please fill the form to continue',
                  style: TextStyle(
                    color: Color(0xFF6F7075),
                  ),
                ),
                const SizedBox(
                  height: 50,
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
                      controller: fNameFieldController,
                      cursorColor: Colors.white,
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'First Name',
                        hintStyle: TextStyle(
                          color: Color(0xFF6F7075),
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(0xFFD5D6D9),
                      ),
                      onChanged: (value) {
                        fName = value;
                        print(fName);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
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
                      controller: lNameFieldController,
                      cursorColor: Colors.white,
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Last Name',
                        hintStyle: TextStyle(
                          color: Color(0xFF6F7075),
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(0xFFD5D6D9),
                      ),
                      onChanged: (value) {
                        lName = value;
                        print(lName);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
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
                      controller: nickNameFieldController,
                      cursorColor: Colors.white,
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Nick Name',
                        hintStyle: TextStyle(
                          color: Color(0xFF6F7075),
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(0xFFD5D6D9),
                      ),
                      onChanged: (value) {
                        nickName = value;
                        print(nickName);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Container(
                  width: 350,
                  decoration: BoxDecoration(
                    color: const Color(0xFF262A34),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select House',
                          style: TextStyle(
                            color: Color(0xFF6F7075),
                          ),
                        ),
                        DropdownButton<String>(
                          hint: const Text('Select House'),
                          value: house,
                          elevation: 16,
                          style: const TextStyle(
                            color: Color(0xFF6F7075),
                          ),
                          underline: Container(
                            height: 2,
                            color: const Color(0xFF262A34),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              house = newValue!;
                              print(house);
                            });
                          },
                          items: <String>[
                            'Gryffindor',
                            'Hufflepuff',
                            'Ravenclaw',
                            'Slytherin'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
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
                      controller: emailFieldController,
                      cursorColor: Colors.white,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color: Color(0xFF6F7075),
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(0xFFD5D6D9),
                      ),
                      onChanged: (value) {
                        email = value;
                        print(email);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
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
                      controller: mobileFieldController,
                      cursorColor: Colors.white,
                      obscureText: false,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Phone',
                        hintStyle: TextStyle(
                          color: Color(0xFF6F7075),
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(0xFFD5D6D9),
                      ),
                      onChanged: (value) {
                        mobile = value;
                        print(mobile);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
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
                      controller: passwordFieldController,
                      cursorColor: Colors.white,
                      obscureText: _isHidden,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          color: Color(0xFF6F7075),
                        ),
                        suffix: InkWell(
                          onTap: _togglePasswordView,
                          child: Icon(
                            _isHidden
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF6A6B71),
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(0xFFD5D6D9),
                      ),
                      onChanged: (value) {
                        password = value;
                        print(password);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  width: 350,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5468FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          signUpWithEmailAndPassword(context);
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      startBouncer
                          ? const SpinKitDoubleBounce(
                              color: Colors.white,
                              size: 50.0,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Have an Account?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color(0xFF5468FF),
                        ),
                      ),
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
