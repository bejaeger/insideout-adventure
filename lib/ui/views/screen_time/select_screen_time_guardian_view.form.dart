// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String AmountValueKey = 'amount';

final Map<String, TextEditingController>
    _SelectScreenTimeGuardianViewTextEditingControllers = {};

final Map<String, FocusNode> _SelectScreenTimeGuardianViewFocusNodes = {};

final Map<String, String? Function(String?)?>
    _SelectScreenTimeGuardianViewTextValidations = {
  AmountValueKey: null,
};

mixin $SelectScreenTimeGuardianView on StatelessWidget {
  TextEditingController get amountController =>
      _getFormTextEditingController(AmountValueKey);
  FocusNode get amountFocusNode => _getFormFocusNode(AmountValueKey);

  TextEditingController _getFormTextEditingController(String key,
      {String? initialValue}) {
    if (_SelectScreenTimeGuardianViewTextEditingControllers.containsKey(key)) {
      return _SelectScreenTimeGuardianViewTextEditingControllers[key]!;
    }
    _SelectScreenTimeGuardianViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _SelectScreenTimeGuardianViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_SelectScreenTimeGuardianViewFocusNodes.containsKey(key)) {
      return _SelectScreenTimeGuardianViewFocusNodes[key]!;
    }
    _SelectScreenTimeGuardianViewFocusNodes[key] = FocusNode();
    return _SelectScreenTimeGuardianViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    amountController.addListener(() => _updateFormData(model));
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
          AmountValueKey: amountController.text,
        }),
    );
    if (_autoTextFieldValidation || forceValidate) {
      _updateValidationData(model);
    }
  }

  /// Updates the fieldsValidationMessages on the dynamic
  void _updateValidationData(dynamic model) => model.setValidationMessages({
        AmountValueKey: _getValidationMessage(AmountValueKey),
      });

  /// Returns the validation message for the given key
  String? _getValidationMessage(String key) {
    final validatorForKey = _SelectScreenTimeGuardianViewTextValidations[key];
    if (validatorForKey == null) return null;
    String? validationMessageForKey = validatorForKey(
        _SelectScreenTimeGuardianViewTextEditingControllers[key]!.text);
    return validationMessageForKey;
  }

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    for (var controller
        in _SelectScreenTimeGuardianViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _SelectScreenTimeGuardianViewFocusNodes.values) {
      focusNode.dispose();
    }

    _SelectScreenTimeGuardianViewTextEditingControllers.clear();
    _SelectScreenTimeGuardianViewFocusNodes.clear();
  }
}

extension ValueProperties on FormViewModel {
  bool get isFormValid =>
      this.fieldsValidationMessages.values.every((element) => element == null);
  String? get amountValue => this.formValueMap[AmountValueKey] as String?;

  bool get hasAmount => this.formValueMap.containsKey(AmountValueKey);

  bool get hasAmountValidationMessage =>
      this.fieldsValidationMessages[AmountValueKey]?.isNotEmpty ?? false;

  String? get amountValidationMessage =>
      this.fieldsValidationMessages[AmountValueKey];
}

extension Methods on FormViewModel {
  setAmountValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[AmountValueKey] = validationMessage;
}
