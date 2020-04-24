import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

class PasswordResetConfirmDialog extends StatelessWidget {
  final String email;
  const PasswordResetConfirmDialog({Key key, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          BasicDialogAlert(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                "Password Reset",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: Text(
                "An email containing information on how to reset your password has been sent to ${email ?? ""}."),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Ok"),
              )
            ],
          ),
        ],
      ),
    );
  }
}
