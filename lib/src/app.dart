import 'package:CWC_Flutter/screen/home_page.dart';
import 'package:flutter/material.dart';
class App extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}