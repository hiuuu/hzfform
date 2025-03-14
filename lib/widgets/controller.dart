import 'package:flutter/material.dart';
import '../core/enums.dart';
import '../models/field_model.dart';

/// Form controller to manage form state
class HZFFormController extends ChangeNotifier {
  /// Map of fields by tag
  final Map<String, HZFFormFieldModel> _fields = {};

  /// Register a field with the form
  void registerField(HZFFormFieldModel field) {
    _fields[field.tag] = field;
  }

  /// Unregister a field
  void unregisterField(String tag) {
    _fields.remove(tag);
  }

  /// Get field by tag
  HZFFormFieldModel? getField(String tag) {
    return _fields[tag];
  }

  /// Update field value
  void updateFieldValue(String tag, dynamic value) {
    final field = _fields[tag];
    if (field != null) {
      field.value = value;
      field.status = HZFFormFieldStatusEnum.normal;
      notifyListeners();
    }
  }

  /// Set field error
  void setFieldError(String tag, String errorMessage) {
    final field = _fields[tag];
    if (field != null) {
      field.errorMessage = errorMessage;
      field.status = HZFFormFieldStatusEnum.error;
      notifyListeners();
    }
  }

  /// Reset form to initial state
  void resetForm() {
    for (final field in _fields.values) {
      field.value = null;
      field.status = HZFFormFieldStatusEnum.normal;
      field.errorMessage = null;
    }
    notifyListeners();
  }

  /// Get all form values as Map
  Map<String, dynamic> getFormValues() {
    final values = <String, dynamic>{};
    for (final entry in _fields.entries) {
      values[entry.key] = entry.value.value;
    }
    return values;
  }

  /// Validates all form fields
  bool validateForm() {
    bool isValid = true;

    for (final field in _fields.values) {
      final fieldValid = _validateField(field);
      if (!fieldValid) {
        isValid = false;
      }
    }

    notifyListeners();
    return isValid;
  }

  /// Validate individual field
  bool _validateField(HZFFormFieldModel field) {
    // Skip validation for read-only fields
    if (field.enableReadOnly == true) {
      return true;
    }

    // Required field validation
    if (field.required == true) {
      if (field.value == null ||
          (field.value is String && (field.value as String).isEmpty) ||
          (field.value is List && (field.value as List).isEmpty)) {
        field.status = HZFFormFieldStatusEnum.error;
        field.errorMessage ??= 'This field is required';
        return false;
      }
    }

    // Skip regex validation if value is empty
    if (field.value == null ||
        (field.value is String && (field.value as String).isEmpty)) {
      field.status = HZFFormFieldStatusEnum.normal;
      return true;
    }

    // Regex validation
    if (field.validateRegEx != null && field.value is String) {
      if (!field.validateRegEx!.hasMatch(field.value.toString())) {
        field.status = HZFFormFieldStatusEnum.error;
        field.errorMessage ??= 'Invalid format';
        return false;
      }
    }

    // Field is valid
    field.status = HZFFormFieldStatusEnum.success;
    return true;
  }
}
