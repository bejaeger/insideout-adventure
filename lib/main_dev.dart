import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/main_common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options_dev.dart' as dev;

void main() async {
  mainCommon(Flavor.dev);
}
