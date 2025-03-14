// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormRadioChipsGroupModel extends HZFFormFieldModel {
  /// Available options
  final List<HZFFormRadioChipDataModel> items;

  /// Background color for unselected chips
  final Color? backgroundColor;

  /// Color for selected chips
  final Color? selectedColor;

  /// Text color
  final Color? textColor;

  /// Selected text color
  final Color? selectedTextColor;

  HZFFormRadioChipsGroupModel({
    required String tag,
    required this.items,
    this.backgroundColor,
    this.selectedColor,
    this.textColor,
    this.selectedTextColor,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value, // String (item id)
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  }) : super(
          tag: tag,
          type: HZFFormFieldTypeEnum.radioChips,
          title: title,
          errorMessage: errorMessage,
          helpMessage: helpMessage,
          prefixWidget: prefixWidget,
          postfixWidget: postfixWidget,
          required: required,
          showTitle: showTitle,
          value: value,
          validateRegEx: validateRegEx,
          weight: weight,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          onTap: onTap,
          status: status,
          enableReadOnly: enableReadOnly,
        );
}

/// Data model for radio chip item
class HZFFormRadioChipDataModel {
  /// Unique identifier
  final String id;

  /// Display text
  final String label;

  /// Optional icon
  final IconData? icon;

  const HZFFormRadioChipDataModel({
    required this.id,
    required this.label,
    this.icon,
  });
}
