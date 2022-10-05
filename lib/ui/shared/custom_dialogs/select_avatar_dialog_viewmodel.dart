import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class SelectAvatarViewModel extends BaseModel {
  int get selectedCharacter => _selectedCharacter ?? avatarIdx;
  int? _selectedCharacter;

  void selectCharacter(int selection) {
    _selectedCharacter = selection;
    notifyListeners();
  }
}
