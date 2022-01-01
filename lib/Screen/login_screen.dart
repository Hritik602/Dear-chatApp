
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dear_chat/Components/aldinfont.dart';
import 'package:dear_chat/Firebase_Comp/firebase_con.dart';
import 'package:dear_chat/Screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen>  with SingleTickerProviderStateMixin{




  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  String ? registerEmail;
  String ? registerPassword;



   _openMyPage(BuildContext context) {
    Navigator.push(context,MaterialPageRoute(builder: (context)=>const RegisterScreen()));

  }
bool showSpin =false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpin,
        child: SafeArea(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 20,),

                const  SizedBox(height: 10,),



                TextField(
                  cursorColor: Colors.black,
                  cursorWidth: 2.2,
                  cursorRadius: const Radius.circular(5.0),
                  keyboardType: TextInputType.emailAddress ,
                  controller: email,
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderSide:BorderSide(
                          color: Colors.black,
                        style: BorderStyle.solid) ,
                          borderRadius:  BorderRadius.all(Radius.circular(20))
                      ),
                      constraints: BoxConstraints(
                          maxWidth: 340
                      ),
                      hintText: "Enter Email",
                    hintStyle: TextStyle(fontSize:22,
                      letterSpacing: 5.0,
                    )
                  ),
                  onChanged: (value){
                    registerEmail=value;
                  },
                ),
                const SizedBox(height: 20,),


                // const Text("Enter Your Password",
                //   style: TextStyle(fontSize: 20,
                //   ),
                // ),


                const  SizedBox(height: 10,),


                /*Password field*/
                TextField(
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  textAlign: TextAlign.start,


                  decoration:const InputDecoration(
                    prefixIcon: Icon(Icons.password),
                      fillColor: Colors.black,
                      focusColor: Colors.black,
                      border: UnderlineInputBorder(
                        borderRadius:  BorderRadius.all(Radius.circular(20)),

                      ),
                      constraints: BoxConstraints(
                          maxWidth: 340
                      ),
                      hintText: "Enter Password",
                    hintStyle: TextStyle(
                      fontSize: 22,
                      letterSpacing: 5.0,
                      // decoration: TextDecoration.underline,
                      // decorationStyle: TextDecorationStyle.wavy,
                      // decorationColor: Colors.red,
                      // decorationThickness: 0.5,
                    )
                  ),
                  onChanged: (value){
                registerPassword=value;
                  },
                ),


                const SizedBox(height: 20,),



                InkWell(
                  onTap: ()async {

                    try{
                      if (registerEmail!.isNotEmpty &&
                          registerPassword!.isNotEmpty) {
                        setState(() {
                          showSpin = true;
                        });

                  Account.login(registerEmail!,registerPassword!).then((value) {
                    if(value!=null){
                      print(value);
                    }
                    else{
                      print(" value is null");
                    }
                  });
                        Navigator.pushNamed(context, "Dashboard_Screen");
                        email.clear();
                        password.clear();

                        setState(() {
                          showSpin = false;
                        });
                      }
                      else{
                        print("All the text");
                      }
                    }catch(e){
                      print(e);
                    }
                  },
                  child: Container(
                    height: 43,
                    width: 200,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin:Alignment.centerRight ,
                            end: Alignment.centerLeft,
                            colors: [
                              Colors.blue,
                              Colors.purpleAccent
                            ])
                    ),
                    child:  Center(child: Text("SignIn",
                        style:Font.buttonStyle
                    )),
                  ),
                ),


                // const Spacer(),
                const  SizedBox(height: 30,),


                RichText(
                    text: const TextSpan(
                        children: [
                          TextSpan(text: "Didn't Register Yet ? ",
                            style: TextStyle(color: Colors.black,
                                fontSize: 20
                            ),
                          ),
                          TextSpan(text: "Register Now",
                              // recognizer:_openMyPage(context),
                            style: TextStyle(color: Colors.pink,
                                fontSize: 20
                            ),
                          ),
                        ]
                    )

                ),
              ],
            )
        ),
      ),
    );
  }
}

class AppName extends StatelessWidget {
  const AppName({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(

      child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
                'Dear Chat',
                speed:const  Duration(milliseconds: 150),
                textStyle:GoogleFonts.aladin(
                  letterSpacing: 2.0,
                  fontSize: 30,
                  color: Colors.black87
                )
            )
          ]

      ),

    );
  }
}
