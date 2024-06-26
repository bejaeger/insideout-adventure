// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String NameValueKey = 'name';
const String DescriptionValueKey = 'description';
const String CreditsAmountValueKey = 'creditsAmount';
const String QuestTypeValueKey = 'questType';
const String AfkStartAndFinishMarkersValueKey = 'afkStartAndFinishMarkers';

const Map<String, String> AfkStartAndFinishMarkersValueToTitleMap = {
  'start': 'startMarker',
  'finish': 'finishMarker',
};

mixin $CreateQuestView on StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController creditsAmountController = TextEditingController();
  final TextEditingController questTypeController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode creditsAmountFocusNode = FocusNode();
  final FocusNode questTypeFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    nameController.addListener(() => _updateFormData(model));
    descriptionController.addListener(() => _updateFormData(model));
    creditsAmountController.addListener(() => _updateFormData(model));
    questTypeController.addListener(() => _updateFormData(model));
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData(
        model.formValueMap
          ..addAll({
            NameValueKey: nameController.text,
            DescriptionValueKey: descriptionController.text,
            CreditsAmountValueKey: creditsAmountController.text,
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
    creditsAmountController.dispose();
    creditsAmountFocusNode.dispose();
    questTypeController.dispose();
    questTypeFocusNode.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String? get nameValue => this.formValueMap[NameValueKey];
  String? get descriptionValue => this.formValueMap[DescriptionValueKey];
  String? get creditsAmountValue => this.formValueMap[CreditsAmountValueKey];
  String? get questTypeValue => this.formValueMap[QuestTypeValueKey];
  String? get afkStartAndFinishMarkersValue =>
      this.formValueMap[AfkStartAndFinishMarkersValueKey];

  bool get hasName => this.formValueMap.containsKey(NameValueKey);
  bool get hasDescription => this.formValueMap.containsKey(DescriptionValueKey);
  bool get hasCreditsAmount =>
      this.formValueMap.containsKey(CreditsAmountValueKey);
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
