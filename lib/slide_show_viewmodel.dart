import 'dart:async';

import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/main_dev.dart';
import 'package:afkcredits/services/cloud_storage_service.dart/cloud_storage_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class SlideShowViewModel extends BaseModel {
  final CloudStorageService cloudStorageService =
      locator<CloudStorageService>();
  final FirestoreApi firestoreApi = locator<FirestoreApi>();

  List<dynamic> get pictures =>
      cloudStorageService.pictures;

  List<String> urls = [];

  // --------------------------------------------
  // functions
  Future handleAddPicture(BuildContext context) async {
    print("handleAddPicture");

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(
          // Pass the automatically generated path to
          // the DisplayPictureScreen widget.
          camera: firstCamera,
        ),
      ),
    );

    // result = await cloudStorageService.uploadImage(
    //       imageToUpload: selectedImage!, title: "");
  }

  Future getPictures() async {
    firestoreApi.getPicturesStream().listen(
      (image) async {
        urls = image.imageUrls;
        await cloudStorageService.loadPictures(urls: urls);
        notifyListeners();
      },
    );
    notifyListeners();    
  }
}
