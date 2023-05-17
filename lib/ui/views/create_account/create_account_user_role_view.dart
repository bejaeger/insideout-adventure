import 'package:afkcredits/ui/layout_widgets/select_user_role_layout.dart';
import 'package:afkcredits/ui/views/create_account/create_account_user_role_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CreateAccountUserRoleView extends StatelessWidget {
  const CreateAccountUserRoleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SelectUserRoleViewModel>.reactive(
      viewModelBuilder: () => SelectUserRoleViewModel(),
      builder: (context, model, child) => SelectUserRoleLayout(
        //In Future I only see one Navigation Function with different Roles Parameters. Same UserTapToLogin
        onBackPressed: model.navigateToLoginView,
        onExplorerPressed: model.showNotImplementedSnackbar,
        onGuardianPressed: model.navigateToGuardianCreateAccount,
        // onAdminMasterPressed: model.navigateToAdminCreateAccount,
      ),
    );
  }
}
