import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_three_broomsticks/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final box = GetStorage();

  bool startLogoutBouncer = false;
  bool startDeleteBouncer = false;

  SnackBar showSnackBar(var message) {
    return SnackBar(content: Text(message));
  }

  // Future<void> logoutAllDevices(BuildContext context) async {
  //   const url =
  //       'https://security-server-dev.deta.dev/v1/api/user/logout?all_devices=true';
  //
  //   try {
  //     final response = await http.post(Uri.parse(url), headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${widget.user['token']}',
  //     });
  //
  //     setState(() {
  //       startLogoutBouncer = false;
  //     });
  //     if (response.statusCode == 401) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         showSnackBar('Session logged out, please login again!'),
  //       );
  //       Navigator.pushNamed(context, LoginScreen.id);
  //     }
  //     var project = jsonDecode(response.body);
  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         showSnackBar('Successfully logout from all devices!'),
  //       );
  //
  //       Navigator.popUntil(context, ModalRoute.withName(LoginScreen.id));
  //     }
  //   } on Exception catch (error) {
  //     setState(() {
  //       startLogoutBouncer = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       showSnackBar('Something went wrong!'),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0181A20),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                foregroundImage: NetworkImage(box.read('imageUrl')),
                radius: 42,
                backgroundColor: const Color(0xFF0181A20),
              ),
              const SizedBox(
                height: 18,
              ),
              Text(
                '{ ${box.read('nickname')} }'.toUpperCase(),
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '${box.read('fName')} ${box.read('lName')}',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '${box.read('email')}',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '${box.read('mobile')}',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 42,
              ),
              Container(
                width: 220,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF5468FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        showSnackBar('Under development!');
                        print('Under development!');
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ChangePassword(
                        //       user: widget.user,
                        //     ),
                        //   ),
                        // );
                      },
                      child: const Text(
                        'Change Password',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              Container(
                width: 220,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF5468FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Get.offAll(const LoginScreen());
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    startLogoutBouncer
                        ? const SpinKitDoubleBounce(
                            color: Colors.white,
                            size: 50.0,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              Container(
                width: 220,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        // setState(() {
                        //   startDeleteBouncer = true;
                        // });
                        print('Under development!');
                        showSnackBar('Under development!');
                        // createProject(context);
                      },
                      child: const Text(
                        'Delete Account',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    startDeleteBouncer
                        ? const SpinKitDoubleBounce(
                            color: Colors.white,
                            size: 50.0,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
