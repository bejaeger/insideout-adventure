import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:insideout_ui/insideout_ui.dart';

class AuthenticationLayout extends StatelessWidget {
  final Widget? title;
  final Widget? logo;
  final Widget? subtitle;
  final String? mainButtonTitle;
  final Widget? form;
  final String? googleText;
  final void Function()? showTerms;
  final void Function()? onMainButtonTapped;
  final void Function()? onCreateAccountTapped;
  final void Function()? onForgotPassword;
  final void Function()? onBackPressed;
  final void Function()? onDummyLoginWardTapped;
  final void Function()? onDummyLoginGuardianTapped;
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
    this.showTerms,
    this.busy = false,
    this.onGoogleButtonTapped,
    this.onAppleButtonTapped,
    this.releaseName,
    this.onDummyLoginAdminTapped,
    this.onDummyLoginWardTapped,
    this.onDummyLoginGuardianTapped,
    this.googleText,
    this.onDummyLoginSuperUserTapped,
    this.onDummyLoginAdminMasterTapped,
    this.logo,
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
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: onBackPressed,
              ),
            // Text(
            if (title != null) title!,
            if (logo != null) logo!,
            /*  style: textTheme(context).headline4,
            ), */
            verticalSpaceSmall,
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: screenWidth(context, percentage: 0.7),
                child: subtitle!,
              ),
            ),
            verticalSpaceRegular,
            form!,
            verticalSpaceSmall,
            if (onForgotPassword != null)
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: onForgotPassword,
                  child: Container(
                    //color: Colors.red,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Forgot Password?',
                      style: textTheme(context).bodyText2!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: kcBlackHeadlineColor),
                    ),
                  ),
                ),
              ),
            verticalSpaceSmall,
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
                  color: kcPrimaryColor,
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
            if (onDummyLoginWardTapped != null ||
                onDummyLoginGuardianTapped != null)
              verticalSpaceRegular,
            if (onDummyLoginWardTapped != null ||
                onDummyLoginGuardianTapped != null)
              Row(
                children: [
                  if (onDummyLoginGuardianTapped != null)
                    Expanded(
                      child: GestureDetector(
                        onTap: onDummyLoginGuardianTapped,
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kcPrimaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: busy
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : Text(
                                  "LOGIN AS TEST USER",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                        ),
                      ),
                    ),
                  if (onDummyLoginWardTapped != null) horizontalSpaceTiny,
                  if (onDummyLoginWardTapped != null)
                    Expanded(
                      child: GestureDetector(
                        onTap: onDummyLoginWardTapped,
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kcPrimaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: busy
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : Text(
                                  "LOGIN AS TEST CHILD",
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
                            color: kcPrimaryColor,
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
                            color: kcPrimaryColor,
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
                          color: kcPrimaryColor,
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
                        color: kcPrimaryColor,
                        fontSize: 25,
                      ),
                    )
                  ],
                ),
              ),
            if (showTerms != null)
              GestureDetector(
                child: Text(
                  'By signing up you agree to our terms, conditions and privacy policy.',
                  textAlign: TextAlign.center,
                  style: bodyStyleSofia.copyWith(fontSize: 12),
                ),
                onTap: showTerms,
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
            if (releaseName != null && Platform.isAndroid)
              Center(child: Text(releaseName!)),
            verticalSpaceMedium,
          ],
        ),
      ),
    );
  }
}
