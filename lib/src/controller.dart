import 'package:flutter/material.dart';

class HZFormController {
  final Map<String, dynamic> _values = {};
  final Map<String, bool> _validity = {};

  // Get form data
  Map<String, dynamic> get values => Map.unmodifiable(_values);

  // Check if form is valid
  bool get isValid => !_validity.containsValue(false);

  // Set field value
  void setValue(String name, dynamic value) {
    _values[name] = value;
  }

  // Set field validity
  void setValidity(String name, bool isValid) {
    _validity[name] = isValid;
  }

  // Reset form
  void reset() {
    _values.clear();
    _validity.clear();
  }
}
