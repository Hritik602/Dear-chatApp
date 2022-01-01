import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dear_chat/Components/aldinfont.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;

  Animation? animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    controller!.forward();

    animation = ColorTween(begin: Colors.white, end: Colors.blueAccent)
        .animate(controller!);

    controller!.addListener(() {
      setState(() {});
      print(animation!.value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller!.isDismissed;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: animation!.value,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AnimatedTextKit(animatedTexts: [
              TypewriterAnimatedText('Dear',
                  speed: const Duration(milliseconds: 150),
                  textStyle: GoogleFonts.aladin(
                    letterSpacing: 3.0,
                    fontSize: 32,
                    color: Colors.black,
                  ))
            ]),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () async {
              try {
                Navigator.pushNamed(context, "login_Screen");
              } catch (e) {
                print(e);
              }
            },
            child: Container(
              height: 43,
              width: 200,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Colors.blue, Colors.purpleAccent])),
              child: Center(child: Text("SignIn", style: Font.buttonStyle)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              try {
                Navigator.pushNamed(context, "Register_Screen");
              } catch (e) {
                print(e);
              }
            },
            child: Container(
              height: 43,
              width: 200,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.centerLeft,
                      colors: [Colors.blue, Colors.purpleAccent])),
              child: Center(child: Text("SignUp", style: Font.buttonStyle)),
            ),
          ),
        ],
      ),
    ));
  }
}
