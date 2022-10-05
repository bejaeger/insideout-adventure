import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class SelectAvatarViewModel extends BaseModel {
  int selectedCharacter = 1;

  void selectCharacter(int selection) {
    selectedCharacter = selection;
    notifyListeners();
  }
}
