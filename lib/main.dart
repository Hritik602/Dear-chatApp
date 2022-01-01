import 'package:dear_chat/Screen/chat_room.dat.dart';
import 'package:dear_chat/Screen/dashboard_screen.dart';
import 'package:dear_chat/Screen/login_screen.dart';
import 'package:dear_chat/Screen/register_screen.dart';
import 'package:dear_chat/Screen/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      initialRoute:"Dashboard_Screen" ,
      routes: {
        "Welcome_Screen":(context)=>const WelcomeScreen(),
        "login_Screen": (context) => const LoginScreen(),
        "Register_Screen":(context)=>const RegisterScreen(),
        "Dashboard_Screen":(context)=>const Dashboard(),
        "Chat_Room":(context)=> ChatRoom()
      }
    );
  }
}
