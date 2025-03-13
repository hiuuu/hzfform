// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormCellModel extends HZFFormFieldModel {
  /// Maximum character length for cell/phone number
  final int? maxLength;

  /// Placeholder text when field is empty
  final String? hint;

  HZFFormCellModel({
    required String tag,
    this.maxLength,
    this.hint,

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
          type: HZFFormFieldTypeEnum.cell,
          title: title,
          errorMessage: errorMessage,
          helpMessage: helpMessage,
          prefixWidget: prefixWidget ?? const Icon(Icons.phone_android),
          postfixWidget: postfixWidget,
          required: required,
          showTitle: showTitle,
          value: value,
          validateRegEx: validateRegEx ?? RegExp(r'^\+?[0-9]{10,15}$'),
          weight: weight,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          onTap: onTap,
          status: status,
          enableReadOnly: enableReadOnly,
        );
}
