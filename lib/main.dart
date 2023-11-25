import 'package:flutter/material.dart';
import 'package:video_uploading/bottom_nav.dart';
import 'package:video_uploading/screens/Sign%20In/login_register_page.dart';
import 'package:video_uploading/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:video_uploading/service/auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: snapshot.hasData ? const BottomBar() : const LoginPage(),
            routes: {
              '/Home': (context) => const HomePage(),
            },
          );
        });
  }
}
