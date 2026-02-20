import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/features/home/home.dart';
import 'package:instagram_clone/features/sign_up_page/sign_up_page.dart';
import 'package:instagram_clone/firebase_options.dart';
import 'package:instagram_clone/services/prefs.dart';
// import 'package:instagram_clone/features/sign_in_page/sign_in_page.dart';
// import 'package:instagram_clone/features/sign_up_page/sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: _startPage(),
    );
  }
}

Widget _startPage() {
  return StreamBuilder(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        Prefs.saveUserId(snapshot.data!.uid);
        return Home();
      } else {
        Prefs.removeUserId();
        return SignUpPage();
      }
    },
  );
}
