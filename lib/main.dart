import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/providers/bottom_navigation_bar_provider.dart';
import 'package:instagram_flutter02/providers/camera_provider.dart';
import 'package:instagram_flutter02/providers/like_read_notifier_provider.dart';
import 'package:instagram_flutter02/providers/profile_provider.dart';
import 'package:instagram_flutter02/providers/timeline_provider.dart';
import 'package:instagram_flutter02/screens/home_screen.dart';
import 'package:instagram_flutter02/screens/launch_screen.dart';
import 'package:instagram_flutter02/screens/login_screen.dart';
import 'package:instagram_flutter02/services/api/auth_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: "assets/.env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<User?>(
            create: (authContext) => FirebaseAuth.instance.authStateChanges(),
            initialData: null,
          ),
          ChangeNotifierProvider<BottomNavigationBarProvider>(
              create: (context) => BottomNavigationBarProvider()),
          ChangeNotifierProvider<TimelineProvider>(
              create: (context) => TimelineProvider()..init()),
          ChangeNotifierProvider<CameraProvider>(
              create: (context) => CameraProvider()),
          ChangeNotifierProvider<ProfileProvider>(
              create: (context) => ProfileProvider()),
          // ChangeNotifierProvider<PostViewProvider>(
          //     create: (context) => PostViewProvider()),
          // StreamProvider<List<BlogPost>>(
          //   initialData: [],
          //   create: (context) => blogPosts(),
          // ),
          // ProxyProvider<User?, Future<UserModel?>?>(
          //     create: (context) => null,
          //     update: (context, authUser, userModel) async {
          //       await getUser(authUser);
          //     }),
          // Provider<List<StoreItem>>(create: (context) => _storeItems),
          // ChangeNotifierProvider<CartNotifier>(
          //   create: (context) => CartNotifier(),
          // ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: LaunchScreen(),
        ));
  }

  // Future<UserModel?>? getUser(authUser) async {
  //   if (authUser == null) return null;
  //   return await AuthService.getUser(authUser.uid);
  // }
}
