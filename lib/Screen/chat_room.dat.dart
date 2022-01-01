

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatRoom extends StatelessWidget {
  ChatRoom({Key? key, this.userId,this.mapUser}) : super(key: key);

  QueryDocumentSnapshot ?mapUser;
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  FirebaseAuth _auth =FirebaseAuth.instance;
  String? userId;
  
  void _sendMessage()async{
    if(_messages.text.isNotEmpty){
      Map<String ,dynamic > messages={
        "sendBy":_auth.currentUser!.displayName,
        "messages":_messages.text,
        "time":FieldValue.serverTimestamp()
      };
      await _firestore.collection('chats Room').doc(userId).collection('chats').add(messages);
      _messages.clear();
    }else{
      print("message is empty");
    }
  }
  final TextEditingController _messages=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(mapUser!['name']),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Container(
                width: MediaQuery.of(context).size.width,
               height: 550,
               child: StreamBuilder<QuerySnapshot>(
                 stream: _firestore.collection("chats Room").doc(userId).collection("chats").orderBy("time",descending:false).snapshots(),
                 builder: (BuildContext context ,AsyncSnapshot snap){
                   return  ListView.builder(
                     itemCount: snap.data.docs.length,
                       itemBuilder: (context,i){
                       Map<String ,dynamic> map=snap.data.docs[i].data();
                       return messages( map:map);
                       }
                   );
                 },
               )

              ),
              Row(
                children: [
                 Expanded(
                   child: Container(
                     child: TextField(
                       controller: _messages,
                       decoration:  InputDecoration(
                         hintText: "Type Your Messages...",
                         focusColor: Colors.blueAccent,
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(15.0),

                         )
                       ),
                     ),
                   ),
                 ),
                  IconButton(
                      onPressed: _sendMessage,
                      icon: Icon(Icons.send)
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget messages( {required Map<String, dynamic> map}){
    return Container(
      alignment: map['sendBy']==_auth.currentUser!.displayName ?
          Alignment.centerRight:Alignment.centerLeft,
          child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 8.0),
            margin:  const EdgeInsets.symmetric(vertical: 5.0,horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.blue,Colors.blueAccent,Colors.blueGrey
                ]
              )
            ),
            child: Text(map["messages"],
            style: GoogleFonts.aladin(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
            ),
            ),
    ),
    );
  }
}
