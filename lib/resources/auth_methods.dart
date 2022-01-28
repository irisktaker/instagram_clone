import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // process for sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    // Photo Storage in firebase | https://console.firebase.google.com/u/0/project/instagram-clone-3f8e3/storage/instagram-clone-3f8e3.appspot.com/files
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty ||
              password.isNotEmpty ||
              username.isNotEmpty ||
              bio.isNotEmpty
          // || file != null
          ) {
        // register user
        // Cloud Firestore
        // https://console.firebase.google.com/u/0/project/instagram-clone-3f8e3/firestore/data/~2Fusers~2FDZvbxDr2ZGNmyu3UspliEC7YrU62
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        // storage_methods.dart
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        // add user to database
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          photoUrl: photoUrl,
          bio: bio,
          followers: [],
          following: [],
        );

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJason());
        // await _firestore.collection('users').doc(cred.user!.uid).set({
        //   'username': username,
        //   'uid': cred.user!.uid,
        //   'email': email,
        //   'bio': bio,
        //   'followers': [],
        //   'following': [],
        //   'photoUrl': photoUrl,
        // });

        // another way
        // this method will generate a different id for user (user id and uid) in the Cloud Firestore
        // _firestore.collection('users').add({
        //   'username': username,
        //   'uid': cred.user!.uid,
        //   'email': email,
        //   'bio': bio,
        //   'followers': [],
        //   'following': [],
        // });

        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is badly formatted';
      } else if (err.code == 'weak-password') {
        res = 'Password should be at least 6 characters';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // process for sign up user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error accorded";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'please enter all the fields';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'User not found';
      } else if (e.code == 'wrong-password') {
        res = 'Wrong password';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
