import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_camera/presentation/camera.dart';
import 'package:camera/camera.dart';

class Home extends StatefulWidget {

  /// Заголовок приложения
  final String title;

  Home({Key key, this.title}) : super(key: key);


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.red),
        )));
  }
  void _toCreatePhoto() async {
    final cameras = await availableCameras();
    if (cameras == null){
      showInSnackBar("Нужны права для использования камеры");
    }
    final cameraFirst = cameras.first;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => TakePhoto(firstCamera: cameraFirst,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
                onPressed: _toCreatePhoto,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [Text("Отправить фото"), Icon(Icons.add_a_photo)],
                    ))),
          ],
        ),
      ),
    );
  }
}
