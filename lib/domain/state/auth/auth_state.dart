import 'package:flutter_camera/data/repository/auth_repository.dart';

abstract class AuthState {
  AuthState(AuthRepo authRepository) {
    _authRepository = authRepository;
  }

  AuthRepo _authRepository;

  Future<dynamic> signIn(
      {String login, String password}) async {
    final data = await _authRepository.signIn(login: login, password: password);
    return data;
  }
}
