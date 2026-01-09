import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ✅ Change 1: Splash Screen wapas layein
import 'view/splash_view/splash_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sp = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adaptive Learning',
      theme: ThemeData(primarySwatch: Colors.blue),
      
      // ✅ Change 2: App shuru kahan se hoga? Splash se!
      home: SplashScreen(), 
    );
  }
}