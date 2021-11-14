import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/providers/bottom_navigation_bar_provider.dart';
import 'package:instagram_flutter02/screens/camera_screen.dart';
import 'package:instagram_flutter02/screens/login_screen.dart';
import 'package:instagram_flutter02/screens/news_api/news_screen.dart';

import 'package:instagram_flutter02/screens/profile_screen.dart';
import 'package:instagram_flutter02/screens/sign_up_screen.dart';
import 'package:instagram_flutter02/screens/test_post.dart';
import 'package:instagram_flutter02/screens/timeline_screen.dart';
import 'package:instagram_flutter02/services/api/auth_service.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  String? currentUid;
  HomeScreen({this.currentUid});

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  configurePushNotifications() {
    if (Platform.isIOS) getiOSPermission();

    _firebaseMessaging.getToken().then((token) {
      usersRef.doc(currentUid).update({"androidNotificationToken": token});
    });

    // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
    // _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
    //   // _serialiseAndNavigate(message);
    // });

    // // replacement for onResume: When the app is in the background and opened directly from the push notification.
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
    //   // _serialiseAndNavigate(message);
    // });

    // onMessage: When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      if (message == null) return;
      final String recipientId = message.data['recipient'];
      final String? body = message.notification?.body;

      if (recipientId == currentUid) {
        SnackBar snackbar = SnackBar(
            content: Text(
          body!,
          overflow: TextOverflow.ellipsis,
        ));
        // _scaffoldKey.currentContext
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: const Text('snack'),
        //   duration: const Duration(seconds: 1),
        //   action: SnackBarAction(
        //     label: 'ACTION',
        //     onPressed: () {},
        //   ),
        // ));
        _scaffoldKey.currentState?.showSnackBar(snackbar);
      }
    });
// *****************************************

    // _firebaseMessaging.configure(
    //   // onLaunch: (Map<String, dynamic> message) async {},
    //   // onResume: (Map<String, dynamic> message) async {},
    //   onMessage: (Map<String, dynamic> message) async {
    //     final String recipientId = message['data']['recipient'];
    //     final String body = message['notification']['body'];
    //     if (recipientId == user.id) {
    //       SnackBar snackbar = SnackBar(
    //           content: Text(
    //         body,
    //         overflow: TextOverflow.ellipsis,
    //       ));
    //       _scaffoldKey.currentState.showSnackBar(snackbar);
    //     }
    //   },
    // );
  }

  getiOSPermission() {
    _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    configurePushNotifications();
    var currentTab = [
      TimelineScreen(),
      CameraScreen(),
      ProfileScreen(),
      TestPost()
    ];

    final bottomNavigationBar = context.watch<BottomNavigationBarProvider>();

    // final bottomNavigationBar =
    //     Provider.of<BottomNavigationBarProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: currentTab[bottomNavigationBar.currentIndex],
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: bottomNavigationBar.currentIndex,
        onTap: (index) {
          bottomNavigationBar.currentIndex = index;
        },
        activeColor: Theme.of(context).primaryColor,
        // type: BottomNavigationBarType.fixed,
        // selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
              size: 35.0,
            ),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
        ],
      ),
    );
    // return Container();
  }
}
