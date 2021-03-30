import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/data/repository/storage_repository.dart';
import 'package:flutter_camera/internal/Config.dart';
import 'package:flutter_camera/presentation/DialogLoader.dart';
import 'package:flutter_camera/presentation/DialogMessage.dart';
import 'package:flutter_camera/presentation/camera.dart';
import 'package:camera/camera.dart';

import 'geo.dart';

class Home extends StatefulWidget {
  /// Заголовок приложения
  final String title;

  Home({Key key, this.title}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List storages = [];
  List objects = [];
  int storage;
  int object;

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
      message,
      style: TextStyle(color: Colors.red),
    )));
  }

  void _toCreatePhoto() async {
    Config.objectID = object;
    Config.storageID = storage;

    final cameras = await availableCameras();
    if (cameras == null) {
      await DialogMessage.showMyDialog(context, "Ошибка",
          "Нужны права для использования камеры", "повторить");
      return;
    }
    final cameraFirst = cameras.first;
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePhoto(
                  firstCamera: cameraFirst,
                )));
    if (result != null) {
      DialogMessage.showMyDialog(context, "Ошибка", result, "Ок");
    }
  }

  @override
  initState() {
    super.initState();
    // получение складов
    _getStorage();
  }

  _getStorage() async {
    final data = await StorageRepo().getStorages();
    print(data);
    if (data["storages"] != null) {
      setState(() {
        storages = data["storages"];
      });
    } else if (data["error"] != null) {
      DialogMessage.showMyDialog(
          context, "Ошибка сервера", "Ошибка. ${data['error']}", "Повтор");
      _getStorage();
    } else {
      DialogMessage.showMyDialog(
          context, "Ошибка", "Проверьте интеренет соединение", "Ок");
    }
  }

  @override
  Widget build(BuildContext context) {
    GeoDate.determinePosition();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(Config.fio)),
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                Config.sessionID = "";
                Navigator.pushNamedAndRemoveUntil(
                    context, "/login", (route) => false);
              }),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Склад",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 20, right: 20, left: 20, top: 10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(20)),
              child: DropdownButton(
                  underline: SizedBox(),
                  iconSize: 40,
                  isExpanded: true,
                  hint: Text("Ввыберите склад"),
                  onChanged: (newVal) => setState(() {
                    storage = newVal;
                          for (dynamic e in storages) {
                              print(e);
                              if (e["id"] == newVal) {
                                objects = e["autos"];
                                break;
                              }
                          }
                      }),
                  value: storage,
                  items: storages.map((val) {
                    return DropdownMenuItem(
                      value: val["id"],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(val["name_storage"]),
                          ),
                          Text(val["address"], style: TextStyle(color: Colors.grey,fontSize: 10)),
                        ],
                      ),
                    );
                  }).toList()),
            ),
          ),
          Text("Объект",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 20, right: 20, left: 20, top: 10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(20)),
              child: DropdownButton(
                  underline: SizedBox(),
                  iconSize: 40,
                  isExpanded: true,
                  hint: Text("Выберите объект"),
                  onChanged: (newVal) => setState(() {
                    object = newVal;
                      }),
                  value: object,
                  items: objects.map((val) {
                    return DropdownMenuItem(
                      value: val["id"],
                      child: Text(val["name_auto"]),
                    );
                  }).toList()),
            ),
          ),
          RaisedButton(
              onPressed:
                  object != null && storage != null ? _toCreatePhoto : null,
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        "Отправить фото",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Icon(Icons.add_a_photo))
                    ],
                  ))),
        ],
      ),
    );
  }
}
