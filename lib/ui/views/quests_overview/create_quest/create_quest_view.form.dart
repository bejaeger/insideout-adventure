// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:afkcredits/ui/views/create_explorer/validators.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String NameValueKey = 'name';
const String DescriptionValueKey = 'description';
const String AfkCreditAmountValueKey = 'afkCreditAmount';
const String QuestTypeValueKey = 'questType';

final Map<String, String> QuestTypeValueToTitleMap = {
  'QuestTypeDr': 'QuestType',
};

final Map<String, TextEditingController>
    _CreateQuestViewTextEditingControllers = {};

final Map<String, FocusNode> _CreateQuestViewFocusNodes = {};

final Map<String, String? Function(String?)?> _CreateQuestViewTextValidations =
    {
  NameValueKey: FormValidators.nameValidator,
  DescriptionValueKey: null,
  AfkCreditAmountValueKey: null,
};

mixin $CreateQuestView on StatelessWidget {
  TextEditingController get nameController =>
      _getFormTextEditingController(NameValueKey, initialValue: 'Quest Name');
  TextEditingController get descriptionController =>
      _getFormTextEditingController(DescriptionValueKey);
  TextEditingController get afkCreditAmountController =>
      _getFormTextEditingController(AfkCreditAmountValueKey);
  FocusNode get nameFocusNode => _getFormFocusNode(NameValueKey);
  FocusNode get descriptionFocusNode => _getFormFocusNode(DescriptionValueKey);
  FocusNode get afkCreditAmountFocusNode =>
      _getFormFocusNode(AfkCreditAmountValueKey);

  TextEditingController _getFormTextEditingController(String key,
      {String? initialValue}) {
    if (_CreateQuestViewTextEditingControllers.containsKey(key)) {
      return _CreateQuestViewTextEditingControllers[key]!;
    }
    _CreateQuestViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _CreateQuestViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_CreateQuestViewFocusNodes.containsKey(key)) {
      return _CreateQuestViewFocusNodes[key]!;
    }
    _CreateQuestViewFocusNodes[key] = FocusNode();
    return _CreateQuestViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    nameController.addListener(() => _updateFormData(model));
    descriptionController.addListener(() => _updateFormData(model));
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
        AfkCreditAmountValueKey: _getValidationMessage(AfkCreditAmountValueKey),
      });

  /// Returns the validation message for the given key
  String? _getValidationMessage(String key) {
    final validatorForKey = _CreateQuestViewTextValidations[key];
    if (validatorForKey == null) return null;
    String? validationMessageForKey =
        validatorForKey(_CreateQuestViewTextEditingControllers[key]!.text);
    return validationMessageForKey;
  }

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    for (var controller in _CreateQuestViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _CreateQuestViewFocusNodes.values) {
      focusNode.dispose();
    }

    _CreateQuestViewTextEditingControllers.clear();
    _CreateQuestViewFocusNodes.clear();
  }
}

extension ValueProperties on FormViewModel {
  bool get isFormValid =>
      this.fieldsValidationMessages.values.every((element) => element == null);
  String? get nameValue => this.formValueMap[NameValueKey] as String?;
  String? get descriptionValue =>
      this.formValueMap[DescriptionValueKey] as String?;
  String? get afkCreditAmountValue =>
      this.formValueMap[AfkCreditAmountValueKey] as String?;
  String? get questTypeValue => this.formValueMap[QuestTypeValueKey] as String?;

  bool get hasName => this.formValueMap.containsKey(NameValueKey);
  bool get hasDescription => this.formValueMap.containsKey(DescriptionValueKey);
  bool get hasAfkCreditAmount =>
      this.formValueMap.containsKey(AfkCreditAmountValueKey);
  bool get hasQuestType => this.formValueMap.containsKey(QuestTypeValueKey);

  bool get hasNameValidationMessage =>
      this.fieldsValidationMessages[NameValueKey]?.isNotEmpty ?? false;
  bool get hasDescriptionValidationMessage =>
      this.fieldsValidationMessages[DescriptionValueKey]?.isNotEmpty ?? false;
  bool get hasAfkCreditAmountValidationMessage =>
      this.fieldsValidationMessages[AfkCreditAmountValueKey]?.isNotEmpty ??
      false;
  bool get hasQuestTypeValidationMessage =>
      this.fieldsValidationMessages[QuestTypeValueKey]?.isNotEmpty ?? false;

  String? get nameValidationMessage =>
      this.fieldsValidationMessages[NameValueKey];
  String? get descriptionValidationMessage =>
      this.fieldsValidationMessages[DescriptionValueKey];
  String? get afkCreditAmountValidationMessage =>
      this.fieldsValidationMessages[AfkCreditAmountValueKey];
  String? get questTypeValidationMessage =>
      this.fieldsValidationMessages[QuestTypeValueKey];
}

extension Methods on FormViewModel {
  void setQuestType(String questType) {
    this.setData(this.formValueMap..addAll({QuestTypeValueKey: questType}));
  }

  setNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[NameValueKey] = validationMessage;
  setDescriptionValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[DescriptionValueKey] = validationMessage;
  setAfkCreditAmountValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[AfkCreditAmountValueKey] =
          validationMessage;
  setQuestTypeValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[QuestTypeValueKey] = validationMessage;
}
