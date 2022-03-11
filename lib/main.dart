import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:the_three_broomsticks/screens/dashboard_screen.dart';
import 'package:the_three_broomsticks/screens/login_screen.dart';
import 'package:the_three_broomsticks/screens/register_screen.dart';
import 'package:the_three_broomsticks/screens/start_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const StartScreen(),
      initialRoute: StartScreen.id,
      routes: {
        StartScreen.id: (context) => const StartScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        DashboardScreen.id: (context) => const DashboardScreen(),
      },
    );
  }
}
