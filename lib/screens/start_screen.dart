import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_three_broomsticks/screens/login_screen.dart';

class StartScreen extends StatefulWidget {
  static const String id = 'start_screen';

  const StartScreen({Key? key}) : super(key: key);
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var start = 'Get Started';
  bool startBouncer = false;

  SnackBar showSnackBar(var message) {
    return SnackBar(content: Text(message));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'images/broomsticks.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'The Three ',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                        text: "Broomsticks",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " !",
                        style: TextStyle(
                          color: Color(0xFF5468FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'We\'re only as strong as we are united, ',
                  style: GoogleFonts.ubuntu(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'and as weak as we are divided.',
                  style: GoogleFonts.ubuntu(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Note: Currently App is highly unstable, we are following rolling release.',
                  style: GoogleFonts.ubuntu(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                // Text(
                //   'and use one another, even relate to',
                //   style: GoogleFonts.ubuntu(
                //     fontWeight: FontWeight.bold,
                //     color: Colors.white,
                //   ),
                // ),
                // Text(
                //   'one another. A warm, messy',
                //   style: GoogleFonts.ubuntu(
                //     fontWeight: FontWeight.bold,
                //     color: Colors.white,
                //   ),
                // ),
                // Text(
                //   'circle of humanity.',
                //   style: GoogleFonts.ubuntu(
                //     fontWeight: FontWeight.bold,
                //     color: Colors.white,
                //   ),
                // ),
                const SizedBox(
                  height: 30,
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
                        onPressed: () async {
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                        child: Text(
                          start,
                          style: const TextStyle(color: Colors.white),
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
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//'We're only as strong as we are united, and as weak as we are divided.'
//'There are some things you can't share without ending up liking each other, and knocking out a twelve-foot mountain troll is one them'
