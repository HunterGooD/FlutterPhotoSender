import 'package:flutter/material.dart';
import 'package:flutter_camera/internal/Config.dart';
import 'package:flutter_camera/internal/application.dart';

void main() async {
  var url = "https://defsgthjyhtgrkj.herokuapp.com";
  Config.url = url;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Application());
}
