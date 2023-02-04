import 'package:afkcredits/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class DisplaySnackBars {
  final _snackBarService = locator<SnackbarService>();

  void snackBarCreatedQuest(/* {required dynamic quest} */) {
    _snackBarService.showSnackbar(
      message: "Check out the new quest on the map",
      title: 'New quest created',
      duration: Duration(seconds: 2),
    );
  }

  void snackBarNotCreatedQuest(/* {required Quest quest} */) {
    _snackBarService.showSnackbar(
      message: "Quest Not Created  ",
      title: 'Could Not Created Quest',
    );
  }
}
