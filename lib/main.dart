import 'package:flutter/material.dart';
import 'package:chatapp/helper/authentication.dart';
import 'package:chatapp/helper/helperfunction.dart';

import 'package:chatapp/views/chatRoomScreen.dart';
import 'package:chatapp/splash/splashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
     // Authenticate(),
    );
  }
}

