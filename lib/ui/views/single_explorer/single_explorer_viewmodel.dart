import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/transfer_type.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/ui/views/common_viewmodels/switch_accounts_viewmodel.dart';

class SingleExplorerViewModel extends SwitchAccountsViewModel {

  final String explorerUid;
  SingleExplorerViewModel({required this.explorerUid}) : super(explorerUid: explorerUid);

  User get explorer => userService.supportedExplorers[explorerUid]!;
  UserStatistics get stats => userService.supportedExplorerStats[explorerUid]!;

  final log = getLogger("SingleExplorerViewModel");


  Future navigateToAddFundsView() async {
    layoutService.setShowBottomNavBar(false);
    await navigationService.navigateTo(Routes.transferFundsView,
        arguments: TransferFundsViewArguments(
            type: TransferType.Sponsor2Explorer,
            senderInfo: PublicUserInfo(
                name: currentUser.fullName, uid: currentUser.uid),
            recipientInfo:
                PublicUserInfo(name: explorer.fullName, uid: explorer.uid)));
    await Future.delayed(Duration(milliseconds: 300));
    layoutService.setShowBottomNavBar(true);
    notifyListeners();
  }


  Future refresh() async {
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
