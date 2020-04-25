import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as img;

class FirebaseStorageService {
  static final FirebaseStorageService instance = FirebaseStorageService();

  Future<String> uploadImage(File file) async {
    final String fileName =
        "profile_${DateTime.now().millisecondsSinceEpoch}_${Uuid().v4()}" +
            '.jpg';

    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child(fileName);
    img.Image imageTemp = img.decodeImage(file.readAsBytesSync());
    img.Image resizedImg = img.copyResize(imageTemp, width: 800);
    await file.writeAsBytes(img.encodeJpg(resizedImg, quality: 85));
    final StorageUploadTask uploadTask = storageRef.putFile(
      file,
    );
    await uploadTask.onComplete;
    return await storageRef.getDownloadURL();
  }

  Future<void> deleteImage(String imageUrl) async {
    final ref = await FirebaseStorage.instance.getReferenceFromUrl(imageUrl);
    await ref.delete();
  }
}
