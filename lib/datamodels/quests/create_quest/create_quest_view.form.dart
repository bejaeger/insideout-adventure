<<<<<<< HEAD
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String NameValueKey = 'name';
const String DescriptionValueKey = 'description';
const String AfkCreditAmountValueKey = 'afkCreditAmount';
const String QuestTypeValueKey = 'questType';
const String AfkStartAndFinishMarkersValueKey = 'afkStartAndFinishMarkers';

const Map<String, String> AfkStartAndFinishMarkersValueToTitleMap = {
  'start': 'startMarker',
  'finish': 'finishMarker',
};

mixin $CreateQuestView on StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController afkCreditAmountController =
      TextEditingController();
  final TextEditingController questTypeController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode afkCreditAmountFocusNode = FocusNode();
  final FocusNode questTypeFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    nameController.addListener(() => _updateFormData(model));
    descriptionController.addListener(() => _updateFormData(model));
    afkCreditAmountController.addListener(() => _updateFormData(model));
    questTypeController.addListener(() => _updateFormData(model));
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData(
        model.formValueMap
          ..addAll({
            NameValueKey: nameController.text,
            DescriptionValueKey: descriptionController.text,
            AfkCreditAmountValueKey: afkCreditAmountController.text,
            QuestTypeValueKey: questTypeController.text,
          }),
      );

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    nameController.dispose();
    nameFocusNode.dispose();
    descriptionController.dispose();
    descriptionFocusNode.dispose();
    afkCreditAmountController.dispose();
    afkCreditAmountFocusNode.dispose();
    questTypeController.dispose();
    questTypeFocusNode.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String? get nameValue => this.formValueMap[NameValueKey];
  String? get descriptionValue => this.formValueMap[DescriptionValueKey];
  String? get afkCreditAmountValue =>
      this.formValueMap[AfkCreditAmountValueKey];
  String? get questTypeValue => this.formValueMap[QuestTypeValueKey];
  String? get afkStartAndFinishMarkersValue =>
      this.formValueMap[AfkStartAndFinishMarkersValueKey];

  bool get hasName => this.formValueMap.containsKey(NameValueKey);
  bool get hasDescription => this.formValueMap.containsKey(DescriptionValueKey);
  bool get hasAfkCreditAmount =>
      this.formValueMap.containsKey(AfkCreditAmountValueKey);
  bool get hasQuestType => this.formValueMap.containsKey(QuestTypeValueKey);
  bool get hasAfkStartAndFinishMarkers =>
      this.formValueMap.containsKey(AfkStartAndFinishMarkersValueKey);
}

extension Methods on FormViewModel {
  void setAfkStartAndFinishMarkers(String afkStartAndFinishMarkers) {
    this.setData(this.formValueMap
      ..addAll({AfkStartAndFinishMarkersValueKey: afkStartAndFinishMarkers}));
  }
}
||||||| 9d36a5c
=======
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String NameValueKey = 'name';
const String DescriptionValueKey = 'description';
const String AfkCreditAmountValueKey = 'afkCreditAmount';
const String QuestTypeValueKey = 'questType';

mixin $CreateQuestView on StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController afkCreditAmountController =
      TextEditingController();
  final TextEditingController questTypeController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode afkCreditAmountFocusNode = FocusNode();
  final FocusNode questTypeFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    nameController.addListener(() => _updateFormData(model));
    descriptionController.addListener(() => _updateFormData(model));
    afkCreditAmountController.addListener(() => _updateFormData(model));
    questTypeController.addListener(() => _updateFormData(model));
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData(
        model.formValueMap
          ..addAll({
            NameValueKey: nameController.text,
            DescriptionValueKey: descriptionController.text,
            AfkCreditAmountValueKey: afkCreditAmountController.text,
            QuestTypeValueKey: questTypeController.text,
          }),
      );

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    nameController.dispose();
    nameFocusNode.dispose();
    descriptionController.dispose();
    descriptionFocusNode.dispose();
    afkCreditAmountController.dispose();
    afkCreditAmountFocusNode.dispose();
    questTypeController.dispose();
    questTypeFocusNode.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String? get nameValue => this.formValueMap[NameValueKey];
  String? get descriptionValue => this.formValueMap[DescriptionValueKey];
  String? get afkCreditAmountValue =>
      this.formValueMap[AfkCreditAmountValueKey];
  String? get questTypeValue => this.formValueMap[QuestTypeValueKey];

  bool get hasName => this.formValueMap.containsKey(NameValueKey);
  bool get hasDescription => this.formValueMap.containsKey(DescriptionValueKey);
  bool get hasAfkCreditAmount =>
      this.formValueMap.containsKey(AfkCreditAmountValueKey);
  bool get hasQuestType => this.formValueMap.containsKey(QuestTypeValueKey);
}

extension Methods on FormViewModel {}
>>>>>>> be96a6d436b7e248fa0f05d0dd519285ff001918
