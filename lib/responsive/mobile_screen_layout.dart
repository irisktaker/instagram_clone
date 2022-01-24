import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  // we will use provider package to shortcut all this process
  // String username = "";
  // @override
  // void initState() {
  //   super.initState();
  //   getUsername();
  // }
  
  // void getUsername() async {
  //   DocumentSnapshot snap = await FirebaseFirestore.instance
  //       // choose a collection
  //       .collection('users')
  //       // .doc(doc path)
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       // get data from this path in database
  //       .get();

  //   print(snap.data());

  //   setState(() {
  //     username = (snap.data() as Map<String, dynamic>)['username'];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: Center(
        child: Text(user.username),
      ),
    );
  }
}
