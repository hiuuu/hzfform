// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

import '../core/enums.dart';
import 'field_model.dart';

class HZFFormRadioGroupModel extends HZFFormFieldModel {
  /// Available items
  final List<HZFFormRadioItem> items;

  /// Active color for selected radio
  final Color? activeColor;

  /// Compact display mode
  final bool dense;

  /// Callback when item is selected
  final Function(String)? onItemSelected;

  HZFFormRadioGroupModel({
    required String tag,
    required this.items,
    this.activeColor,
    this.dense = false,
    this.onItemSelected,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    String? value,
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  }) : super(
          tag: tag,
          type: HZFFormFieldTypeEnum.radioGroup,
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

/// Item for radio group
class HZFFormRadioItem {
  /// Unique identifier
  final String id;

  /// Display text
  final String label;

  /// Optional subtitle
  final String? subtitle;

  /// Optional icon
  final IconData? icon;

  /// Whether item is disabled
  final bool disabled;

  const HZFFormRadioItem({
    required this.id,
    required this.label,
    this.subtitle,
    this.icon,
    this.disabled = false,
  });
}
