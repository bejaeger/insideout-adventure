import 'package:afkcredits/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:afkcredits/utils/ui_helpers.dart';

class AuthenticationLayout extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? mainButtonTitle;
  final Widget? form;
  final String? googleText;
  final bool showTermsText;
  final void Function()? onMainButtonTapped;
  final void Function()? onCreateAccountTapped;
  final void Function()? onForgotPassword;
  final void Function()? onBackPressed;
  final void Function()? onDummyLoginExplorerTapped;
  final void Function()? onDummyLoginSponsorTapped;
  final void Function()? onDummyLoginAdminTapped;
  final void Function()? onDummyLoginSuperUserTapped;
  final void Function()? onDummyLoginAdminMasterTapped;

  final void Function()? onGoogleButtonTapped;
  final void Function()? onAppleButtonTapped;
  final String? validationMessage;
  final String? releaseName;
  final bool busy;

  const AuthenticationLayout({
    Key? key,
    this.title,
    this.subtitle,
    this.mainButtonTitle,
    this.form,
    this.onMainButtonTapped,
    this.onCreateAccountTapped,
    this.onForgotPassword,
    this.onBackPressed,
    this.validationMessage,
    this.showTermsText = false,
    this.busy = false,
    this.onGoogleButtonTapped,
    this.onAppleButtonTapped,
    this.releaseName,
    this.onDummyLoginAdminTapped,
    this.onDummyLoginExplorerTapped,
    this.onDummyLoginSponsorTapped,
    this.googleText,
    this.onDummyLoginSuperUserTapped,
    this.onDummyLoginAdminMasterTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            if (onBackPressed == null) verticalSpaceLarge,
            if (onBackPressed != null) verticalSpaceRegular,
            if (onBackPressed != null)
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: onBackPressed,
              ),
            Text(
              title!,
              style: textTheme(context).headline4,
            ),
            verticalSpaceSmall,
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: screenWidth(context, percentage: 0.7),
                child: Text(
                  subtitle!,
                ),
              ),
            ),
            verticalSpaceRegular,
            form!,
            verticalSpaceRegular,
            if (onForgotPassword != null)
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: onForgotPassword,
                  child: Text(
                    'Forget Password?',
                    style: textTheme(context).bodyText2!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            verticalSpaceRegular,
            if (validationMessage != null)
              Text(
                validationMessage!,
                style: TextStyle(
                  color: Colors.red,
                  //fontSize: kBodyTextSize,
                ),
              ),
            if (validationMessage != null) verticalSpaceRegular,
            GestureDetector(
              onTap: onMainButtonTapped,
              child: Container(
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: busy
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : Text(
                        mainButtonTitle!,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
              ),
            ),
            if (onDummyLoginExplorerTapped != null ||
                onDummyLoginSponsorTapped != null)
              verticalSpaceRegular,
            if (onDummyLoginExplorerTapped != null ||
                onDummyLoginSponsorTapped != null)
              Row(
                children: [
                  if (onDummyLoginSponsorTapped != null)
                    Expanded(
                      child: GestureDetector(
                        onTap: onDummyLoginSponsorTapped,
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: busy
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : Text(
                                  "LOGIN AS TEST SPONSOR",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                        ),
                      ),
                    ),
                  if (onDummyLoginExplorerTapped != null) horizontalSpaceTiny,
                  if (onDummyLoginExplorerTapped != null)
                    Expanded(
                      child: GestureDetector(
                        onTap: onDummyLoginExplorerTapped,
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: busy
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : Text(
                                  "LOGIN AS TEST EXPLORER",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                        ),
                      ),
                    ),
                ],
              ),
            if (onDummyLoginAdminTapped != null ||
                onDummyLoginSuperUserTapped != null)
              verticalSpaceSmall,
            if (onDummyLoginAdminTapped != null ||
                onDummyLoginSuperUserTapped != null)
              Row(
                children: [
                  if (onDummyLoginAdminTapped != null)
                    Expanded(
                      child: GestureDetector(
                        onTap: onDummyLoginAdminTapped,
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: busy
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : Text(
                                  "LOGIN AS ADMIN",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                        ),
                      ),
                    ),
                  if (onDummyLoginSuperUserTapped != null) horizontalSpaceTiny,
                  if (onDummyLoginSuperUserTapped != null)
                    Expanded(
                      child: GestureDetector(
                        onTap: onDummyLoginSuperUserTapped,
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: busy
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : Text(
                                  "LOGIN AS SUPER USER",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                        ),
                      ),
                    ),
                ],
              ),
            if (onDummyLoginAdminMasterTapped != null) verticalSpaceSmall,
            if (onDummyLoginAdminMasterTapped != null)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onDummyLoginAdminMasterTapped,
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: busy
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : Text(
                                "LOGIN AS MASTER ADMIN",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            verticalSpaceMedium,
            if (onCreateAccountTapped != null)
              GestureDetector(
                onTap: onCreateAccountTapped,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?'),
                    horizontalSpaceTiny,
                    Text(
                      'Create an account',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 25,
                      ),
                    )
                  ],
                ),
              ),
            if (showTermsText)
              Text(
                'By signing up you agree to our terms, conditions and privacy policy.',
                textAlign: TextAlign.center,
              ),
            if (onGoogleButtonTapped != null || onAppleButtonTapped != null)
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Center(
                  child: Text("OR"),
                ),
              ),
            if (onGoogleButtonTapped != null)
              SignInButton(
                Buttons.Google,
                text: googleText ?? "SIGN IN WITH GOOGLE",
                onPressed: onGoogleButtonTapped!,
              ),
            if (onAppleButtonTapped != null)
              SignInButton(
                Buttons.Apple,
                text: "SIGN IN WITH APPLE",
                onPressed: onAppleButtonTapped!,
              ),
            verticalSpaceLarge,
            if (releaseName != null)
              Center(child: Text("Release - " + releaseName!)),
          ],
        ),
      ),
    );
  }
}
