import 'dart:developer' show log;
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/providers/firebase_providers.dart';

final storageRepoProvider = Provider<StorageRepository>((ref) {
  return StorageRepository(
    ref.watch(firebaseStorageProvider),
  );
});

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository(FirebaseStorage firebaseStorage)
      : _firebaseStorage = firebaseStorage;

  Future<String> storeFile({
    required String path,
    required String id,
    required File? file,
    required Uint8List? webFile,
  }) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      UploadTask uploadTask;

      if (kIsWeb) {
        uploadTask = ref.putData(webFile!);
        final taskSnapshot = await uploadTask;
        final res = await taskSnapshot.ref.getDownloadURL();
        return res;
      } else {
        uploadTask = ref.putFile(file!);
        final TaskSnapshot taskSnapshot = await uploadTask;
        final res = await taskSnapshot.ref.getDownloadURL();
        return res;
      }
    } on FirebaseException catch (e) {
      log(e.code);
      return e.message.toString();
    }
  }
}
