// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormCheckChipsListModel extends HZFFormFieldModel {
  /// Available options
  final List<HZFFormCheckChipDataModel> items;

  /// Background color for unselected chips
  final Color? backgroundColor;

  /// Color for selected chips
  final Color? selectedColor;

  /// Text color
  final Color? textColor;

  /// Selected text color
  final Color? selectedTextColor;

  /// Checkmark color
  final Color? checkmarkColor;

  /// Show checkmark on selected chips
  final bool? showCheckmark;

  /// Max number of selectable items
  final int? maxSelection;

  /// Message when max selection reached
  final String? maxSelectionMessage;

  /// Show count of selected items
  final bool? showSelectedCount;

  /// Show search filter
  final bool? showSearchFilter;

  /// Search hint text
  final String? searchHint;

  HZFFormCheckChipsListModel({
    required String tag,
    required this.items,
    this.backgroundColor,
    this.selectedColor,
    this.textColor,
    this.selectedTextColor,
    this.checkmarkColor,
    this.showCheckmark,
    this.maxSelection,
    this.maxSelectionMessage,
    this.showSelectedCount = true,
    this.showSearchFilter = false,
    this.searchHint,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value, // List<String> (item ids)
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  }) : super(
          tag: tag,
          type: HZFFormFieldTypeEnum.checkChips,
          title: title,
          errorMessage: errorMessage,
          helpMessage: helpMessage,
          prefixWidget: prefixWidget,
          postfixWidget: postfixWidget,
          required: required,
          showTitle: showTitle,
          value: value ?? <String>[],
          validateRegEx: validateRegEx,
          weight: weight,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          onTap: onTap,
          status: status,
          enableReadOnly: enableReadOnly,
        );
}

/// Data model for check chip item
class HZFFormCheckChipDataModel {
  /// Unique identifier
  final String id;

  /// Display text
  final String label;

  /// Optional icon
  final IconData? icon;

  const HZFFormCheckChipDataModel({
    required this.id,
    required this.label,
    this.icon,
  });
}


/*
USAGE

HZFFormCheckChipsListModel(
  tag: 'interests',
  title: 'Select Your Interests',
  items: [
    HZFFormCheckChipDataModel(id: 'tech', label: 'Technology', icon: Icons.computer),
    HZFFormCheckChipDataModel(id: 'sports', label: 'Sports', icon: Icons.sports_soccer),
    HZFFormCheckChipDataModel(id: 'food', label: 'Cooking', icon: Icons.restaurant),
  ],
  maxSelection: 2,
  maxSelectionMessage: 'You can select up to 2 interests',
  showSearchFilter: true,
)
*/