import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/ui/layout_widgets/authentication_layout.dart';
import 'package:afkcredits/ui/views/create_account/create_account_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:afkcredits/ui/views/create_account/create_account_view.form.dart';
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
    String roleString = role == UserRole.sponsor ? "Sponsor" : "Explorer";
    return ViewModelBuilder<CreateAccountViewModel>.reactive(
      viewModelBuilder: () => CreateAccountViewModel(role: role),
      onModelReady: (model) => listenToFormUpdated(model),
      builder: (context, model, child) => Scaffold(
          body: AuthenticationLayout(
        busy: model.isBusy,
        onMainButtonTapped: () => model.saveData(AuthenticationMethod.email),
        onBackPressed: model.replaceWithSelectRoleView,
        validationMessage: model.validationMessage,
        title: 'Create $roleString Account',
        subtitle: 'Enter your name, email and password for sign up.',
        mainButtonTitle: 'SIGN UP',
        form: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Full Name'),
              controller: fullNameController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              controller: emailController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              controller: passwordController,
            ),
          ],
        ),
        showTermsText: true,
      )),
    );
  }
}
