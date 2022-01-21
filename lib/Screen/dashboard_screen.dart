import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dear_chat/Components/aldinfont.dart';
import 'package:dear_chat/Screen/chat_room.dat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

Stream<QuerySnapshot> stream = _firestore.collection('user').snapshots();

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  void checkStatusOfUser(String state) async {
    await _firestore.collection('user').doc(_auth.currentUser!.uid).update({
      'status': state,
    });
  }

  void displayStatus() async {
    var a =
        await _firestore.collection('user').doc(_auth.currentUser!.uid).get();
    print(a['status']);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    // updateUser("online");
    checkStatusOfUser("online");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      checkStatusOfUser("online");
      displayStatus();
    } else {
      checkStatusOfUser("offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Header(),
          Text(_auth.currentUser!.displayName.toString()),
          // const OnlineUser(),
          const ListOfUser()
        ]),
      ),
    ));
  }
}

class OnlineUser extends StatelessWidget {
  const OnlineUser({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 110,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs
                      .where((element) =>
                          (element['name'] != _auth.currentUser!.displayName) ||
                          element['status'] == 'unavailable')
                      .length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircleAvatar(
                            child: Icon(
                              Icons.person,
                              color: Colors.orange,
                            ),
                            backgroundColor: Colors.white70,
                          ),
                        ),
                        Text(snapshot.data!.docs[index]['name'],
                            style: Font.userName),
                      ],
                    );
                  }));
        });
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dear Chat ",
              style: Font.header,
            ),
            // IconButton(
            //   onPressed: () {
            //     Navigator.popUntil(
            //         context, ModalRoute.withName('login_Screen'));
            //   },
            //   icon: const Icon(Icons.logout,
            //     color: Colors.black,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class ListOfUser extends StatelessWidget {
  const ListOfUser({Key? key}) : super(key: key);

  String useId(String user1, user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SizedBox(
                width: 200,
                height: 50,
                child: ListView(
                  children: snapshot.data!.docs
                      .where((element) =>
                          element['name'] != _auth.currentUser!.displayName)
                      .map((document) {
                    if (document.exists) {
                      print(document.data());
                    }
                    return ListTile(
                      onTap: () async {
                        try {
                          String id = useId(
                              _auth.currentUser!.displayName.toString(),
                              document['name']);
                          print(id);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatRoom(
                                        userId: id,
                                        mapUser: document,
                                      )));
                        } catch (e) {
                          print(document['name']);
                          print(_auth.currentUser!.displayName);
                          print("Error at id: $e");
                        }
                      },
                      leading: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: CircleAvatar(
                          child: Icon(
                            Icons.person,
                            color: Colors.orange,
                          ),
                          backgroundColor: Colors.white70,
                        ),
                      ),
                      title: Text(
                        document['name'],
                        style: Font.userName,
                      ),
                      subtitle: Text(document['status']),
                    );
                  }).toList(),
                ),
              );
            }));
  }
}

class Profile extends StatelessWidget {
  Profile({Key? key, this.image}) : super(key: key);

  var image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 55,
        backgroundColor: const Color(0xffFDCF09),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.file(File(image!)))
            : const CircleAvatar(
                child: Icon(Icons.person),
              ));
  }
}
