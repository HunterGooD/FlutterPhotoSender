import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_camera/presentation/DialogMessage.dart';


import 'package:flutter_camera/presentation/OpenImage.dart';
import 'package:flutter_camera/presentation/geo.dart';
import 'package:geolocator/geolocator.dart';

import 'DialogLoader.dart';

class TakePhoto extends StatefulWidget {
  final CameraDescription firstCamera;

  const TakePhoto({Key key, this.firstCamera}) : super(key: key);

  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  CameraController _cameraController;
  Future<void> _initialControllerFuture;
  final _mainColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
        widget.firstCamera, ResolutionPreset.high,
        enableAudio: false);
    _initialControllerFuture = _cameraController
        .initialize()
        .then((_) {})
        .catchError((_) => SchedulerBinding.instance
            .addPostFrameCallback((_) => _toHome(context, "Не удалось получить доступ к камере")));
  }

  void _toHome(BuildContext context, String text) {
    Navigator.pop(context, text);
  }

  void _createPhoto() async {
    final GlobalKey<State> _keyLoader = new GlobalKey<State>();
    try {
      await _initialControllerFuture;
      Position pos;
      XFile photo;
      await _cameraController.takePicture().then((XFile file) {
        photo = file;
      });
      onSetFlashModeButtonPressed(FlashMode.off);

      DialogLoader.showLoadingDialog(context, _keyLoader, text: "Получение геоданных");
      await GeoDate.determinePosition().then((Position geoPosition) {
        pos = geoPosition;
      });
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OpenImage(
                  photo: photo,
                  longitude: pos.longitude,
                  latitude: pos.latitude)));
    } on CameraException {
      await DialogMessage.showMyDialog(
          context,
          "Ошибка с работой камеры",
          "Пожалуйста повторите попытку. Попробуйте поменять режим вспышки на без вспышки или с включенным фонариком.",
          "Повторить");
      _cameraController.dispose();
      Navigator.pop(context);
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      _toHome(context, "Не удается получить данные геолокации.");
    }
  }



  Future<void> setFlashMode(FlashMode mode) async {
    try {
      await _cameraController.setFlashMode(mode);
    } on CameraException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      setState(() {});
    });
  }

  Widget _flashModeControlRowWidget() {
    return ClipRect(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
            icon: Icon(Icons.flash_off),
            color: _cameraController?.value?.flashMode == FlashMode.off
                ? Colors.orange
                : _mainColor,
            onPressed: _cameraController != null
                ? () => onSetFlashModeButtonPressed(FlashMode.off)
                : null,
          ),
          IconButton(
            icon: Icon(Icons.flash_auto),
            color: _cameraController?.value?.flashMode == FlashMode.auto
                ? Colors.orange
                : _mainColor,
            onPressed: _cameraController != null
                ? () => onSetFlashModeButtonPressed(FlashMode.auto)
                : null,
          ),
          IconButton(
            icon: Icon(Icons.flash_on),
            color: _cameraController?.value?.flashMode == FlashMode.always
                ? Colors.orange
                : _mainColor,
            onPressed: _cameraController != null
                ? () => onSetFlashModeButtonPressed(FlashMode.always)
                : null,
          ),
          IconButton(
            icon: Icon(Icons.highlight),
            color: _cameraController?.value?.flashMode == FlashMode.torch
                ? Colors.orange
                : _mainColor,
            onPressed: _cameraController != null
                ? () => onSetFlashModeButtonPressed(FlashMode.torch)
                : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initialControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    color: Colors.black),
                child: Padding(
                  padding: EdgeInsets.all(1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CameraPreview(
                          _cameraController,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _flashModeControlRowWidget(),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 30),
                                    child: IconButton(
                                      color: _mainColor,
                                      icon: Icon(Icons.camera),
                                      onPressed: _createPhoto,
                                      iconSize: 50,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          }
          return Center(child: Text("Not Success"));
        },
      ),
    );
  }
}
