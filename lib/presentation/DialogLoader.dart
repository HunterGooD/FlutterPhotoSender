import 'package:flutter/material.dart';

class DialogLoader {
  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key,
      {String text}) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: [
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          text == null ? "Ожидание...." : text,
                          style: TextStyle(color: Colors.red),
                        )
                      ]),
                    )
                  ]));
        });
  }
}
