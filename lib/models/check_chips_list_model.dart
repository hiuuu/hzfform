// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'field_model.dart';
import 'radio_chips_group_model.dart';
import '../core/enums.dart';

class HZFFormCheckChipsListModel extends HZFFormFieldModel {
  /// Available chip options
  final List<HZFFormCheckChipsDataModel> items;

  /// Multiple selection change callback
  final ValueChanged<List<HZFFormCheckChipsDataModel>>? onSelectionChanged;

  /// Chip layout direction
  final Axis direction;

  /// Spacing between chips
  final double spacing;

  /// Run spacing for wrapped chips
  final double runSpacing;

  /// Allow wrapping to multiple lines
  final bool wrap;

  /// Chip style customization
  final HZFChipStyle? chipStyle;

  /// Scrollable container
  final bool scrollable;

  /// Maximum height when scrollable
  final double? maxHeight;

  /// Minimum selections required
  final int? minSelections;

  /// Maximum selections allowed
  final int? maxSelections;

  HZFFormCheckChipsListModel({
    required String tag,
    required this.items,
    this.onSelectionChanged,
    this.direction = Axis.horizontal,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.wrap = true,
    this.chipStyle,
    this.scrollable = false,
    this.maxHeight,
    this.minSelections,
    this.maxSelections,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value,
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
          errorMessage: errorMessage ??
              (minSelections != null ? "Select at least $minSelections" : null),
          helpMessage: helpMessage,
          prefixWidget: prefixWidget,
          postfixWidget: postfixWidget,
          required: required ?? (minSelections != null && minSelections > 0),
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

  /// Get currently selected items
  List<HZFFormCheckChipsDataModel> get selectedItems =>
      items.where((item) => item.isSelected).toList();

  /// Check if selection limits are satisfied
  bool isSelectionValid() {
    final selectedCount = selectedItems.length;
    return (minSelections == null || selectedCount >= minSelections!) &&
        (maxSelections == null || selectedCount <= maxSelections!);
  }
}

/// Data model for individual check chip items
class HZFFormCheckChipsDataModel {
  /// Unique identifier
  final String id;

  /// Display text
  final String label;

  /// Optional icon
  final Widget? icon;

  /// Whether chip is selected
  final bool isSelected;

  /// Whether chip is enabled
  final bool isEnabled;

  /// Custom tooltip text
  final String? tooltip;

  /// Additional custom data
  final dynamic data;

  /// Background color when selected
  final Color? selectedColor;

  /// Text color when selected
  final Color? selectedTextColor;

  const HZFFormCheckChipsDataModel({
    required this.id,
    required this.label,
    this.icon,
    this.isSelected = false,
    this.isEnabled = true,
    this.tooltip,
    this.data,
    this.selectedColor,
    this.selectedTextColor,
  });

  /// Create copy with modified selection state
  HZFFormCheckChipsDataModel copyWithSelection(bool selected) {
    return HZFFormCheckChipsDataModel(
      id: id,
      label: label,
      icon: icon,
      isSelected: selected,
      isEnabled: isEnabled,
      tooltip: tooltip,
      data: data,
      selectedColor: selectedColor,
      selectedTextColor: selectedTextColor,
    );
  }
}
