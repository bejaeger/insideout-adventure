import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/switch_accounts_viewmodel.dart';

class DrawerWidgetViewModel extends SwitchAccountsViewModel {
  Future navigateToGiftCardsView() async {
    await navigationService.navigateTo(Routes.purchasedGiftCardsView);
  }
}