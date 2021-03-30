import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/data/repository/auth_repository.dart';
import 'package:flutter_camera/domain/state/auth/auth_state.dart';
import 'package:flutter_camera/domain/state/auth/main_auth_state.dart';
import 'package:flutter_camera/internal/Config.dart';
import 'package:flutter_camera/presentation/DialogLoader.dart';
import 'package:flutter_camera/presentation/DialogMessage.dart';

class Authorization extends StatefulWidget {
  AuthState _authState;

  @override
  _AuthorizationState createState() => _AuthorizationState();

  Authorization({Key key}) : super(key: key) {
    _authState = new MainAuthState(new AuthRepo());
  }
}

class _AuthorizationState extends State<Authorization> {
  final _formKey = GlobalKey<FormState>();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final emptyText = 'Поле не должно быть пустым';
  final GlobalKey _keyLoader = new GlobalKey();

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signIn() async {
    DialogLoader.showLoadingDialog(context, _keyLoader);

    if (_formKey.currentState.validate()) {
      var data = await widget._authState.signIn(
          login: loginController.text, password: passwordController.text);
      print(data);

      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      if (data["token"] != null) {
        Config.sessionID = data["token"];
        Config.fio = data["fio"];
        Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
      } else if (data["error"] != null) {
        DialogMessage.showMyDialog(
            context, "Ошибка сервера", "Ошибка. ${data['error']}", "Повтор");
      } else {
        DialogMessage.showMyDialog(
            context, "Ошибка", "Проверьте интеренет соединение", "Ок");
      }
    } else {
      Timer(Duration(milliseconds: 500), (){
        print(_keyLoader.currentContext);
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      });
    }
  }

  Widget _inputField(bool obs, String hint, Icon icon,
      TextEditingController controller, String Function(String) valid) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
          obscureText: obs,
          controller: controller,
          decoration: InputDecoration(
              hintText: hint,
              prefixIcon: icon,
              border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
              enabledBorder:
                  OutlineInputBorder(borderSide: BorderSide(width: 1)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1))),
          validator: valid,
          // : ,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: Text("Авторизация",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                      fontSize: 25, color: Theme.of(context).primaryColor)),
            ),
            Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    children: [
                      _inputField(false, 'Введите ваш логин', Icon(Icons.mail),
                          loginController, (value) {
                        if (value.isEmpty) {
                          return emptyText;
                        }
                        RegExp regExp = new RegExp(
                          r"^([A-z]+([-_]?[A-z0-9]+){0,2}){4,32}$",
                          caseSensitive: false,
                          multiLine: false,
                        );
                        if (!regExp.hasMatch(value)) {
                          return 'Не корректный логин';
                        }
                        return null;
                      }),
                      _inputField(true, 'Введите ваш пароль',
                          Icon(Icons.vpn_key), passwordController, (value) {
                        if (value.isEmpty) {
                          return emptyText;
                        }
                        RegExp regExp = new RegExp(
                          r"(?=.*[0-9])(?=.*[!@#~$%^&*()+|_])(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#~$%^&*()+|_]{6,}",
                          caseSensitive: false,
                          multiLine: false,
                        );
                        if (!regExp.hasMatch(value)) {
                          return 'Не существующий пароль';
                        }
                        return null;
                      }),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              splashColor: Theme.of(context).primaryColor,
                              child: Text("Войти"),
                              onPressed: signIn,
                            )),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
