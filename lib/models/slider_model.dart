// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

import '../core/enums.dart';
import 'field_model.dart';

class HZFFormSliderModel extends HZFFormFieldModel {
  /// Minimum value
  final double min;

  /// Maximum value
  final double max;

  /// Default value
  final double? defaultValue;

  /// Number of divisions
  final int? divisions;

  /// Decimal precision for display and value
  final int decimalPrecision;

  /// Show value display
  final bool showValue;

  /// Show min/max labels
  final bool showMinMaxLabels;

  /// Custom min label
  final String? minLabel;

  /// Custom max label
  final String? maxLabel;

  /// Value prefix (e.g., "$")
  final String? valuePrefix;

  /// Value suffix (e.g., "kg")
  final String? valueSuffix;

  /// Custom value formatter
  final String Function(double)? formatValue;

  /// Active track color
  final Color? activeColor;

  /// Inactive track color
  final Color? inactiveColor;

  /// Thumb color
  final Color? thumbColor;

  /// Value text style
  final TextStyle? valueTextStyle;

  /// Min/max label text style
  final TextStyle? minMaxLabelStyle;

  /// Value prefix style
  final TextStyle? valuePrefixStyle;

  /// Value suffix style
  final TextStyle? valueSuffixStyle;

  /// Callback when value changes
  final void Function(double)? onChanged;

  /// Callback when user starts changing value
  final void Function(double)? onChangeStart;

  /// Callback when user stops changing value
  final void Function(double)? onChangeEnd;

  HZFFormSliderModel({
    required String tag,
    required this.min,
    required this.max,
    this.defaultValue,
    this.divisions,
    this.decimalPrecision = 1,
    this.showValue = true,
    this.showMinMaxLabels = true,
    this.minLabel,
    this.maxLabel,
    this.valuePrefix,
    this.valueSuffix,
    this.formatValue,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.valueTextStyle,
    this.minMaxLabelStyle,
    this.valuePrefixStyle,
    this.valueSuffixStyle,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value, // double
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  })  : assert(min < max, 'Min value must be less than max value'),
        assert(
            defaultValue == null ||
                (defaultValue >= min && defaultValue <= max),
            'Default value must be between min and max'),
        super(
          tag: tag,
          type: HZFFormFieldTypeEnum.slider,
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
