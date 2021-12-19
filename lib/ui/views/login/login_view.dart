import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/ui/layout_widgets/authentication_layout.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import './login_viewmodel.dart';
import 'package:afkcredits/ui/views/login/login_view.form.dart';

@FormView(fields: [
  FormTextField(name: 'emailOrName'),
  FormTextField(name: 'password'),
])
class LoginView extends StatelessWidget with $LoginView {
  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      onModelReady: (model) => listenToFormUpdated(model),
      builder: (context, model, child) => Scaffold(
        body: AuthenticationLayout(
          busy: model.isBusy,
          onCreateAccountTapped: model.navigateToCreateAccount,
          onDummyLoginExplorerTapped:
              model.userLoginTapped(userRole: UserRole.explorer),
          onDummyLoginSponsorTapped:
              model.userLoginTapped(userRole: UserRole.sponsor),
          onDummyLoginAdminTapped: model.saveAdminData,
          onMainButtonTapped: () => model
              .saveData(AuthenticationMethod.EmailOrSponsorCreatedExplorer),
          validationMessage: model.validationMessage,
          title: 'Welcome to AFK Credits',
          subtitle: 'real-world quests, in-game rewards',
          mainButtonTitle: 'SIGN IN',
          form: Column(
            children: [
              TextField(
                decoration:
                    InputDecoration(labelText: 'Email or explorer name'),
                controller: emailOrNameController,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      model.setIsPwShown(!model.isPwShown);
                    },
                    icon: (model.isPwShown)
                        ? Icon(Icons.visibility, color: kPrimaryColor)
                        : Icon(Icons.visibility_off, color: kPrimaryColor),
                  ),
                ),
                obscureText: (model.isPwShown) ? false : true,
                controller: passwordController,
              ),
              // with custom text
            ],
          ),
          releaseName: model.getReleaseName,
          onForgotPassword: () {},
          onGoogleButtonTapped: () =>
              model.saveData(AuthenticationMethod.google),
          // onFacebookButtonTapped: () =>
          //     model.runAuthentication(AuthenticationMethod.facebook),
          // onAppleButtonTapped: () =>
          //     model.runAuthentication(AuthenticationMethod.apple),
        ),
      ),
    );
  }
}
