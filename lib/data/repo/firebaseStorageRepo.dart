
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';

class FirebaseStorageRepo {
   static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  static Future<String> uploadFile({required String path,required String category}) async {
    try {
      File file = File(path);
      String uid = AuthRepo.getCurrentUserId()!;
      final ref = _firebaseStorage.ref().child("$uid/$category/${path.split("/").last}");
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw e;
    }
  }
}