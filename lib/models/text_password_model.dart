// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormPasswordModel extends HZFFormFieldModel {
  /// Maximum character length
  final int? maxLength;

  /// Minimum character length for validation
  final int? minLength;

  /// Placeholder text when empty
  final String? hint;

  HZFFormPasswordModel({
    required String tag,
    this.maxLength,
    this.minLength = 8,
    this.hint,

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
          type: HZFFormFieldTypeEnum.password,
          title: title,
          errorMessage: errorMessage ??
              "Password must be at least ${minLength ?? 8} characters",
          helpMessage: helpMessage,
          prefixWidget: prefixWidget ?? const Icon(Icons.lock),
          postfixWidget: postfixWidget ?? const Icon(Icons.visibility_off),
          required: required ?? true,
          showTitle: showTitle,
          value: value,
          validateRegEx: validateRegEx ??
              RegExp(
                  '^.{${minLength ?? 8},}${maxLength != null ? '{,$maxLength}' : ''}'),
          weight: weight,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          onTap: onTap,
          status: status,
          enableReadOnly: enableReadOnly,
        );
}
