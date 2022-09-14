import 'dart:io';

import 'package:afkcredits/services/cloud_storage_service.dart/cloud_storage_result.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:afkcredits/app/app.logger.dart';

class CloudStorageService {
  // ----------------------------
  // services
  final log = getLogger("CloudStorageService");

  // ---------------------------------------
  // Functions
  Future<CloudStorageResult> uploadImage({
    required File imageToUpload,
    required String title,
  }) async {
    var imageFileName =
        title + DateTime.now().millisecondsSinceEpoch.toString();

    // reference of file we want to create
    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(imageFileName);

    // upload faile
    UploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);

    try {
      // get back snapshot
      TaskSnapshot storageSnapshot = await uploadTask
          .whenComplete(() => log.i("Uploaded file with name $imageFileName"));
      var downloadUrl = await storageSnapshot.ref.getDownloadURL();
      var url = downloadUrl.toString();
      return CloudStorageResult(
        imageUrl: url,
        imageFileName: imageFileName,
      );
    } catch (e) {
      log.wtf("Failed to upload image. Error: $e");
      return CloudStorageResult.error(
          errorMessage:
              "Could not upload image due to unknown reason. Please send the following to the developers: $e");
    }
  }

  Future deleteImage(String imageFileName) async {
    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(imageFileName);

    try {
      await firebaseStorageRef.delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}