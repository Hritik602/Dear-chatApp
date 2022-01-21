import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Account {
  void errorMessage(BuildContext context, String errorMessage) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(errorMessage),
          );
        });
  }

  static Future<User?> createAccount(
      String name, String userEmail, String userPassword, XFile image) async {
    try {
      UserCredential user = (await _auth.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword));
      print(user.additionalUserInfo!.username);
      user.user!.updateDisplayName(name);
      _firestore.collection('user').doc().set({
        "name": name,
        "email": userEmail,
        "status": "Unavailable",
        "image": image.path,
      }).then((value) {
        if (user != null) {
          print(user);
        } else {
          print("Not created");
        }
      });
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<User?> login(String userEmail, String userPassword) async {
    try {
      User user = (await _auth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword)) as User;
      if (user != null) {
        print("Account Created successfuly");
      } else {
        print("Not created");
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<User?> logOut() async {
    try {
      User user = (await _auth.signOut()) as User;
      if (user != null) {
        print(" ");
      } else {
        print(" ");
        // Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }
}
