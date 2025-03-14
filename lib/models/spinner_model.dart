// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormSpinnerModel extends HZFFormFieldModel {
  /// Available items
  final List<HZFFormSpinnerItem> items;

  /// Hint text
  final String? hint;

  /// Dropdown icon
  final Widget? dropdownIcon;

  /// Dropdown background color
  final Color? dropdownColor;

  /// Maximum dropdown menu height
  final double? menuMaxHeight;

  HZFFormSpinnerModel({
    required String tag,
    required this.items,
    this.hint,
    this.dropdownIcon,
    this.dropdownColor,
    this.menuMaxHeight,

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
          type: HZFFormFieldTypeEnum.spinner,
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

/// Item for spinner field
class HZFFormSpinnerItem {
  /// Unique identifier
  final String id;

  /// Display text
  final String label;

  /// Optional icon
  final IconData? icon;

  /// Whether item is disabled
  final bool disabled;

  const HZFFormSpinnerItem({
    required this.id,
    required this.label,
    this.icon,
    this.disabled = false,
  });
}


/*
USAGE:

final countryField = HZFFormSpinnerModel(
  tag: 'country',
  title: 'Country',
  hint: 'Select a country',
  required: true,
  items: [
    HZFFormSpinnerItem(id: 'us', label: 'United States', icon: Icons.flag),
    HZFFormSpinnerItem(id: 'ca', label: 'Canada', icon: Icons.flag),
    HZFFormSpinnerItem(id: 'mx', label: 'Mexico', icon: Icons.flag),
    HZFFormSpinnerItem(id: 'other', label: 'Other (unavailable)', disabled: true),
  ],
);

*/