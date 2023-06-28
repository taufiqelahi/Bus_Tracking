


import 'package:bus_tracking/driver.dart';
import 'package:bus_tracking/blacktint.dart';
import 'package:bus_tracking/google_map.dart';
import 'package:bus_tracking/screens/home_screen.dart';
import 'package:bus_tracking/screens/login_screen.dart';
import 'package:bus_tracking/screens/splash_screen.dart';
import 'package:bus_tracking/screens/welcome_screen.dart';

const String welcomeRoute = "/welcome";
const String homeRoute = "/home";
const String loginRoute = "/login";
const String splashRoute = "/splash";
const String passengerRoute = "/pppp";
const String showRoute = "/ppsspp";
const String showssRoute = "/ppsspssp";





final routes = {
  welcomeRoute: (context) => welcomeScreen(),
  homeRoute: (context) => HomeScreen(),
  loginRoute: (context) => LoginScreen(),
  splashRoute: (context) => splashScreen(),
  passengerRoute:(context)=>PassengerMode(),
  showRoute:(context)=>BlackTint(),
  showssRoute:(context)=>LocationTracking()
  

};
