// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs,  constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String FeedbackValueKey = 'feedback';

final Map<String, TextEditingController> _FeedbackViewTextEditingControllers =
    {};

final Map<String, FocusNode> _FeedbackViewFocusNodes = {};

final Map<String, String? Function(String?)?> _FeedbackViewTextValidations = {
  FeedbackValueKey: null,
};

mixin $FeedbackView on StatelessWidget {
  TextEditingController get feedbackController =>
      _getFormTextEditingController(FeedbackValueKey);
  FocusNode get feedbackFocusNode => _getFormFocusNode(FeedbackValueKey);

  TextEditingController _getFormTextEditingController(String key,
      {String? initialValue}) {
    if (_FeedbackViewTextEditingControllers.containsKey(key)) {
      return _FeedbackViewTextEditingControllers[key]!;
    }
    _FeedbackViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _FeedbackViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_FeedbackViewFocusNodes.containsKey(key)) {
      return _FeedbackViewFocusNodes[key]!;
    }
    _FeedbackViewFocusNodes[key] = FocusNode();
    return _FeedbackViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    feedbackController.addListener(() => _updateFormData(model));
  }

  final bool _autoTextFieldValidation = true;
  bool validateFormFields(FormViewModel model) {
    _updateFormData(model, forceValidate: true);
    return model.isFormValid;
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          FeedbackValueKey: feedbackController.text,
        }),
    );
    if (_autoTextFieldValidation || forceValidate) {
      _updateValidationData(model);
    }
  }

  /// Updates the fieldsValidationMessages on the FormViewModel
  void _updateValidationData(FormViewModel model) =>
      model.setValidationMessages({
        FeedbackValueKey: _getValidationMessage(FeedbackValueKey),
      });

  /// Returns the validation message for the given key
  String? _getValidationMessage(String key) {
    final validatorForKey = _FeedbackViewTextValidations[key];
    if (validatorForKey == null) return null;
    String? validationMessageForKey =
        validatorForKey(_FeedbackViewTextEditingControllers[key]!.text);
    return validationMessageForKey;
  }

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    for (var controller in _FeedbackViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _FeedbackViewFocusNodes.values) {
      focusNode.dispose();
    }

    _FeedbackViewTextEditingControllers.clear();
    _FeedbackViewFocusNodes.clear();
  }
}

extension ValueProperties on FormViewModel {
  bool get isFormValid =>
      this.fieldsValidationMessages.values.every((element) => element == null);
  String? get feedbackValue => this.formValueMap[FeedbackValueKey] as String?;

  bool get hasFeedback => this.formValueMap.containsKey(FeedbackValueKey);

  bool get hasFeedbackValidationMessage =>
      this.fieldsValidationMessages[FeedbackValueKey]?.isNotEmpty ?? false;

  String? get feedbackValidationMessage =>
      this.fieldsValidationMessages[FeedbackValueKey];
}

extension Methods on FormViewModel {
  setFeedbackValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[FeedbackValueKey] = validationMessage;
}
