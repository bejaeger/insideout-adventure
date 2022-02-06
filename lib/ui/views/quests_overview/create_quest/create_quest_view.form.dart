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
const String MarkerNotesValueKey = 'markerNotes';
const String QuestTypeValueKey = 'questType';

mixin $CreateQuestView on StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController afkCreditAmountController =
      TextEditingController();
  final TextEditingController markerNotesController = TextEditingController();
  final TextEditingController questTypeController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode afkCreditAmountFocusNode = FocusNode();
  final FocusNode markerNotesFocusNode = FocusNode();
  final FocusNode questTypeFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    nameController.addListener(() => _updateFormData(model));
    descriptionController.addListener(() => _updateFormData(model));
    afkCreditAmountController.addListener(() => _updateFormData(model));
    markerNotesController.addListener(() => _updateFormData(model));
    questTypeController.addListener(() => _updateFormData(model));
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData(
        model.formValueMap
          ..addAll({
            NameValueKey: nameController.text,
            DescriptionValueKey: descriptionController.text,
            AfkCreditAmountValueKey: afkCreditAmountController.text,
            MarkerNotesValueKey: markerNotesController.text,
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
    markerNotesController.dispose();
    markerNotesFocusNode.dispose();
    questTypeController.dispose();
    questTypeFocusNode.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String? get nameValue => this.formValueMap[NameValueKey];
  String? get descriptionValue => this.formValueMap[DescriptionValueKey];
  String? get afkCreditAmountValue =>
      this.formValueMap[AfkCreditAmountValueKey];
  String? get markerNotesValue => this.formValueMap[MarkerNotesValueKey];
  String? get questTypeValue => this.formValueMap[QuestTypeValueKey];

  bool get hasName => this.formValueMap.containsKey(NameValueKey);
  bool get hasDescription => this.formValueMap.containsKey(DescriptionValueKey);
  bool get hasAfkCreditAmount =>
      this.formValueMap.containsKey(AfkCreditAmountValueKey);
  bool get hasMarkerNotes => this.formValueMap.containsKey(MarkerNotesValueKey);
  bool get hasQuestType => this.formValueMap.containsKey(QuestTypeValueKey);
}

extension Methods on FormViewModel {}
