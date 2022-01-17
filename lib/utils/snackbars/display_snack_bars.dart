import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:stacked_services/stacked_services.dart';

class DisplaySnackBars {
  final _snackBarService = locator<SnackbarService>();

  void snackBarCreatedQuest({required Quest quest}) {
    _snackBarService.showSnackbar(
      message: "Quest Created  $quest",
      title: 'Quest Created Successfully',
      duration: Duration(seconds: 10),
      onTap: (_) {
        print('snackbar tapped');
      },
      mainButtonTitle: 'Ok',
      onMainButtonTapped: () => print('Undo the action!'),
    );
  }

  void snackBarTextBoxEmpty() {
    _snackBarService.showSnackbar(
      message: 'One of the Field Value is Empty',
      title: 'Empty Field',
      duration: Duration(seconds: 5),
      onTap: (_) {
        print('snackbar tapped');
      },
      mainButtonTitle: 'Ok',
      onMainButtonTapped: () => print('Undo the action!'),
    );
  }
}
