import 'package:image_picker/image_picker.dart';

class ImageSelector {
  final ImagePicker _picker = ImagePicker();
  selectImage(String photo) async {
    //Get the Image with the Preset of Height and Width
    // _picker.pickImage(source: source)
    if (photo == 'camera') {
      return await _picker.pickImage(
          source: ImageSource.camera, maxHeight: 150, maxWidth: 180);
    } else
      return await _picker.pickImage(
          source: ImageSource.gallery, maxHeight: 150, maxWidth: 180);
  }
}
