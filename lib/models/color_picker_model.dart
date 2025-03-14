// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

import '../core/enums.dart';
import 'field_model.dart';

class HZFFormColorPickerModel extends HZFFormFieldModel {
  /// Default color
  final Color? defaultColor;

  /// Color picker mode
  final ColorPickerMode pickerMode;

  /// Enable opacity selection
  final bool enableOpacity;

  /// Show hex value in preview
  final bool showHexValue;

  /// Show hex input in picker
  final bool showHexInput;

  /// Show predefined colors
  final bool showPredefinedColors;

  /// Predefined colors
  final List<Color> predefinedColors;

  /// Predefined color size
  final double? predefinedColorSize;

  /// Predefined color border radius
  final double? predefinedColorBorderRadius;

  /// Show picker button
  final bool showPickerButton;

  /// Picker button text
  final String? pickerButtonText;

  /// Picker button icon
  final IconData? pickerButtonIcon;

  /// Preview height
  final double? previewHeight;

  /// Preview border radius
  final double? previewBorderRadius;

  /// Show shadow in preview
  final bool showShadow;

  /// Picker dialog title
  final String? pickerTitle;

  /// Confirm button text
  final String? confirmText;

  /// Cancel button text
  final String? cancelText;

  /// Color selected callback
  final Function(Color)? onColorSelected;

  HZFFormColorPickerModel({
    required String tag,
    this.defaultColor,
    this.pickerMode = ColorPickerMode.material,
    this.enableOpacity = false,
    this.showHexValue = true,
    this.showHexInput = true,
    this.showPredefinedColors = false,
    this.predefinedColors = const [],
    this.predefinedColorSize,
    this.predefinedColorBorderRadius,
    this.showPickerButton = true,
    this.pickerButtonText,
    this.pickerButtonIcon,
    this.previewHeight,
    this.previewBorderRadius,
    this.showShadow = true,
    this.pickerTitle,
    this.confirmText,
    this.cancelText,
    this.onColorSelected,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value, // Color or int
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  }) : super(
          tag: tag,
          type: HZFFormFieldTypeEnum.colorPicker,
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


/*
USAGE:

// Basic color picker
final brandColorField = HZFFormColorPickerModel(
  tag: 'brandColor',
  title: 'Brand Color',
  defaultColor: Colors.blue,
  pickerMode: ColorPickerMode.material,
  showHexValue: true,
);

// RGB slider picker with opacity
final backgroundColorField = HZFFormColorPickerModel(
  tag: 'backgroundColor',
  title: 'Background Color',
  pickerMode: ColorPickerMode.rgb,
  enableOpacity: true,
  showHexInput: true,
  onColorSelected: (color) => updateTheme(color),
);

// Predefined color palette
final themeColorField = HZFFormColorPickerModel(
  tag: 'themeColor',
  title: 'Theme Color',
  showPredefinedColors: true,
  predefinedColors: [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.teal,
  ],
  showPickerButton: false,
);
*/