import 'dart:io';
import 'package:flutter/cupertino.dart';

class PhotoData {
  final File photo;
  final double latitude;
  final double longitude;

  PhotoData(
      {@required this.photo,
      @required this.latitude,
      @required this.longitude});
}
