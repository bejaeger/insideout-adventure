import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:insideout_ui/insideout_ui.dart';

class GoogleMapLayout extends StatelessWidget {
  final bool? googleMapLayout;
  final bool? zoomControlsEnabled;
  final String? mainButtonTitle;
  final Widget? map;
  final String? googleText;
  final bool showTermsText;
  final void Function()? onMainButtonTapped;
  final void Function()? onCreateAccountTapped;
  final void Function()? onForgotPassword;
  final void Function()? onBackPressed;
  final void Function()? onDummyLoginWardTapped;
  final void Function()? onDummyLoginAdminTapped;
  final void Function()? onDummyLoginGuardianTapped;
  final void Function()? onGoogleButtonTapped;
  final void Function()? onAppleButtonTapped;
  final String? validationMessage;
  final String? releaseName;
  final bool busy;

  const GoogleMapLayout({
    Key? key,
    this.googleMapLayout,
    this.zoomControlsEnabled,
    this.mainButtonTitle,
    this.map,
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
    this.onDummyLoginWardTapped,
    this.onDummyLoginAdminTapped,
    this.onDummyLoginGuardianTapped,
    this.googleText,
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
            verticalSpaceRegular,
            map!,
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
                    )),
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
                                  "LOGIN AS TEST PARENT",
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
            if (onDummyLoginAdminTapped != null) verticalSpaceRegular,
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
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : Text(
                            "LOGIN AS TEST ADMIN",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                  ),
                ),
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
