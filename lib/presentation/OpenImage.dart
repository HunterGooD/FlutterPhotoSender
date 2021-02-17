import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/data/repository/photo_repository.dart';
import 'package:flutter_camera/domain/state/camera/camera_state.dart';
import 'package:flutter_camera/domain/state/camera/main_camera_state.dart';

import 'DialogMessage.dart';

class OpenImage extends StatelessWidget {
  CameraState _cameraState;
  final XFile photo;
  final double longitude;
  final double latitude;

  OpenImage({Key key, this.photo, this.longitude, this.latitude}) :super(key: key) {
    _cameraState = new MainCameraState(new Repository());
  }

  _send(BuildContext context) async {
    await _cameraState.uploadPhoto(photo: File(photo.path), longitude: longitude, latitude: latitude);
    await DialogMessage.showMyDialog(
        context,
        "Фотография загружена",
        "Можете закрыть приложение",
        "Ок");
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Photo"),
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
              child: Column(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Image.file(
                  File((photo.path)),
                ),
              )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Позиция $latitude:$longitude",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              RaisedButton(
                onPressed: () => _send(context),
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Отправить"), Icon(Icons.send_sharp)],
                    )),
              )
            ],
          ))),
    );
  }
}
