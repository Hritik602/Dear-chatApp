import 'package:dear_chat/Screen/dashboard_screen.dart';
import 'package:dear_chat/Screen/login_screen.dart';
import 'package:dear_chat/Screen/register_screen.dart';
import 'package:dear_chat/Screen/tab_view.dart';
import 'package:dear_chat/Screen/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'Screen/home_list_of_user.dart';

Future<void> backgroundMessage(RemoteMessage message) async {
  print(message.notification!.title);
  print(message.notification!.body);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundMessage);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: "Authenticate",
        routes: {
          "Welcome_Screen": (context) => const WelcomeScreen(),
          "login_Screen": (context) => const LoginScreen(),
          "Register_Screen": (context) => const RegisterScreen(),
          "Dashboard_Screen": (context) => const Dashboard(),
          // "Chat_Room": (context) => ChatRoom(),
          "Authenticate": (context) => const Authenticate(),
          "Home_Screen": (context) => HomeTabView(),
        });
  }
}
