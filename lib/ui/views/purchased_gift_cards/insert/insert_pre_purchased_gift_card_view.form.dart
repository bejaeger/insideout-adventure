// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String AmountValueKey = 'amount';
const String CategoryValueKey = 'category';
const String GiftCardCodeValueKey = 'giftCardCode';

mixin $InsertPrePurchasedGiftCardView on StatelessWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController giftCardCodeController = TextEditingController();
  final FocusNode amountFocusNode = FocusNode();
  final FocusNode categoryFocusNode = FocusNode();
  final FocusNode giftCardCodeFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    amountController.addListener(() => _updateFormData(model));
    categoryController.addListener(() => _updateFormData(model));
    giftCardCodeController.addListener(() => _updateFormData(model));
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData(
        model.formValueMap
          ..addAll({
            AmountValueKey: amountController.text,
            CategoryValueKey: categoryController.text,
            GiftCardCodeValueKey: giftCardCodeController.text,
          }),
      );

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    amountController.dispose();
    amountFocusNode.dispose();
    categoryController.dispose();
    categoryFocusNode.dispose();
    giftCardCodeController.dispose();
    giftCardCodeFocusNode.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String? get amountValue => this.formValueMap[AmountValueKey];
  String? get categoryValue => this.formValueMap[CategoryValueKey];
  String? get giftCardCodeValue => this.formValueMap[GiftCardCodeValueKey];

  bool get hasAmount => this.formValueMap.containsKey(AmountValueKey);
  bool get hasCategory => this.formValueMap.containsKey(CategoryValueKey);
  bool get hasGiftCardCode =>
      this.formValueMap.containsKey(GiftCardCodeValueKey);

  bool get hasAmountValidationMessage =>
      this.fieldsValidationMessages[AmountValueKey]?.isNotEmpty ?? false;
  bool get hasCategoryValidationMessage =>
      this.fieldsValidationMessages[CategoryValueKey]?.isNotEmpty ?? false;
  bool get hasGiftCardCodeValidationMessage =>
      this.fieldsValidationMessages[GiftCardCodeValueKey]?.isNotEmpty ?? false;

  String? get amountValidationMessage =>
      this.fieldsValidationMessages[AmountValueKey];
  String? get categoryValidationMessage =>
      this.fieldsValidationMessages[CategoryValueKey];
  String? get giftCardCodeValidationMessage =>
      this.fieldsValidationMessages[GiftCardCodeValueKey];
}

extension Methods on FormViewModel {
  setAmountValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[AmountValueKey] = validationMessage;
  setCategoryValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[CategoryValueKey] = validationMessage;
  setGiftCardCodeValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[GiftCardCodeValueKey] = validationMessage;
}
