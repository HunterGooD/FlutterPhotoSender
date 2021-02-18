import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_camera/domain/repository/photo_repository.dart';

class Repository extends PhotoRepository {
  @override
  Future<dynamic> uploadPhoto(
      {File photo, double longitude, double latitude}) async {
    final file = photo;
    final String url = 'https://defsgthjyhtgrkj.herokuapp.com';
    String fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      "longitude": longitude,
      "latitude": latitude,
      "photo": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    Dio dio = new Dio();
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;

    dynamic JSONResponse;
    await dio.post(url + "/api/upload", data: data).then((response) {
      JSONResponse = jsonDecode(response.toString());
    }).catchError((e) => print(e));
    return JSONResponse;
  }
}
