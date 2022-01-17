import 'dart:io';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_category/gift_card_category.dart';
import 'package:afkcredits/services/cloud_firestore_storage/cloud_storage_services.dart';
import 'package:afkcredits/services/giftcard/gift_card_service.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/utils/cloud_storage_result/cloud_storage_result.dart';
import 'package:afkcredits/utils/image_selector/image_selector.dart';
import 'package:stacked/stacked.dart';

class AddGiftCardsViewModel extends FormViewModel with NavigationMixin {
  final ImageSelector _imageSelector = locator<ImageSelector>();
  CloudStorageResult _storageResult = locator<CloudStorageResult>();
  CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  final _giftCardService = locator<GiftCardService>();

  File? selectedImage;

  //File get selectedImage => _selectedImage!;

  //Display The Image In UI when Selected
  Future selectImage(String photo) async {
    var tempImage = await _imageSelector.selectImage(photo);
    if (tempImage != null) {
      //Show The Image Inside UI when Selected.
      selectedImage = tempImage;
      notifyListeners();
    }
  }

  void cleanImage() {
    setBusy(true);
    //Show The Image Inside UI when Selected.
    selectedImage = null;
    notifyListeners();
    setBusy(false);
  }

  //Upload Image to Firebase.
  Future<void> saveImage({required String title}) async {
    _storageResult = (await _cloudStorageService.uploadImage(
      imageToUpload: selectedImage!,
      title: title,
    ))!;
  }

  //Upload Image to Firebase.
  Future<bool>? addGiftCard(
      {required GiftCardCategory giftCardCategory}) async {
    await _giftCardService.addGiftCardCategory(
        giftCardCategory: giftCardCategory);
    return true;
  }

  @override
  void setFormStatus() {}
}
