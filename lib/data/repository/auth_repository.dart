import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_camera/domain/repository/auth_repository.dart';
import 'package:flutter_camera/internal/Config.dart';

class AuthRepo extends AuthRepository {
  @override
  Future<dynamic> signIn({String login, String password}) async {
    final String url = Config.url;

    Dio dio = new Dio();
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;

    dynamic JSONResponse;
    print(" Login : ${login} : Password ${password}");
    await dio.post(url + "/api/signin",
        data: {"login": login, "password": password}).then((response) {
      JSONResponse = jsonDecode(response.toString());
    }).catchError((e) => print(e));
    return JSONResponse;
  }
}
