import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class OpenImage extends StatelessWidget {
  final XFile photo;
  final double longitude;
  final double latitude;

  const OpenImage({Key key, this.photo, this.longitude, this.latitude})
      : super(key: key);

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
                onPressed: null,
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
