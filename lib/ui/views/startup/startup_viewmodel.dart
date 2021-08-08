import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

class StartUpViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();

  void navigateToSponsorHomeView() {
    _navigationService.navigateTo(Routes.sponsorHomeView);
  }

  void navigateToExplorerHomeView() {
    _navigationService.navigateTo(Routes.explorerHomeView);
  }
}
