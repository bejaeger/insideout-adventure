import 'package:afkcredits/app/app.locator.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

void setupSnackbarUi() {
  final service = locator<SnackbarService>();

  // Registers a config to be used when calling showSnackbar
  service.registerSnackbarConfig(
    SnackbarConfig(
      backgroundColor: kcPrimaryColor,
      textColor: Colors.white,
      titleColor: Colors.white,
      messageColor: Colors.white,
      mainButtonTextColor: Colors.white,
      titleTextAlign: TextAlign.center,
      messageTextAlign: TextAlign.center,
    ),
  );
}
