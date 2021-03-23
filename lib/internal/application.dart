import 'package:flutter/material.dart';
import 'package:flutter_camera/presentation/authorization.dart';
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
        initialRoute: "/login",
        routes: {
          '/login': (context) => Authorization(),
          '/': (context) => Home(title: "Flutter Camera"),
        });
  }
}
