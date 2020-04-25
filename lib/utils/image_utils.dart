import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  static Future<File> pickImage(context, {Function onRemove}) {
    return Platform.isIOS
        ? showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => _bodyIOS(
              context,
              onRemove,
            ),
          )
        : showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => _bodyMD(
              context,
              onRemove,
            ),
          );
  }

  static CupertinoActionSheet _bodyIOS(context, Function onRemove) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
            onPressed: () async {
              File path = await _pickImageCamera();
              Navigator.of(context).pop(path);
            },
            child: Text("Camers")),
        CupertinoActionSheetAction(
            onPressed: () async {
              File path = await _pickImageGallery();
              Navigator.of(context).pop(path);
            },
            child: Text("Gallery")),
        if (onRemove != null) ...[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              onRemove();
              Navigator.pop(context);
            },
            child: Text("Remove"),
            // isDestructiveAction: true,
          ),
        ]
      ],
    );
  }

  static _bodyMD(context, Function onRemove) {
    return Container(
      child: new Wrap(
        children: <Widget>[
          new ListTile(
              leading: new Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
              title: new Text(
                "Camera",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                File path = await _pickImageCamera();
                Navigator.of(context).pop(path);
              }),
          new ListTile(
            leading: new Icon(Icons.insert_photo, color: Colors.white),
            title: new Text(
              "Gallery",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              final path = await _pickImageGallery();
              Navigator.of(context).pop(path);
            },
          ),
          if (onRemove != null) ...[
            ListTile(
              leading: new Icon(
                Icons.remove_circle,
                color: Colors.white,
              ),
              title: new Text(
                "Remove",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                onRemove();
                Navigator.of(context).pop();
              },
            )
          ],
        ],
      ),
    );
  }

  static Future<File> _pickImageCamera() async {
    File path = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    return path;
  }

  static Future<File> _pickImageGallery() async {
    File path = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    return path;
  }
}
