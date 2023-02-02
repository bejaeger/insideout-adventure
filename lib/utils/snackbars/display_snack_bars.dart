import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:stacked_services/stacked_services.dart';

class DisplaySnackBars {
  final _snackBarService = locator<SnackbarService>();

  void snackBarCreatedQuest(/* {required dynamic quest} */) {
    _snackBarService.showSnackbar(
      message: "Check out the new quest on the map",
      title: 'New quest created',
      duration: Duration(seconds: 2),
      onTap: (_) {
        print('snackbar tapped');
      },
      //mainButtonTitle: 'Ok',
      onMainButtonTapped: () => print('Undo the action!'),
    );
  }

  void snackBarNotCreatedQuest(/* {required Quest quest} */) {
    _snackBarService.showSnackbar(
      message: "Quest Not Created  ",
      title: 'Could Not Created Quest',
      // duration: Duration(seconds: 10),
      onTap: (_) {
        print('snackbar tapped');
      },
      //mainButtonTitle: 'Ok',
      onMainButtonTapped: () => print('Undo the action!'),
    );
  }

  void snackBarUpdateQuest({required Quest quest}) {
    _snackBarService.showSnackbar(
      title: "Quest Updated ",
      message: "Quest Updated with ${quest.name}",
      // duration: Duration(seconds: 5),
    );
  }

  void showAddedMarkerSnackbar() {
    _snackBarService.showSnackbar(
        title: "Marker Added",
        message: "Marked Added to Database",
        duration: Duration(seconds: 2));
  }

  void showEmptyMarkerSnackbar() {
    _snackBarService.showSnackbar(
      title: "Not Added",
      message: "One of The Fields is Empty",
      duration: Duration(seconds: 2),
    );
  }
}

class DisplayDialogs {}
