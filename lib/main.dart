import 'package:flutter/material.dart';
import 'package:willow_mobile/app-theme.dart';
import 'screens/home_page.dart';
import 'screens/landing_page.dart'; // 👈 added import

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      title: 'Willow',
      home: const LandingPage(),
    );
  }
}
