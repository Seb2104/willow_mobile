import 'package:flutter/material.dart';
import 'package:willow_mobile/tab_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, Widget> demoContent = const {
    'Format': First(),
    'Insert': Second(),
    'Review': Third(),
    'i forgot': Fourth(),
    'Uhhh poopy': Fifth(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,   // protects against battery / status bar
        bottom: false,
        child: TabView(
          content: demoContent,
        ),
      ),
    );
  }
}
