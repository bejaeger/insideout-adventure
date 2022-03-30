// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String AmountValueKey = 'amount';
const String DescriptionValueKey = 'description';
const String CategoryValueKey = 'category';

mixin $AddGiftCardsView on StatelessWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final FocusNode amountFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode categoryFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    amountController.addListener(() => _updateFormData(model));
    descriptionController.addListener(() => _updateFormData(model));
    categoryController.addListener(() => _updateFormData(model));
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData(
        model.formValueMap
          ..addAll({
            AmountValueKey: amountController.text,
            DescriptionValueKey: descriptionController.text,
            CategoryValueKey: categoryController.text,
          }),
      );

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    amountController.dispose();
    amountFocusNode.dispose();
    descriptionController.dispose();
    descriptionFocusNode.dispose();
    categoryController.dispose();
    categoryFocusNode.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String? get amountValue => this.formValueMap[AmountValueKey] as String?;
  String? get descriptionValue =>
      this.formValueMap[DescriptionValueKey] as String?;
  String? get categoryValue => this.formValueMap[CategoryValueKey] as String?;

  bool get hasAmount => this.formValueMap.containsKey(AmountValueKey);
  bool get hasDescription => this.formValueMap.containsKey(DescriptionValueKey);
  bool get hasCategory => this.formValueMap.containsKey(CategoryValueKey);

  bool get hasAmountValidationMessage =>
      this.fieldsValidationMessages[AmountValueKey]?.isNotEmpty ?? false;
  bool get hasDescriptionValidationMessage =>
      this.fieldsValidationMessages[DescriptionValueKey]?.isNotEmpty ?? false;
  bool get hasCategoryValidationMessage =>
      this.fieldsValidationMessages[CategoryValueKey]?.isNotEmpty ?? false;

  String? get amountValidationMessage =>
      this.fieldsValidationMessages[AmountValueKey];
  String? get descriptionValidationMessage =>
      this.fieldsValidationMessages[DescriptionValueKey];
  String? get categoryValidationMessage =>
      this.fieldsValidationMessages[CategoryValueKey];
}

extension Methods on FormViewModel {
  setAmountValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[AmountValueKey] = validationMessage;
  setDescriptionValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[DescriptionValueKey] = validationMessage;
  setCategoryValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[CategoryValueKey] = validationMessage;
}
