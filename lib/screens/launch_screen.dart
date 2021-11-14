import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/screens/home_screen.dart';
import 'package:provider/provider.dart';

class LaunchScreen extends StatelessWidget {
  // const LaunchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<User?>();
    if (authUser != null) {
      return HomeScreen(currentUid: authUser.uid);
    } else {
      return Container();
    }
  }
}
