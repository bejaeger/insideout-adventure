import 'package:afkcredits/ui/views/active_map_quest/active_map_quest_viewmodel.dart';

class GPSAreaHikeViewModel extends ActiveMapQuestViewModel {
  @override
  Future showInstructions() async {
    await dialogService.showDialog(
        title: "How it works", description: "Walk to all areas displayed.");
  }
}
