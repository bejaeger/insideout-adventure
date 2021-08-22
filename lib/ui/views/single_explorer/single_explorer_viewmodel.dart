import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/users/public_user_info.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/datamodels/users/user_statistics.dart';
import 'package:afkcredits/enums/transfer_type.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class SingleExplorerViewModel extends BaseModel {
  User get user => userService.supportedExplorers[uid]!;
  UserStatistics get stats => userService.supportedExplorerStats[uid]!;
  final String uid;

  SingleExplorerViewModel({required this.uid});

  void navigateToAddFundsView() {
    navigationService.navigateTo(Routes.transferFundsView,
        arguments: TransferFundsViewArguments(
            type: TransferType.Sponsor2Explorer,
            senderInfo: PublicUserInfo(
                name: currentUser.fullName, uid: currentUser.uid),
            recipientInfo: PublicUserInfo(name: user.fullName, uid: user.uid)));
  }

  Future refresh() async {
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
