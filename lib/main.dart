import 'package:bus_tracking/Screens/home_screen.dart';
import 'package:bus_tracking/Screens/splash_screen.dart';
import 'package:bus_tracking/blacktint.dart';
import 'package:bus_tracking/google_map copy.dart';
import 'package:bus_tracking/google_map.dart';
import 'package:bus_tracking/maps.dart';
import 'package:bus_tracking/model/routes.dart';
import 'package:bus_tracking/tracking_bus/get_loaction.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:bus_tracking/Screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Tracking App',
      theme: ThemeData(
        //backgroundColor: Colors.black
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      //initialRoute: splashRoute,
      routes: routes,
      home:welcomeScreen(),
    );
  }
}
