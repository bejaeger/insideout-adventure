// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:afkcredits/ui/views/add_explorer/validators.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String NameValueKey = 'name';
const String PasswordValueKey = 'password';

final Map<String, TextEditingController>
    _AddExplorerViewTextEditingControllers = {};

final Map<String, FocusNode> _AddExplorerViewFocusNodes = {};

final Map<String, String? Function(String?)?> _AddExplorerViewTextValidations =
    {
  NameValueKey: FormValidators.nameValidator,
  PasswordValueKey: FormValidators.passwordValidator,
};

mixin $AddExplorerView on StatelessWidget {
  TextEditingController get nameController =>
      _getFormTextEditingController(NameValueKey);
  TextEditingController get passwordController =>
      _getFormTextEditingController(PasswordValueKey);
  FocusNode get nameFocusNode => _getFormFocusNode(NameValueKey);
  FocusNode get passwordFocusNode => _getFormFocusNode(PasswordValueKey);

  TextEditingController _getFormTextEditingController(String key,
      {String? initialValue}) {
    if (_AddExplorerViewTextEditingControllers.containsKey(key)) {
      return _AddExplorerViewTextEditingControllers[key]!;
    }
    _AddExplorerViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _AddExplorerViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_AddExplorerViewFocusNodes.containsKey(key)) {
      return _AddExplorerViewFocusNodes[key]!;
    }
    _AddExplorerViewFocusNodes[key] = FocusNode();
    return _AddExplorerViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    nameController.addListener(() => _updateFormData(model));
    passwordController.addListener(() => _updateFormData(model));
  }

  final bool _autoTextFieldValidation = false;
  bool validateFormFields(FormViewModel model) {
    _updateFormData(model, forceValidate: true);
    return model.isFormValid;
  }

  /// Updates the formData on the dynamic
  void _updateFormData(dynamic model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          NameValueKey: nameController.text,
          PasswordValueKey: passwordController.text,
        }),
    );
    if (_autoTextFieldValidation || forceValidate) {
      _updateValidationData(model);
    }
  }

  /// Updates the fieldsValidationMessages on the dynamic
  void _updateValidationData(dynamic model) => model.setValidationMessages({
        NameValueKey: _getValidationMessage(NameValueKey),
        PasswordValueKey: _getValidationMessage(PasswordValueKey),
      });

  /// Returns the validation message for the given key
  String? _getValidationMessage(String key) {
    final validatorForKey = _AddExplorerViewTextValidations[key];
    if (validatorForKey == null) return null;
    String? validationMessageForKey =
        validatorForKey(_AddExplorerViewTextEditingControllers[key]!.text);
    return validationMessageForKey;
  }

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    for (var controller in _AddExplorerViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _AddExplorerViewFocusNodes.values) {
      focusNode.dispose();
    }

    _AddExplorerViewTextEditingControllers.clear();
    _AddExplorerViewFocusNodes.clear();
  }
}

extension ValueProperties on FormViewModel {
  bool get isFormValid =>
      this.fieldsValidationMessages.values.every((element) => element == null);
  String? get nameValue => this.formValueMap[NameValueKey] as String?;
  String? get passwordValue => this.formValueMap[PasswordValueKey] as String?;

  bool get hasName => this.formValueMap.containsKey(NameValueKey);
  bool get hasPassword => this.formValueMap.containsKey(PasswordValueKey);

  bool get hasNameValidationMessage =>
      this.fieldsValidationMessages[NameValueKey]?.isNotEmpty ?? false;
  bool get hasPasswordValidationMessage =>
      this.fieldsValidationMessages[PasswordValueKey]?.isNotEmpty ?? false;

  String? get nameValidationMessage =>
      this.fieldsValidationMessages[NameValueKey];
  String? get passwordValidationMessage =>
      this.fieldsValidationMessages[PasswordValueKey];
}

extension Methods on FormViewModel {
  setNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[NameValueKey] = validationMessage;
  setPasswordValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[PasswordValueKey] = validationMessage;
}
