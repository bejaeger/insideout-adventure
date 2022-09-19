import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/ui/layout_widgets/authentication_layout.dart';
import 'package:afkcredits/ui/widgets/hercules_world_logo.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
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
            onDummyLoginAdminTapped:
                model.userLoginTapped(userRole: UserRole.admin),
            onDummyLoginSuperUserTapped:
                model.userLoginTapped(userRole: UserRole.superUser),
            onDummyLoginAdminMasterTapped:
                model.userLoginTapped(userRole: UserRole.adminMaster),
            //model.saveAdminData,
            onMainButtonTapped: model.userLoginTapped(),
            validationMessage: model.validationMessage,
            // title: AfkCreditsText.headingOne(
            //   'Welcome to',
            //   align: TextAlign.left,
            // ),
            logo: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HerculesWorldLogo(),
              ],
            ),
            subtitle: Row(
              children: [
                horizontalSpaceTiny,
                Expanded(
                  child: AfkCreditsText.body(
                      'Creating a healthy balance between activity and screen time'),
                ),
              ],
            ),
            mainButtonTitle: 'SIGN IN',
            form: Column(
              children: [
                verticalSpaceMedium,
                AfkCreditsInputField(
                  controller: emailOrNameController,
                  // leading: Icon(Icons.email),
                  placeholder: "Email or name",
                  trailing: Icon(Icons.close),
                  trailingTapped: () => emailOrNameController.clear(),
                  errorText: model.emailOrNameInputValidationMessage,
                  //leading: Text('Email'),
                ),
                verticalSpaceRegular,
                /*        TextField(
                decoration:
                    InputDecoration(labelText: 'Email or explorer name'),
                controller: emailOrNameController,
              ), */
                AfkCreditsInputField(
                  //leading: Icon(Icons.lock),
                  controller: passwordController,
                  placeholder: "Password",
                  //leading: Text('Password'),
                  obscureText: true,
                  trailing: Icon(Icons.close),
                  trailingTapped: () => passwordController.clear(),
                  errorText: model.passwordInputValidationMessage,
                ),
                /*         TextField(
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
              ), */
                // with custom text
              ],
            ),
            releaseName: model.getReleaseName,
            onForgotPassword: model.showNotImplementedSnackbar,
            onGoogleButtonTapped: null
            // () =>
            //     model.saveData(AuthenticationMethod.google),
            // onFacebookButtonTapped: () =>
            //     model.runAuthentication(AuthenticationMethod.facebook),
            // onAppleButtonTapped: () =>
            //     model.runAuthentication(AuthenticationMethod.apple),
            ),
      ),
    );
  }
}
