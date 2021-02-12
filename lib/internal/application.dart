import 'package:flutter/material.dart';
import 'package:flutter_camera/presentation/home.dart';

class Application extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter camera',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(title: "Flutter Camera"),
    );
  }
}
