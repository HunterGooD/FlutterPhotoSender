import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_camera/presentation/OpenImage.dart';

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
    _cameraController =
        CameraController(widget.firstCamera, ResolutionPreset.high);
    _initialControllerFuture = _cameraController.initialize();
  }

  Future<void> _showMyDialog(String title, message, buttonText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(title),
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(buttonText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _createPhoto() async {
    try {
      await _initialControllerFuture;
      Position pos;
      XFile photo;
      await _cameraController.takePicture().then((XFile file) {
        photo = file;
      });
      onSetFlashModeButtonPressed(FlashMode.off);
      await _determinePosition().then((Position geoPosition) {
        pos = geoPosition;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OpenImage(
                  photo: photo,
                  longitude: pos.longitude,
                  latitude: pos.latitude)));
    } on CameraException {
      await _showMyDialog(
          "Ошибка с работой камеры",
          "Пожалуйста повторите попытку. Попробуйте поменять режим вспышки на без вспышки или с включенным фонариком.",
          "Повторить");
      _cameraController.dispose();
      Navigator.pop(context);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
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
