import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:namer_app/pages/student_page.dart';
import 'pages/coupons_page.dart';
import 'pages/map_page.dart';
import 'pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/signup_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:FirebaseOptions(
      apiKey: "AIzaSyAbrzt7NugglF_H1OqP45Y1YArsT4yHP2c",
      authDomain: "hackdavis24-59799.firebaseapp.com",
      projectId: "hackdavis24-59799",
      storageBucket: "hackdavis24-59799.appspot.com",
      messagingSenderId: "694595341378",
      appId: "1:694595341378:web:022adcd01483c09c88f1db",
      measurementId: "G-62DQC040GL"
    )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Coupons',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Flutter Demoooooooo'),
      //LoginScreen(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/dashboard': (BuildContext context) => new RestaurantCouponPage(),
        '/student': (BuildContext context) => new StudentPage()
      },
    );
  }
}