// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormRadioChipsGroupModel extends HZFFormFieldModel {
  /// Available chip options
  final List<HZFFormRadioChipsDataModel> items;

  /// Selection change callback
  final ValueChanged<HZFFormRadioChipsDataModel?>? onSelected;

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

  HZFFormRadioChipsGroupModel({
    required String tag,
    required this.items,
    this.onSelected,
    this.direction = Axis.horizontal,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.wrap = true,
    this.chipStyle,
    this.scrollable = false,
    this.maxHeight,

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

/// Data model for individual radio chip items
class HZFFormRadioChipsDataModel {
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

  const HZFFormRadioChipsDataModel({
    required this.id,
    required this.label,
    this.icon,
    this.isSelected = false,
    this.isEnabled = true,
    this.tooltip,
    this.data,
  });

  /// Create selected copy of this chip
  HZFFormRadioChipsDataModel copyWithSelection(bool selected) {
    return HZFFormRadioChipsDataModel(
      id: id,
      label: label,
      icon: icon,
      isSelected: selected,
      isEnabled: isEnabled,
      tooltip: tooltip,
      data: data,
    );
  }
}

/// Styling options for chips
class HZFChipStyle {
  /// Selected background color
  final Color? selectedColor;

  /// Unselected background color
  final Color? backgroundColor;

  /// Selected text color
  final Color? selectedTextColor;

  /// Unselected text color
  final Color? textColor;

  /// Border color
  final Color? borderColor;

  /// Selected border color
  final Color? selectedBorderColor;

  /// Chip shape
  final ShapeBorder? shape;

  /// Padding within chip
  final EdgeInsets? padding;

  /// Text style
  final TextStyle? labelStyle;

  /// Selected text style
  final TextStyle? selectedLabelStyle;

  const HZFChipStyle({
    this.selectedColor,
    this.backgroundColor,
    this.selectedTextColor,
    this.textColor,
    this.borderColor,
    this.selectedBorderColor,
    this.shape,
    this.padding,
    this.labelStyle,
    this.selectedLabelStyle,
  });
}
