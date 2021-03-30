import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_camera/domain/repository/photo_repository.dart';
import 'package:flutter_camera/internal/Config.dart';

class Repository extends PhotoRepository {
  @override
  Future<dynamic> uploadPhoto(
      {File photo, double longitude, double latitude}) async {
    final file = photo;
    final String url = Config.url;
    String fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      "object_id": Config.objectID,
      "storage_id": Config.storageID,
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
    await dio
        .post(url + "/api/upload",
            data: data,
            options: Options(
              headers: {
                "Authorization": Config.sessionID,
              },
            ))
        .then((response) {
      JSONResponse = jsonDecode(response.toString());
    }).catchError((e) => print(e));
    return JSONResponse;
  }
}
