


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dear_chat/Screen/chat_room.dat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);


  String useId(String user1,user2){
    if(user1[0].toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]){
      return "$user1$user2";
    }
    else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.popUntil(
                    context, ModalRoute.withName('login_Screen'));
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('user').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return SizedBox(
                      width: 200,
                      height: 50,
                      child: ListView(
                        children:  snapshot.data!.docs.map((document){
                            return ListTile(
                              onTap: () async{
                                String id= await useId(_auth.currentUser!.displayName.toString(),document['name'] );
                                Navigator.push(context,   MaterialPageRoute(builder: (context)=>ChatRoom(userId: id,mapUser: document,)));
                              },
                          // leading: Profile(image: document['image'],),
                          title: Text(document['name']),
                              subtitle: Text(document['email']),
                            );
                          }
                          ).toList()

                              

                      ));
                }
                )
        )
    );
  }
}


class Profile extends StatelessWidget {
   Profile({Key? key,this.image}) : super(key: key);

  var image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 55,
      backgroundColor: const Color(0xffFDCF09),
      child: image != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.network(image),
      ):const CircleAvatar(
        child: Icon(Icons.person),
      )
    );

  }
}
