import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/ui/layout_widgets/select_user_role_layout.dart';
import 'package:afkcredits/ui/views/login/select_role_after_login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

// ----------------------------------------------------
// ! THIS class is called
// ! when the user logs in with a third party provider!

class SelectRoleAfterLoginView extends StatelessWidget {
  final AuthenticationMethod authMethod;
  const SelectRoleAfterLoginView({Key? key, required this.authMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SelectRoleAfterLoginViewModel>.reactive(
      viewModelBuilder: () =>
          SelectRoleAfterLoginViewModel(authMethod: authMethod),
      builder: (context, model, child) => SelectUserRoleLayout(
        onBackPressed: model.navigateToLoginView,
        onExplorerPressed: model.showNotImplementedSnackbar,
        onSponsorPressed: () =>
            model.createAccountAndNavigateToHome(role: UserRole.sponsor),
        isBusy: model.isBusy,
      ),
    );
  }
}
