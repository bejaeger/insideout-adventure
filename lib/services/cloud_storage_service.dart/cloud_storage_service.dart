import 'dart:io';

import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/services/cloud_storage_service.dart/cloud_storage_result.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:afkcredits/app/app.logger.dart';

class CloudStorageService {
  // ----------------------------
  // services
  final log = getLogger("CloudStorageService");
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();

  // map of quest to list of screenshots
  Map<QuestType, List<dynamic>> exampleScreenShots = {};
  Set<Reference> exampleScreenShotsRef = {};

  // map of quest to list of screenshots
  List<dynamic> pictures =[];
  Set<Reference> picturesRef = {};

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

  Future loadExampleScreenshots({required QuestType questType}) async {
    try {
      final screenshotNames = await _firestoreApi.getListOfScreenShotNames(
          questType: questType.toSimpleString());
      log.e("FOUND screenshot names: $screenshotNames");
      if (screenshotNames != null) {
        for (String url in screenshotNames) {
          try {
            Reference ref = FirebaseStorage.instance.refFromURL(url);
            if (exampleScreenShotsRef.contains(ref)) {
              continue;
            }
            exampleScreenShotsRef.add(ref);

            final data = await ref.getData();
            if (!exampleScreenShots.containsKey(questType)) {
              exampleScreenShots[questType] = [data];
            } else {
              exampleScreenShots[questType]!.add(data);
            }
          } catch (e) {
            log.e("Could not load image. Error: $e");
            exampleScreenShots[questType] = [];
          }
        }
      }
    } catch (e) {
      log.e("Could not load screen shot urls. Error: $e");
      exampleScreenShots[questType] = [];
    }
  }

  Future loadPictures({required List<String>urls}) async {
    try {
        for (String url in urls) {
          try {
            Reference ref = FirebaseStorage.instance.refFromURL(url);
            if (picturesRef.contains(ref)) {
              continue;
            }
            picturesRef.add(ref);

            final data = await ref.getData();
            if (!pictures.contains(data)) {
              pictures.add(data);
            } 
          } catch (e) {
            log.e("Could not load image. Error: $e");
          }
      }
    } catch (e) {
      log.e("Could not load screen shot urls. Error: $e");
    }
  }
}
