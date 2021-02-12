import 'dart:io';
import 'package:flutter/cupertino.dart';

abstract class PhotoRepository {
  Future<void> uploadPhoto({@required File photo,
    @required double longitude,
    @required double latitude});
}
