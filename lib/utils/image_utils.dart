import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
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
            child: Text("Camera")),
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
              leading: new Icon(Icons.camera_alt),
              title: new Text(
                "Camera",
              ),
              onTap: () async {
                File path = await _pickImageCamera();
                Navigator.of(context).pop(path);
              }),
          new ListTile(
            leading: new Icon(Icons.insert_photo),
            title: new Text(
              "Gallery",
            ),
            onTap: () async {
              final path = await _pickImageGallery();
              Navigator.of(context).pop(path);
            },
          ),
          if (onRemove != null) ...[
            ListTile(
              leading: new Icon(Icons.remove_circle),
              title: new Text(
                "Remove",
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
    File croppedFile = await _cropImage(path);
    return croppedFile;
  }

  static Future<File> _pickImageGallery() async {
    File path = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    File croppedFile = await _cropImage(path);
    return croppedFile;
  }

  static Future<File> _cropImage(File file) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    return croppedFile;
  }
}
