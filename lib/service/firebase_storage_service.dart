import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageService {
  static final FirebaseStorageService instance = FirebaseStorageService();

  Future<String> uploadImage(File file) async {
    final String fileName =
        "profile_${DateTime.now().millisecondsSinceEpoch}_${Uuid().v4()}" +
            '.jpg';

    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask uploadTask = storageRef.putFile(
      file,
    );
    await uploadTask.onComplete;
    return await storageRef.getDownloadURL();
  }

  Future<void> deleteImage(String imageUrl) async {
    final ref =  await FirebaseStorage.instance.getReferenceFromUrl(imageUrl);
    await ref.delete();
  }
}
