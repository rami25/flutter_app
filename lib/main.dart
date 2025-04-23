import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/home.dart';

void main() {
  runApp(MyApp());
}

// The main app widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navigation Example',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: HomePage(),
    );
  }
}