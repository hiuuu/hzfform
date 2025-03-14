// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormTimePickerModel extends HZFFormFieldModel {
  /// Hint text
  final String? hint;

  /// Time format
  final HZFTimeFormat? timeFormat;

  /// Initial entry mode
  final TimePickerEntryMode? initialEntryMode;

  /// Use theme data
  final bool useThemeData;

  /// Time picker theme
  final TimePickerThemeData? timePickerTheme;

  /// Color scheme
  final ColorScheme? colorScheme;

  /// Callback when time is selected
  final Function(TimeOfDay)? onTimeSelected;

  HZFFormTimePickerModel({
    required String tag,
    this.hint,
    this.timeFormat = HZFTimeFormat.amPmUppercase,
    this.initialEntryMode,
    this.useThemeData = false,
    this.timePickerTheme,
    this.colorScheme,
    this.onTimeSelected,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    TimeOfDay? value,
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  }) : super(
          tag: tag,
          type: HZFFormFieldTypeEnum.timePicker,
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
