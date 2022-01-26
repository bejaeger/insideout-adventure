import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:stacked/stacked.dart';

class ManageQuestViewModel extends BaseViewModel with NavigationMixin {
  final logger = getLogger('ManageQuestViewModel');

/*   navToCreateQuest() {
    logger.wtf('I did not click yet WTF is going on ');
    // navToQuestOverView();
  } */

  void NavigateToQuestViews({required int index}) {
    switch (index) {
      case 0:
        logger.i('User is Navigating to $navToCreateQuest');
        navToCreateQuest();
        break;
      case 1:
        logger.i('User is Navigating to $navToQuestOverView');
        //navToQuestOverView();
        break;
      case 2:
        logger.i('User is Navigating to $navToQuestOverView');
        // navToQuestOverView();
        break;
      default:
        logger.i('User is Navigating to $navToCreateQuest');

        navToCreateQuest();
        break;
    }
  }
}
