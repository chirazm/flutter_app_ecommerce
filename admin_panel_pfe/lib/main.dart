import 'dart:io';

import 'package:admin_panel_pfe/views/Splash_screen.dart';
import 'package:admin_panel_pfe/views/screens/Login_screen.dart';
import 'package:admin_panel_pfe/views/screens/Home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: kIsWeb || Platform.isAndroid
          ? FirebaseOptions(
              apiKey: "AIzaSyDkd3hqBdQlPJGrsTPlen8Kgz3XyQygrwI",
              authDomain: "pfe2023-75d31.firebaseapp.com",
              projectId: "pfe2023-75d31",
              storageBucket: "pfe2023-75d31.appspot.com",
              messagingSenderId: "927570459688",
              appId: "1:927570459688:web:01d609f76c860300b7091d")
          : null);

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
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 253, 159, 19),
      ),
      home: SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
