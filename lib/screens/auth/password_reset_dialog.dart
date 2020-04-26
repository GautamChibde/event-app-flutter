import 'package:eventapp/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

class PasswordResetDialog extends StatefulWidget {
  final Function onSubmit;
  PasswordResetDialog({Key key, this.onSubmit}) : super(key: key);

  @override
  _PasswordResetDialogState createState() =>
      _PasswordResetDialogState(this.onSubmit);
}

class _PasswordResetDialogState extends State<PasswordResetDialog> {
  final _emailResetController = TextEditingController();
  bool _validEmail = false;
  final Function onSubmit;
  bool _loading = false;

  _PasswordResetDialogState(this.onSubmit);

  @override
  Widget build(BuildContext context) {
    return BasicDialogAlert(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: Text(
          "Reset Password",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Password reset link will be sent to your email"),
          SizedBox(height: 8),
          _loading
              ? CircularProgressIndicator()
              : CupertinoTextField(
                  controller: _emailResetController,
                  maxLines: 1,
                  onChanged: (value) {
                    if (Validator.validEmail(value)) {
                      setState(() {
                        _validEmail = true;
                      });
                    } else {
                      setState(() {
                        _validEmail = false;
                      });
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  placeholder: "Enter email",
                )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Reset'),
          textColor: Colors.redAccent,
          onPressed: _validEmail
              ? () {
                  onSubmit(_emailResetController.text);
                  setState(
                    () {
                      this._validEmail = false;
                      this._loading = true;
                    },
                  );
                }
              : null,
        ),
      ],
    );
  }
}
