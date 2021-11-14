import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SplashScreen extends StatefulWidget {
  final Function(String) authCallback;

  const SplashScreen({
    Key? key,
    required this.authCallback,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1)).then(
      (_) => _setup(context).then(
        (value) => widget.authCallback("authcall"),
      ),
    );
  }

  Future<bool> _setup(BuildContext _context) async {
    await Future.wait([
      Firebase.initializeApp(),
      dotenv.load(fileName: "assets/.env"),
    ]);

    // final Stream<User?> authResult =
    //     await FirebaseAuth.instance.authStateChanges();
    FirebaseAuth.instance.authStateChanges().listen((user2) {
      print(user2?.uid);
      print(user2);
      print('user2');
    });
    // print(user1);
    print('a');
    return true;
    // await Firebase.initializeApp();
    // await dotenv.load(fileName: "assets/.env");
    // final getIt = GetIt.instance;

    // final configFile = await rootBundle.loadString('assets/config/main.json');
    // final configData = jsonDecode(configFile);

    // getIt.registerSingleton<AppConfig>(
    //   AppConfig(
    //     BASE_API_URL: configData['BASE_API_URL'],
    //     BASE_IMAGE_API_URL: configData['BASE_IMAGE_API_URL'],
    //     API_KEY: configData['API_KEY'],
    //   ),
    // );

    // getIt.registerSingleton<HTTPService>(
    //   HTTPService(),
    // );

    // getIt.registerSingleton<MovieService>(
    //   MovieService(),
    // );
  }

  // Future<void> getAuthUser() {
  //   FirebaseAuth.instance.authStateChanges().listen((user2) {
  //     print(user2);
  //     print('user2');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flickd',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Center(
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage('assets/images/logo.png'),
            ),
          ),
        ),
      ),
    );
  }
}
