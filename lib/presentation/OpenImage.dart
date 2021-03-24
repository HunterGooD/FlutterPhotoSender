import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/data/repository/photo_repository.dart';
import 'package:flutter_camera/domain/state/camera/camera_state.dart';
import 'package:flutter_camera/domain/state/camera/main_camera_state.dart';
import 'package:flutter_camera/internal/Config.dart';
import 'package:flutter_camera/presentation/DialogLoader.dart';

import 'DialogMessage.dart';

class OpenImage extends StatefulWidget {
  CameraState _cameraState;
  final XFile photo;
  final double longitude;
  final double latitude;

  OpenImage({Key key, this.photo, this.longitude, this.latitude})
      : super(key: key) {
    _cameraState = new MainCameraState(new Repository());
  }

  @override
  _OpenImageState createState() => _OpenImageState();
}

class _OpenImageState extends State<OpenImage> {
  bool _load = false;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  _send(BuildContext context) async {
    setState(() {
      _load = true;
    });

    DialogLoader.showLoadingDialog(context, _keyLoader);
    var data = await widget._cameraState.uploadPhoto(
        photo: File(widget.photo.path),
        longitude: widget.longitude,
        latitude: widget.latitude);
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

    if (data == null) {
      await DialogMessage.showMyDialog(
          context,
          "Фотография не загружена",
          "Ошибка при отправке повторите позже.Проверьте соединение с интернетом",
          "Повторить");
      setState(() {
        _load = false;
      });
      return;
    }

    if (data["error"] != null) {
      await DialogMessage.showMyDialog(context, "Фотография не загружена",
          "Ошибка отправки фотографии " + data["error"], "Повторить");
      setState(() {
        _load = false;
      });
      return;
    }
    print(data);

    await DialogMessage.showMyDialog(
        context, "Фотография загружена", "Можете закрыть приложение", "Ок",
        link: Config.url +
            data["response"]["photoTempURL"]);
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
                  File((widget.photo.path)),
                ),
              )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Позиция ${widget.latitude}:${widget.longitude}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              RaisedButton(
                onPressed: _load == false ? () => _send(context) : null,
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
