// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String Number1ValueKey = 'number1';
const String Number2ValueKey = 'number2';
const String Number3ValueKey = 'number3';
const String Number4ValueKey = 'number4';

final Map<String, TextEditingController> _SetPinViewTextEditingControllers = {};

final Map<String, FocusNode> _SetPinViewFocusNodes = {};

final Map<String, String? Function(String?)?> _SetPinViewTextValidations = {
  Number1ValueKey: null,
  Number2ValueKey: null,
  Number3ValueKey: null,
  Number4ValueKey: null,
};

mixin $SetPinView on StatelessWidget {
  TextEditingController get number1Controller =>
      _getFormTextEditingController(Number1ValueKey);
  TextEditingController get number2Controller =>
      _getFormTextEditingController(Number2ValueKey);
  TextEditingController get number3Controller =>
      _getFormTextEditingController(Number3ValueKey);
  TextEditingController get number4Controller =>
      _getFormTextEditingController(Number4ValueKey);
  FocusNode get number1FocusNode => _getFormFocusNode(Number1ValueKey);
  FocusNode get number2FocusNode => _getFormFocusNode(Number2ValueKey);
  FocusNode get number3FocusNode => _getFormFocusNode(Number3ValueKey);
  FocusNode get number4FocusNode => _getFormFocusNode(Number4ValueKey);

  TextEditingController _getFormTextEditingController(String key,
      {String? initialValue}) {
    if (_SetPinViewTextEditingControllers.containsKey(key)) {
      return _SetPinViewTextEditingControllers[key]!;
    }
    _SetPinViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _SetPinViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_SetPinViewFocusNodes.containsKey(key)) {
      return _SetPinViewFocusNodes[key]!;
    }
    _SetPinViewFocusNodes[key] = FocusNode();
    return _SetPinViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    number1Controller.addListener(() => _updateFormData(model));
    number2Controller.addListener(() => _updateFormData(model));
    number3Controller.addListener(() => _updateFormData(model));
    number4Controller.addListener(() => _updateFormData(model));
  }

  final bool _autoTextFieldValidation = true;
  bool validateFormFields(FormViewModel model) {
    _updateFormData(model, forceValidate: true);
    return model.isFormValid;
  }

  /// Updates the formData on the dynamic
  void _updateFormData(dynamic model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          Number1ValueKey: number1Controller.text,
          Number2ValueKey: number2Controller.text,
          Number3ValueKey: number3Controller.text,
          Number4ValueKey: number4Controller.text,
        }),
    );
    if (_autoTextFieldValidation || forceValidate) {
      _updateValidationData(model);
    }
  }

  /// Updates the fieldsValidationMessages on the dynamic
  void _updateValidationData(dynamic model) => model.setValidationMessages({
        Number1ValueKey: _getValidationMessage(Number1ValueKey),
        Number2ValueKey: _getValidationMessage(Number2ValueKey),
        Number3ValueKey: _getValidationMessage(Number3ValueKey),
        Number4ValueKey: _getValidationMessage(Number4ValueKey),
      });

  /// Returns the validation message for the given key
  String? _getValidationMessage(String key) {
    final validatorForKey = _SetPinViewTextValidations[key];
    if (validatorForKey == null) return null;
    String? validationMessageForKey =
        validatorForKey(_SetPinViewTextEditingControllers[key]!.text);
    return validationMessageForKey;
  }

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    for (var controller in _SetPinViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _SetPinViewFocusNodes.values) {
      focusNode.dispose();
    }

    _SetPinViewTextEditingControllers.clear();
    _SetPinViewFocusNodes.clear();
  }
}

extension ValueProperties on FormViewModel {
  bool get isFormValid =>
      this.fieldsValidationMessages.values.every((element) => element == null);
  String? get number1Value => this.formValueMap[Number1ValueKey] as String?;
  String? get number2Value => this.formValueMap[Number2ValueKey] as String?;
  String? get number3Value => this.formValueMap[Number3ValueKey] as String?;
  String? get number4Value => this.formValueMap[Number4ValueKey] as String?;

  bool get hasNumber1 => this.formValueMap.containsKey(Number1ValueKey);
  bool get hasNumber2 => this.formValueMap.containsKey(Number2ValueKey);
  bool get hasNumber3 => this.formValueMap.containsKey(Number3ValueKey);
  bool get hasNumber4 => this.formValueMap.containsKey(Number4ValueKey);

  bool get hasNumber1ValidationMessage =>
      this.fieldsValidationMessages[Number1ValueKey]?.isNotEmpty ?? false;
  bool get hasNumber2ValidationMessage =>
      this.fieldsValidationMessages[Number2ValueKey]?.isNotEmpty ?? false;
  bool get hasNumber3ValidationMessage =>
      this.fieldsValidationMessages[Number3ValueKey]?.isNotEmpty ?? false;
  bool get hasNumber4ValidationMessage =>
      this.fieldsValidationMessages[Number4ValueKey]?.isNotEmpty ?? false;

  String? get number1ValidationMessage =>
      this.fieldsValidationMessages[Number1ValueKey];
  String? get number2ValidationMessage =>
      this.fieldsValidationMessages[Number2ValueKey];
  String? get number3ValidationMessage =>
      this.fieldsValidationMessages[Number3ValueKey];
  String? get number4ValidationMessage =>
      this.fieldsValidationMessages[Number4ValueKey];
}

extension Methods on FormViewModel {
  setNumber1ValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[Number1ValueKey] = validationMessage;
  setNumber2ValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[Number2ValueKey] = validationMessage;
  setNumber3ValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[Number3ValueKey] = validationMessage;
  setNumber4ValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[Number4ValueKey] = validationMessage;
}
