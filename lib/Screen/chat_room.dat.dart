import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatRoom extends StatelessWidget {
  ChatRoom({Key? key, this.userId, this.mapUser}) : super(key: key);

  QueryDocumentSnapshot? mapUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? userId;

  void encryptDecrypt() {}

  void _sendMessage() async {
    if (_messages.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendBy": _auth.currentUser!.displayName,
        "messages": _messages.text,
        "time": FieldValue.serverTimestamp()
      };
      await _firestore
          .collection('chats Room')
          .doc(userId)
          .collection('chats')
          .add(messages);
      _messages.clear();
    } else {
      print("message is empty");
    }
  }

  final TextEditingController _messages = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          mapUser!['name'],
          style: GoogleFonts.aladin(
              textStyle: const TextStyle(color: Colors.black)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.79,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection("chats Room")
                        .doc(userId)
                        .collection("chats")
                        .orderBy("time", descending: false)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snap) {
                      if (snap.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snap.data.docs.length,
                            itemBuilder: (context, i) {
                              Map<String, dynamic> map =
                                  snap.data.docs[i].data();
                              print(map);
                              return Messages(
                                map: map,
                                auth: _auth,
                              );
                            });
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: TextField(
                        textInputAction: TextInputAction.send,
                        controller: _messages,
                        decoration: InputDecoration(
                            hintText: "Type Your Messages...",
                            focusColor: Colors.blueAccent,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            )),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: _sendMessage, icon: const Icon(Icons.send))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Messages extends StatelessWidget {
  Messages({Key? key, required this.map, required this.auth}) : super(key: key);
  Map<String, dynamic> map;
  FirebaseAuth auth;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: map['sendBy'] == auth.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: map['sendBy'] == auth.currentUser!.displayName
              ? Colors.red
              : Colors.blueGrey,
        ),
        child: Column(
          children: [
            Text(
              map["messages"],
              style: GoogleFonts.aladin(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ),
            // Text("${DateTime.now().minute.toString()} min ago"),
          ],
        ),
      ),
    );
  }
}
