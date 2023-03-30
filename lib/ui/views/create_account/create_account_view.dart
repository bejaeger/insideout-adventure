import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/ui/layout_widgets/authentication_layout.dart';
import 'package:afkcredits/ui/views/create_account/create_account_view.form.dart';
import 'package:afkcredits/ui/views/create_account/create_account_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

@FormView(fields: [
  FormTextField(name: 'fullName'),
  FormTextField(name: 'email'),
  FormTextField(name: 'password'),
])
class CreateAccountView extends StatelessWidget with $CreateAccountView {
  final UserRole role;
  CreateAccountView({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String roleString = role == UserRole.sponsor ? "Parent" : "Child";
    return ViewModelBuilder<CreateAccountViewModel>.reactive(
      viewModelBuilder: () => CreateAccountViewModel(role: role),
      onModelReady: (model) => listenToFormUpdated(model),
      builder: (context, model, child) => Scaffold(
        body: AuthenticationLayout(
          busy: model.isBusy,
          onMainButtonTapped: model.onSignUpTapped(),
          onBackPressed: model.replaceWithLoginView,
          validationMessage: model.validationMessage,
          title: InsideOutText.headingOne('Create $roleString Account'),
          subtitle: InsideOutText.body(
              'Enter your name, email and password for sign up.'),
          mainButtonTitle: 'SIGN UP',
          form: Column(
            children: [
              verticalSpaceMedium,
              InsideOutInputField(
                leading: Icon(Icons.person),
                controller: fullNameController,
                trailing: Icon(Icons.close),
                trailingTapped: () => fullNameController.clear(),
                placeholder: 'Name',
                errorText: model.fullNameInputValidationMessage,
              ),
              verticalSpaceRegular,
              InsideOutInputField(
                controller: emailController,
                leading: Icon(Icons.email),
                trailing: Icon(Icons.close),
                trailingTapped: () => emailController.clear(),
                placeholder: 'Email',
                errorText: model.emailInputValidationMessage,
              ),
              verticalSpaceRegular,
              InsideOutInputField(
                leading: Icon(Icons.lock),
                controller: passwordController,
                obscureText: true,
                trailing: Icon(Icons.close),
                trailingTapped: () => passwordController.clear(),
                placeholder: "Password",
                errorText: model.passwordInputValidationMessage,
              ),
            ],
          ),
          showTermsText: true,
        ),
      ),
    );
  }
}
