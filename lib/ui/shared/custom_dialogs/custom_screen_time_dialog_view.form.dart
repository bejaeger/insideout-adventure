// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String TimeValueKey = 'time';

final Map<String, TextEditingController>
    _CustomScreenTimeDialogViewTextEditingControllers = {};

final Map<String, FocusNode> _CustomScreenTimeDialogViewFocusNodes = {};

final Map<String, String? Function(String?)?>
    _CustomScreenTimeDialogViewTextValidations = {
  TimeValueKey: null,
};

mixin $CustomScreenTimeDialogView on StatelessWidget {
  TextEditingController get timeController =>
      _getFormTextEditingController(TimeValueKey);
  FocusNode get timeFocusNode => _getFormFocusNode(TimeValueKey);

  TextEditingController _getFormTextEditingController(String key,
      {String? initialValue}) {
    if (_CustomScreenTimeDialogViewTextEditingControllers.containsKey(key)) {
      return _CustomScreenTimeDialogViewTextEditingControllers[key]!;
    }
    _CustomScreenTimeDialogViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _CustomScreenTimeDialogViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_CustomScreenTimeDialogViewFocusNodes.containsKey(key)) {
      return _CustomScreenTimeDialogViewFocusNodes[key]!;
    }
    _CustomScreenTimeDialogViewFocusNodes[key] = FocusNode();
    return _CustomScreenTimeDialogViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    timeController.addListener(() => _updateFormData(model));
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
          TimeValueKey: timeController.text,
        }),
    );
    if (_autoTextFieldValidation || forceValidate) {
      _updateValidationData(model);
    }
  }

  /// Updates the fieldsValidationMessages on the dynamic
  void _updateValidationData(dynamic model) => model.setValidationMessages({
        TimeValueKey: _getValidationMessage(TimeValueKey),
      });

  /// Returns the validation message for the given key
  String? _getValidationMessage(String key) {
    final validatorForKey = _CustomScreenTimeDialogViewTextValidations[key];
    if (validatorForKey == null) return null;
    String? validationMessageForKey = validatorForKey(
        _CustomScreenTimeDialogViewTextEditingControllers[key]!.text);
    return validationMessageForKey;
  }

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    for (var controller
        in _CustomScreenTimeDialogViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _CustomScreenTimeDialogViewFocusNodes.values) {
      focusNode.dispose();
    }

    _CustomScreenTimeDialogViewTextEditingControllers.clear();
    _CustomScreenTimeDialogViewFocusNodes.clear();
  }
}

extension ValueProperties on FormViewModel {
  bool get isFormValid =>
      this.fieldsValidationMessages.values.every((element) => element == null);
  String? get timeValue => this.formValueMap[TimeValueKey] as String?;

  bool get hasTime => this.formValueMap.containsKey(TimeValueKey);

  bool get hasTimeValidationMessage =>
      this.fieldsValidationMessages[TimeValueKey]?.isNotEmpty ?? false;

  String? get timeValidationMessage =>
      this.fieldsValidationMessages[TimeValueKey];
}

extension Methods on FormViewModel {
  setTimeValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[TimeValueKey] = validationMessage;
}
