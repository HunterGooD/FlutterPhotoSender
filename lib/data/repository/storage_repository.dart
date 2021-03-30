import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_camera/internal/Config.dart';

class StorageRepo  {
  @override
  Future<dynamic> getStorages() async {
    final String url = Config.url;

    Dio dio = new Dio();
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;

    dynamic JSONResponse;
    await dio.get(url + "/api/getStorages", options: Options(
          headers: {
            "Authorization": Config.sessionID,
          },
        )).then((response) {
      JSONResponse = jsonDecode(response.toString());
    }).catchError((e) => print(e));
    return JSONResponse;
  }
}