// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormTimePickerModel extends HZFFormFieldModel {
  /// Placeholder text when no time selected
  final String? hint;

  /// Default time value
  final TimeOfDay? initialTime;

  /// Time picker display type (spinner/dial/etc)
  final HZFFormTimePickerType? timePickerType;

  HZFFormTimePickerModel({
    required String tag,
    this.hint,
    this.initialTime,
    this.timePickerType,

    // Parent class props
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
          type: HZFFormFieldTypeEnum.timePicker,
          title: title,
          errorMessage: errorMessage,
          helpMessage: helpMessage,
          prefixWidget: prefixWidget ?? const Icon(Icons.access_time),
          postfixWidget: postfixWidget,
          required: required,
          showTitle: showTitle,
          value: value ?? initialTime,
          validateRegEx: validateRegEx,
          weight: weight,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          onTap: onTap,
          status: status,
          enableReadOnly: enableReadOnly,
        );
}

class TimeDataModel {
  String displayTime;
  int hour;
  int minute;
  TimeDataModel(
      {required this.displayTime, required this.hour, required this.minute});
}
