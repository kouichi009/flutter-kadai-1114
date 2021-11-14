import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  // static final FirebaseMessaging _messaging = FirebaseMessaging();

  static Future<void> signUpUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? signedInUser = userCredential.user;
      String uid = signedInUser!.uid;
      final timestamp = FieldValue.serverTimestamp();
      String name = email.substring(0, email.indexOf('@'));
      print(name);

      usersRef.doc(uid).set({
        'name': 'name',
        'email': email,
        'profileImageUrl':
            'https://applimura.com/wp-content/uploads/2019/08/twittericon13.jpg',
        'timestamp': timestamp,
        'gender': '',
        'dateOfBirth': {'year': '', 'month': '', 'day': ''},
        'uid': uid,
        'androidNotificationToken': '',
        'status': 1
      });
      // Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: '2@gmail.com', password: '123456');
    } on PlatformException catch (err) {
      throw (err);
    }
  }

  static Future<UserModel> getUser(String uid) async {
    DocumentSnapshot documentSnapshot = await usersRef.doc(uid).get();
    UserModel userModel = UserModel.fromDoc(documentSnapshot);
    return userModel;
  }

  // static Stream<User> onAuthStateChanged() async {
  //   try {
  //     final user = await FirebaseAuth.instance.authStateChanges();
  //     return user;
  //     if (user is User) {
  //       print('user1');
  //     }
  //     if (user is UserCredential) {
  //       print('user2');
  //     }
  //     print("login success@@@@@@@ $user");
  //     // return user;
  //   } on PlatformException catch (err) {
  //     throw (err);
  //   }
  // }
}
