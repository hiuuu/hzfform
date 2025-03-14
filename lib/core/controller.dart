import 'package:flutter/material.dart';
import 'package:hzfform/core/actions.dart';
import 'enums.dart';
import '../models/field_model.dart';

/// Form controller to manage form state
// class HZFFormController extends ChangeNotifier {
//   /// Map of fields by tag
//   final Map<String, HZFFormFieldModel> _fields = {};

//   /// Register a field with the form
//   void registerField(HZFFormFieldModel field) {
//     _fields[field.tag] = field;
//   }

//   /// Unregister a field
//   void unregisterField(String tag) {
//     _fields.remove(tag);
//   }

//   /// Get field by tag
//   HZFFormFieldModel? getField(String tag) {
//     return _fields[tag];
//   }

//   /// Update field value
//   void updateFieldValue(String tag, dynamic value) {
//     final field = _fields[tag];
//     if (field != null) {
//       field.value = value;
//       field.status = HZFFormFieldStatusEnum.normal;
//       notifyListeners();
//     }
//   }

//   /// Set field error
//   void setFieldError(String tag, String errorMessage) {
//     final field = _fields[tag];
//     if (field != null) {
//       field.errorMessage = errorMessage;
//       field.status = HZFFormFieldStatusEnum.error;
//       notifyListeners();
//     }
//   }

//   /// Reset form to initial state
//   void resetForm() {
//     for (final field in _fields.values) {
//       field.value = null;
//       field.status = HZFFormFieldStatusEnum.normal;
//       field.errorMessage = null;
//     }
//     notifyListeners();
//   }

//   /// Get all form values as Map
//   Map<String, dynamic> getFormValues() {
//     final values = <String, dynamic>{};
//     for (final entry in _fields.entries) {
//       values[entry.key] = entry.value.value;
//     }
//     return values;
//   }

//   /// Validates all form fields
//   bool validateForm() {
//     bool isValid = true;

//     for (final field in _fields.values) {
//       final fieldValid = _validateField(field);
//       if (!fieldValid) {
//         isValid = false;
//       }
//     }

//     notifyListeners();
//     return isValid;
//   }

//   /// Validate individual field
//   bool _validateField(HZFFormFieldModel field) {
//     // Skip validation for read-only fields
//     if (field.enableReadOnly == true) {
//       return true;
//     }

//     // Required field validation
//     if (field.required == true) {
//       if (field.value == null ||
//           (field.value is String && (field.value as String).isEmpty) ||
//           (field.value is List && (field.value as List).isEmpty)) {
//         field.status = HZFFormFieldStatusEnum.error;
//         field.errorMessage ??= 'This field is required';
//         return false;
//       }
//     }

//     // Skip regex validation if value is empty
//     if (field.value == null ||
//         (field.value is String && (field.value as String).isEmpty)) {
//       field.status = HZFFormFieldStatusEnum.normal;
//       return true;
//     }

//     // Regex validation
//     if (field.validateRegEx != null && field.value is String) {
//       if (!field.validateRegEx!.hasMatch(field.value.toString())) {
//         field.status = HZFFormFieldStatusEnum.error;
//         field.errorMessage ??= 'Invalid format';
//         return false;
//       }
//     }

//     // Field is valid
//     field.status = HZFFormFieldStatusEnum.success;
//     return true;
//   }
// }

/// Form controller for managing form state and actions
class HZFFormController extends ChangeNotifier {
  // Form values storage
  final Map<String, dynamic> _formValues = {};

  // Field models registry
  final Map<String, HZFFormFieldModel> _fieldModels = {};

  // Validation errors
  final Map<String, String?> _fieldErrors = {};

  // Field visibility conditions
  final Map<String, bool Function(Map<String, dynamic>)> _visibilityConditions =
      {};

  // Field dependency graph for efficient updates
  final Map<String, Set<String>> _dependencyGraph = {};

  // Field-specific listeners
  final Map<String, List<Function(dynamic)>> _fieldListeners = {};

  // Form buttons registry
  final Map<String, HZFFormButton> _formButtons = {};

  /// Register a field model
  void registerField(HZFFormFieldModel model) {
    _fieldModels[model.tag] = model;

    // Initialize field with default value if not already set
    if (!_formValues.containsKey(model.tag) && model.value != null) {
      _formValues[model.tag] = model.value;
    }
  }

  getField(String tag) => _fieldModels[tag];
  unregisterFields() => _fieldModels.clear();
  unregisterField(String tag) => _fieldModels.remove(tag);
  registerButton(String tag, HZFFormButton button) =>
      _formButtons[tag] = button;
  Map<String, dynamic> getFormValues() => Map.from(_formValues);
  dynamic getFieldValue(String tag) => _formValues[tag];

  /// Register multiple field models
  void registerFields(List<HZFFormFieldModel> models) {
    for (final model in models) {
      registerField(model);
    }
  }

  /// Initialize form with values
  void initFormValues(Map<String, dynamic> values) {
    _formValues.addAll(values);
    notifyListeners();
  }

  /// Reset form to initial state
  void resetForm() {
    _formValues.clear();
    _fieldErrors.clear();

    // Reset to default values if specified
    for (final model in _fieldModels.values) {
      if (model.value != null) {
        _formValues[model.tag] = model.value;
      }
    }

    notifyListeners();
  }

  /// Update field value
  void updateFieldValue(String tag, dynamic value) {
    final oldValue = _formValues[tag];

    // Skip if value hasn't changed
    if (value == oldValue) return;

    // Update value
    _formValues[tag] = value;

    // Clear validation error
    _fieldErrors.remove(tag);

    // Notify field-specific listeners
    _notifyFieldListeners(tag, value);

    // Update dependent fields
    _updateDependentFields(tag);

    // Notify global listeners
    notifyListeners();
  }

  /// Add field-specific listener
  void addFieldListener(String tag, Function(dynamic) listener) =>
      _fieldListeners.putIfAbsent(tag, () => []).add(listener);

  /// Remove field-specific listener
  void removeFieldListener(String tag, Function(dynamic) listener) {
    if (_fieldListeners.containsKey(tag)) {
      _fieldListeners[tag]!.remove(listener);
      if (_fieldListeners[tag]!.isEmpty) {
        _fieldListeners.remove(tag);
      }
    }
  }

  /// Add dependency between fields
  void addDependency(String dependentTag, String dependsOnTag) =>
      _dependencyGraph.putIfAbsent(dependsOnTag, () => {}).add(dependentTag);

  /// Set visibility condition for a field
  void setVisibilityCondition(
      String tag, bool Function(Map<String, dynamic>) condition) {
    _visibilityConditions[tag] = condition;
  }

  /// Check if a field is visible
  bool isFieldVisible(String tag) {
    if (!_visibilityConditions.containsKey(tag)) return true;
    return _visibilityConditions[tag]!(_formValues);
  }

  /// Validate all form fields
  bool validate() {
    bool isValid = true;
    _fieldErrors.clear();

    for (final entry in _fieldModels.entries) {
      final tag = entry.key;
      final model = entry.value;

      // Skip validation for invisible fields
      if (!isFieldVisible(tag)) continue;

      final error = _validateField(model);
      if (error != null) {
        _fieldErrors[tag] = error;
        isValid = false;
      }
    }

    notifyListeners();
    return isValid;
  }

  /// Validate a specific field
  bool validateField(String tag) {
    final model = _fieldModels[tag];
    if (model == null) return true;

    final error = _validateField(model);

    if (error != null) {
      _fieldErrors[tag] = error;
      notifyListeners();
      return false;
    }

    _fieldErrors.remove(tag);
    notifyListeners();
    return true;
  }

  /// Get validation error for a field
  String? getFieldError(String tag) => _fieldErrors[tag];

  /// Check if form is valid
  bool isValid() => validate();

  /// Get form button by tag
  HZFFormButton? getButtonByTag(String tag) => _formButtons[tag];

  /// Set button loading state
  void setButtonLoading(String tag, bool loading) {
    final button = getButtonByTag(tag);
    if (button != null) {
      button.isLoading.value = loading;
    }
  }

  // Private methods

  /// Validate a single field
  String? _validateField(HZFFormFieldModel model) {
    final value = _formValues[model.tag];

    // Required field validation
    if (model.required == true && (value == null || value.toString().isEmpty)) {
      return model.errorMessage ?? 'This field is required';
    }

    // Skip further validation if value is empty and not required
    if (value == null || value.toString().isEmpty) {
      return null;
    }

    // RegEx validation
    if (model.validateRegEx != null && value is String) {
      if (!model.validateRegEx!.hasMatch(value)) {
        return model.errorMessage ?? 'Invalid format';
      }
    }

    // Custom validator
    if (model.customValidator != null) {
      return model.customValidator!(value);
    }

    return null;
  }

  /// Update fields that depend on a changed field
  void _updateDependentFields(String tag) {
    final dependents = _dependencyGraph[tag];
    if (dependents == null || dependents.isEmpty) return;

    for (final dependentTag in dependents) {
      final model = _fieldModels[dependentTag];
      if (model == null) continue;

      // Skip non-visible fields
      if (!isFieldVisible(dependentTag)) continue;

      // Update field if it has a dependency update handler
      if (model.onDependencyChanged != null) {
        model.onDependencyChanged!(tag, _formValues[tag]);
      }
    }
  }

  /// Notify field-specific listeners
  void _notifyFieldListeners(String tag, dynamic value) {
    final listeners = _fieldListeners[tag];
    if (listeners == null || listeners.isEmpty) return;

    for (final listener in listeners) {
      listener(value);
    }
  }

  @override
  void dispose() {
    _fieldListeners.clear();
    _visibilityConditions.clear();
    _dependencyGraph.clear();
    _formButtons.clear();
    super.dispose();
  }
}
