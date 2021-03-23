import 'package:flutter/cupertino.dart';

abstract class AuthRepository {
  Future<dynamic> signIn({@required String login,
    @required String password});
}
