import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_camera/domain/repository/photo_repository.dart';

abstract class CameraState {
  PhotoRepository _photoRepository;

  bool loadFinish = false;

  Future<void> uploadPhoto(
      {@required File photo,
      @required double longitude,
      @required double latitude}) async {
    final data = await _photoRepository.uploadPhoto(photo: photo, longitude: longitude, latitude: latitude);
  }
}
