import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/datamodels/users/user_statistics.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class SingleExplorerViewModel extends BaseModel {
  User? get user => userService.supportedExplorers[uid];
  UserStatistics? get stats => userService.supportedExplorerStats[uid];
  final String uid;

  SingleExplorerViewModel({required this.uid});

  void navigateToAddFundsView() {
    //navigationService.navigateTo(Routes.addFundsView);
  }

  Future refresh() async {
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
