import 'dart:io';
import 'package:dear_chat/Components/aldinfont.dart';
import 'package:dear_chat/Firebase_Comp/firebase_con.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  TextEditingController name = TextEditingController();

  String? userName;
  String? userEmail;
  String? userPassword;

  bool showSpin = false;

  XFile? _image;
  _imgFromCamera() async {
    XFile image = (await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50)) as XFile;
    // final imageTemp=File(image.relativePath);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    XFile image = (await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50)) as XFile;

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpin,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: const Color(0xffFDCF09),
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              File(_image!.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.fitHeight,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(50)),
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                  ),
                ),
              ),
              Text("Sign Up",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4.0))),
              const SizedBox(
                height: 20,
              ),
              TextField(
                textAlign: TextAlign.start,
                decoration: const InputDecoration(
                    filled: true,
                    prefixIcon: Icon(Icons.person),
                    fillColor: Colors.black12,
                    border: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    constraints: BoxConstraints(maxWidth: 340),
                    hintText: " User Name"),
                onChanged: (value) {
                  userName = value;
                  print(userName);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                textAlign: TextAlign.start,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                    fillColor: Colors.black12,
                    border: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    constraints: BoxConstraints(maxWidth: 340),
                    hintText: "Enter Email"),
                onChanged: (value) {
                  userEmail = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.start,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    filled: true,
                    fillColor: Colors.black12,
                    focusColor: Colors.black,
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    constraints: BoxConstraints(maxWidth: 340),
                    hintText: "Enter Password"),
                onChanged: (value) {
                  userPassword = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  try {
                    if (userEmail!.isNotEmpty &&
                        userName!.isNotEmpty &&
                        userPassword!.isNotEmpty) {
                      setState(() {
                        showSpin = true;
                      });
                      Account.createAccount(
                          userName!, userEmail!, userPassword!, _image!);
                      Navigator.pushNamed(context, 'login_Screen');

                      setState(() {
                        showSpin = false;
                      });
                    } else {
                      print("All the text");
                    }
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
                  child: Center(child: Text("SignUp", style: Font.buttonStyle)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
