import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/layout/layout_service.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/ui/views/common_viewmodels/transfer_base_viewmodel.dart';

class LayoutTemplateViewModel extends TransferBaseViewModel {
  final LayoutService layoutService = locator<LayoutService>();
  bool get showBottomNavBar => layoutService.showBottomNavBar;
  void listenToLayoutSettings() {
    layoutService.showBottomNavBarSubject.listen((value) {
      notifyListeners();
    });
  }

  final log = getLogger("LayoutTemplateViewModel");
  void replaceToHomeView() {
    if (currentUser.role == UserRole.explorer) {
      log.v(
          'We found an explorer account, let\'s navigate to the home screen.');
      navigationService.replaceWith(Routes.explorerHomeView);
      setShowBottomNavBar(true);
    } else if (currentUser.role == UserRole.sponsor) {
      log.v(
          'We have a sponsor account. Let\'s navigate to the sponsor home screen!');
      //navigationService.replaceWith(Routes.sponsorHomeView);
      navigationService.replaceWith(Routes.sponsorHomeView);
      setShowBottomNavBar(true);
      // navigate to home view
    } else if (currentUser.role == UserRole.admin) {
      log.v('We have an admin account. We will go to the admin home view!');
      navigationService.replaceWith(Routes.adminHomeView);
      setShowBottomNavBar(true);
      // navigate to home view
    }
  }
}
