import 'package:flutter/material.dart';
import 'package:willow_mobile/app-theme.dart';

void main() {
  runApp(MainApp());
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
      theme: AppTheme.lightTheme(),
      title: 'ReCollect',
      home: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(color: AppTheme.surface(context)),
          child: Center(child: Text('Willow - Mobile')),
        ),
      ),
    );
  }
}
