// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String NameValueKey = 'name';
const String DescriptionValueKey = 'description';
const String DistanceFromUserValueKey = 'distanceFromUser';

mixin $BasicDialogContent on StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController distanceFromUserController =
      TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode distanceFromUserFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    nameController.addListener(() => _updateFormData(model));
    descriptionController.addListener(() => _updateFormData(model));
    distanceFromUserController.addListener(() => _updateFormData(model));
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData(
        model.formValueMap
          ..addAll({
            NameValueKey: nameController.text,
            DescriptionValueKey: descriptionController.text,
            DistanceFromUserValueKey: distanceFromUserController.text,
          }),
      );

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    nameController.dispose();
    nameFocusNode.dispose();
    descriptionController.dispose();
    descriptionFocusNode.dispose();
    distanceFromUserController.dispose();
    distanceFromUserFocusNode.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String? get nameValue => this.formValueMap[NameValueKey];
  String? get descriptionValue => this.formValueMap[DescriptionValueKey];
  String? get distanceFromUserValue =>
      this.formValueMap[DistanceFromUserValueKey];

  bool get hasName => this.formValueMap.containsKey(NameValueKey);
  bool get hasDescription => this.formValueMap.containsKey(DescriptionValueKey);
  bool get hasDistanceFromUser =>
      this.formValueMap.containsKey(DistanceFromUserValueKey);
}

extension Methods on FormViewModel {}
