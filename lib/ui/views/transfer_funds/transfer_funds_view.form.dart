// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs,  constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String AmountValueKey = 'amount';

final Map<String, TextEditingController>
    _TransferFundsViewTextEditingControllers = {};

final Map<String, FocusNode> _TransferFundsViewFocusNodes = {};

final Map<String, String? Function(String?)?>
    _TransferFundsViewTextValidations = {
  AmountValueKey: null,
};

mixin $TransferFundsView on StatelessWidget {
  TextEditingController get amountController =>
      _getFormTextEditingController(AmountValueKey);
  FocusNode get amountFocusNode => _getFormFocusNode(AmountValueKey);

  TextEditingController _getFormTextEditingController(String key,
      {String? initialValue}) {
    if (_TransferFundsViewTextEditingControllers.containsKey(key)) {
      return _TransferFundsViewTextEditingControllers[key]!;
    }
    _TransferFundsViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _TransferFundsViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_TransferFundsViewFocusNodes.containsKey(key)) {
      return _TransferFundsViewFocusNodes[key]!;
    }
    _TransferFundsViewFocusNodes[key] = FocusNode();
    return _TransferFundsViewFocusNodes[key]!;
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

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model, {bool forceValidate = false}) {
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

  /// Updates the fieldsValidationMessages on the FormViewModel
  void _updateValidationData(FormViewModel model) =>
      model.setValidationMessages({
        AmountValueKey: _getValidationMessage(AmountValueKey),
      });

  /// Returns the validation message for the given key
  String? _getValidationMessage(String key) {
    final validatorForKey = _TransferFundsViewTextValidations[key];
    if (validatorForKey == null) return null;
    String? validationMessageForKey =
        validatorForKey(_TransferFundsViewTextEditingControllers[key]!.text);
    return validationMessageForKey;
  }

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    for (var controller in _TransferFundsViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _TransferFundsViewFocusNodes.values) {
      focusNode.dispose();
    }

    _TransferFundsViewTextEditingControllers.clear();
    _TransferFundsViewFocusNodes.clear();
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
