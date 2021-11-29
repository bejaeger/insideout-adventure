// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String Number1ValueKey = 'number1';
const String Number2ValueKey = 'number2';
const String Number3ValueKey = 'number3';
const String Number4ValueKey = 'number4';

mixin $SetPinView on StatelessWidget {
  final TextEditingController number1Controller = TextEditingController();
  final TextEditingController number2Controller = TextEditingController();
  final TextEditingController number3Controller = TextEditingController();
  final TextEditingController number4Controller = TextEditingController();
  final FocusNode number1FocusNode = FocusNode();
  final FocusNode number2FocusNode = FocusNode();
  final FocusNode number3FocusNode = FocusNode();
  final FocusNode number4FocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    number1Controller.addListener(() => _updateFormData(model));
    number2Controller.addListener(() => _updateFormData(model));
    number3Controller.addListener(() => _updateFormData(model));
    number4Controller.addListener(() => _updateFormData(model));
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData(
        model.formValueMap
          ..addAll({
            Number1ValueKey: number1Controller.text,
            Number2ValueKey: number2Controller.text,
            Number3ValueKey: number3Controller.text,
            Number4ValueKey: number4Controller.text,
          }),
      );

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    number1Controller.dispose();
    number1FocusNode.dispose();
    number2Controller.dispose();
    number2FocusNode.dispose();
    number3Controller.dispose();
    number3FocusNode.dispose();
    number4Controller.dispose();
    number4FocusNode.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String? get number1Value => this.formValueMap[Number1ValueKey];
  String? get number2Value => this.formValueMap[Number2ValueKey];
  String? get number3Value => this.formValueMap[Number3ValueKey];
  String? get number4Value => this.formValueMap[Number4ValueKey];

  bool get hasNumber1 => this.formValueMap.containsKey(Number1ValueKey);
  bool get hasNumber2 => this.formValueMap.containsKey(Number2ValueKey);
  bool get hasNumber3 => this.formValueMap.containsKey(Number3ValueKey);
  bool get hasNumber4 => this.formValueMap.containsKey(Number4ValueKey);
}

extension Methods on FormViewModel {}
