import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_camera/internal/application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Application());
}

