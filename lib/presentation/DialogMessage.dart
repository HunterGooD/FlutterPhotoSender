import 'package:flutter/material.dart';

class DialogMessage {
  static Future<void> showMyDialog(BuildContext context, String title, message,
      buttonText, {String link}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(title),
                Text(message),
                link != null ?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(link),
                    SelectableText(link)
                  ],
                ): Text(""),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(buttonText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
