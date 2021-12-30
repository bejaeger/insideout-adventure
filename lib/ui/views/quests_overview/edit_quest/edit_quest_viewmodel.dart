import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:stacked/stacked.dart';

class EditQuestViewModel extends BaseViewModel {
  Quest? quest;
  EditQuestViewModel({required this.quest});
  final log = getLogger('EditQuestViewModel');

  void navigateToAcceptPaymentsView() {
    log.i(
        "Clicked navigating to accept payments view (not yet implemented!): ${quest!.markerNotes.toString()}");
  }
}
