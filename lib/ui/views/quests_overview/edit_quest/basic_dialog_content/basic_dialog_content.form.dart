// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String NameValueKey = 'name';
const String DescriptionValueKey = 'description';
const String DistanceFromUserValueKey = 'distanceFromUser';
const String AfkCreditAmountValueKey = 'afkCreditAmount';

final Map<String, TextEditingController>
    _BasicDialogContentTextEditingControllers = {};

final Map<String, FocusNode> _BasicDialogContentFocusNodes = {};

final Map<String, String? Function(String?)?>
    _BasicDialogContentTextValidations = {
  NameValueKey: null,
  DescriptionValueKey: null,
  DistanceFromUserValueKey: null,
  AfkCreditAmountValueKey: null,
};

mixin $BasicDialogContent on StatelessWidget {
  TextEditingController get nameController =>
      _getFormTextEditingController(NameValueKey);
  TextEditingController get descriptionController =>
      _getFormTextEditingController(DescriptionValueKey);
  TextEditingController get distanceFromUserController =>
      _getFormTextEditingController(DistanceFromUserValueKey);
  TextEditingController get afkCreditAmountController =>
      _getFormTextEditingController(AfkCreditAmountValueKey);
  FocusNode get nameFocusNode => _getFormFocusNode(NameValueKey);
  FocusNode get descriptionFocusNode => _getFormFocusNode(DescriptionValueKey);
  FocusNode get distanceFromUserFocusNode =>
      _getFormFocusNode(DistanceFromUserValueKey);
  FocusNode get afkCreditAmountFocusNode =>
      _getFormFocusNode(AfkCreditAmountValueKey);

  TextEditingController _getFormTextEditingController(String key,
      {String? initialValue}) {
    if (_BasicDialogContentTextEditingControllers.containsKey(key)) {
      return _BasicDialogContentTextEditingControllers[key]!;
    }
    _BasicDialogContentTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _BasicDialogContentTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_BasicDialogContentFocusNodes.containsKey(key)) {
      return _BasicDialogContentFocusNodes[key]!;
    }
    _BasicDialogContentFocusNodes[key] = FocusNode();
    return _BasicDialogContentFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    nameController.addListener(() => _updateFormData(model));
    descriptionController.addListener(() => _updateFormData(model));
    distanceFromUserController.addListener(() => _updateFormData(model));
    afkCreditAmountController.addListener(() => _updateFormData(model));
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
          NameValueKey: nameController.text,
          DescriptionValueKey: descriptionController.text,
          DistanceFromUserValueKey: distanceFromUserController.text,
          AfkCreditAmountValueKey: afkCreditAmountController.text,
        }),
    );
    if (_autoTextFieldValidation || forceValidate) {
      _updateValidationData(model);
    }
  }

  /// Updates the fieldsValidationMessages on the dynamic
  void _updateValidationData(dynamic model) => model.setValidationMessages({
        NameValueKey: _getValidationMessage(NameValueKey),
        DescriptionValueKey: _getValidationMessage(DescriptionValueKey),
        DistanceFromUserValueKey:
            _getValidationMessage(DistanceFromUserValueKey),
        AfkCreditAmountValueKey: _getValidationMessage(AfkCreditAmountValueKey),
      });

  /// Returns the validation message for the given key
  String? _getValidationMessage(String key) {
    final validatorForKey = _BasicDialogContentTextValidations[key];
    if (validatorForKey == null) return null;
    String? validationMessageForKey =
        validatorForKey(_BasicDialogContentTextEditingControllers[key]!.text);
    return validationMessageForKey;
  }

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    for (var controller in _BasicDialogContentTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _BasicDialogContentFocusNodes.values) {
      focusNode.dispose();
    }

    _BasicDialogContentTextEditingControllers.clear();
    _BasicDialogContentFocusNodes.clear();
  }
}

extension ValueProperties on FormViewModel {
  bool get isFormValid =>
      this.fieldsValidationMessages.values.every((element) => element == null);
  String? get nameValue => this.formValueMap[NameValueKey] as String?;
  String? get descriptionValue =>
      this.formValueMap[DescriptionValueKey] as String?;
  String? get distanceFromUserValue =>
      this.formValueMap[DistanceFromUserValueKey] as String?;
  String? get afkCreditAmountValue =>
      this.formValueMap[AfkCreditAmountValueKey] as String?;

  bool get hasName => this.formValueMap.containsKey(NameValueKey);
  bool get hasDescription => this.formValueMap.containsKey(DescriptionValueKey);
  bool get hasDistanceFromUser =>
      this.formValueMap.containsKey(DistanceFromUserValueKey);
  bool get hasAfkCreditAmount =>
      this.formValueMap.containsKey(AfkCreditAmountValueKey);

  bool get hasNameValidationMessage =>
      this.fieldsValidationMessages[NameValueKey]?.isNotEmpty ?? false;
  bool get hasDescriptionValidationMessage =>
      this.fieldsValidationMessages[DescriptionValueKey]?.isNotEmpty ?? false;
  bool get hasDistanceFromUserValidationMessage =>
      this.fieldsValidationMessages[DistanceFromUserValueKey]?.isNotEmpty ??
      false;
  bool get hasAfkCreditAmountValidationMessage =>
      this.fieldsValidationMessages[AfkCreditAmountValueKey]?.isNotEmpty ??
      false;

  String? get nameValidationMessage =>
      this.fieldsValidationMessages[NameValueKey];
  String? get descriptionValidationMessage =>
      this.fieldsValidationMessages[DescriptionValueKey];
  String? get distanceFromUserValidationMessage =>
      this.fieldsValidationMessages[DistanceFromUserValueKey];
  String? get afkCreditAmountValidationMessage =>
      this.fieldsValidationMessages[AfkCreditAmountValueKey];
}

extension Methods on FormViewModel {
  setNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[NameValueKey] = validationMessage;
  setDescriptionValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[DescriptionValueKey] = validationMessage;
  setDistanceFromUserValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[DistanceFromUserValueKey] =
          validationMessage;
  setAfkCreditAmountValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[AfkCreditAmountValueKey] =
          validationMessage;
}
