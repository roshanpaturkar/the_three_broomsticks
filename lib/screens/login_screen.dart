import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:the_three_broomsticks/screens/dashboard_screen.dart';
import 'package:the_three_broomsticks/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isHidden = true;
  bool startBouncer = false;
  final emailFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();

  var email = '';
  var password = '';

  SnackBar showSnackBar(var message) {
    return SnackBar(content: Text(message));
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    if (email != '' && password != '') {
      setState(() {
        startBouncer = true;
      });

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.trim(), password: password.trim());

        setState(() {
          startBouncer = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          showSnackBar('Happy to see you again!'),
        );

        Navigator.pushNamed(context, DashboardScreen.id);
      } on FirebaseAuthException catch (e) {
        setState(() {
          startBouncer = false;
        });

        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            showSnackBar('No user found for that email.'),
          );
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            showSnackBar('Wrong password provided for that user.'),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        showSnackBar('Please provide email and password!'),
      );
    }
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
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Welcome Back!',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  const Text(
                    'Please sign in to your account',
                    style: TextStyle(
                      color: Color(0xFF6F7075),
                    ),
                  ),
                  const SizedBox(
                    height: 66,
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
                          // icon: Icon(
                          //   Icons.mail_outline,
                          //   color: Color(0xFF6F7075),
                          // ),
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Color(0xFF6F7075),
                          ),
                          // errorText: password == null || password == ''
                          //     ? 'Please enter something'
                          //     : null,
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(20),
                          // ),
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
                        controller: passwordFieldController,
                        cursorColor: Colors.white,
                        obscureText: _isHidden,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          // icon: Icon(
                          //   Icons.vpn_key_outlined,
                          //   color: Color(0xFF6F7075),
                          // ),
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
                              color: Color(0xFF6A6B71),
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
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        showSnackBar('This feature is currently unavailable!'),
                      );
                      // Navigator.pushNamed(context, ForgetPassword.id);
                    },
                    child: Container(
                      width: 350,
                      child: const Text(
                        'Forget Password?',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF6F7075),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
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
                            signInWithEmailAndPassword(context);
                          },
                          child: const Text(
                            'Sign In',
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
                    height: 14,
                  ),
                  Container(
                    width: 350,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/google.png',
                          height: 26,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              showSnackBar(
                                  'This feature is currently unavailable!'),
                            );
                          },
                          child: const Text(
                            'Sign In with Google',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RegisterScreen.id);
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Dont\'t have an Account?',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Color(0xFF5468FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
