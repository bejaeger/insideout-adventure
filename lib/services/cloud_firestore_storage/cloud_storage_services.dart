import 'dart:io';
import 'package:afkcredits/utils/cloud_storage_result/cloud_storage_result.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  var url;
  //final _db = Firestore.instance;

  Future<CloudStorageResult?> uploadImage({
    required File? imageToUpload,
    required String title,
  }) async {
    try {
      //final ProformaServices _proformaServices = locator<ProformaServices>();

      //Create File Name and give a Unique timeline.
      var imageFileName =
          title + DateTime.now().millisecondsSinceEpoch.toString();

      //Get a Reference to the File that we want to create.
      final firebaseStorageRef =
          FirebaseStorage.instance.ref().child(imageFileName);

      //upload the file
      final uploadTask = await firebaseStorageRef.putFile(imageToUpload!);

      if (uploadTask != null) {
        var downloadUrl = await uploadTask.ref.getDownloadURL();

        return CloudStorageResult(
            imgUrl: downloadUrl.toString(), imageFileName: imageFileName);
      }

      //Get information on the uploaded file
      //var storageSnapshot =  uploadTask;

/*       if (storageSnapshot != null) {
        var downloadUrl = await uploadTask.ref.getDownloadURL();
        if (uploadTask.isComplete) {
          //Get the URL
          url = downloadUrl.toString();

        
        } */

    }
    //Return Null if it fails
    //return null;
    catch (e) {
      print(e);
    }
    return null;
  }
}
