import 'package:image_picker/image_picker.dart';

class ImageSelector {
  Future<XFile?> selectImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }
}
