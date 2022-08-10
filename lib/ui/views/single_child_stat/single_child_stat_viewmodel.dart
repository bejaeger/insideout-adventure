import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart';
import 'package:afkcredits/enums/transfer_type.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/ui/views/common_viewmodels/switch_accounts_viewmodel.dart';

class SingleChildStatViewModel extends SwitchAccountsViewModel {
  final String explorerUid;
  SingleChildStatViewModel({required this.explorerUid})
      : super(explorerUid: explorerUid);

  // User get explorer => userService.supportedExplorers[explorerUid]!;
  // UserStatistics? get stats => userService.supportedExplorerStats[explorerUid];

  List<dynamic> get sortedHistory =>
      userService.sortedHistory(uid: explorerUid);
  int? get totalChildScreenTimeLastDays =>
      userService.totalChildScreenTimeLastDays(uid: explorerUid)[explorerUid];
  int? get totalChildActivityLastDays =>
      userService.totalChildActivityLastDays(uid: explorerUid)[explorerUid];
  int? get totalChildScreenTimeTrend =>
      userService.totalChildScreenTimeTrend(uid: explorerUid)[explorerUid];
  int? get totalChildActivityTrend =>
      userService.totalChildActivityTrend(uid: explorerUid)[explorerUid];

  String explorerNameFromUid(String uid) {
    return userService.explorerNameFromUid(uid);
  }

  final log = getLogger("SingleExplorerViewModel");

  Future navigateToAddFundsView() async {
    //layoutService.setShowBottomNavBar(false);
    await navigationService.navigateTo(Routes.transferFundsView,
        arguments: TransferFundsViewArguments(
            type: TransferType.Sponsor2ExplorerCredits,
            senderInfo: PublicUserInfo(
                name: currentUser.fullName, uid: currentUser.uid),
            recipientInfo:
                PublicUserInfo(name: explorer.fullName, uid: explorer.uid)));
    await Future.delayed(Duration(milliseconds: 300));
    //layoutService.setShowBottomNavBar(true);
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
