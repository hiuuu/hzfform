// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormSpinnerModel extends HZFFormFieldModel {
  /// Available dropdown items
  final List<SpinnerDataModel> items;

  /// Placeholder text when no selection
  final String? hint;

  /// Selection change callback
  final ValueChanged<SpinnerDataModel?>? onChange;

  HZFFormSpinnerModel({
    required String tag,
    required this.items,
    this.hint,
    this.onChange,

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
          type: HZFFormFieldTypeEnum.spinner,
          title: title,
          errorMessage: errorMessage,
          helpMessage: helpMessage,
          prefixWidget: prefixWidget,
          postfixWidget: postfixWidget ?? const Icon(Icons.arrow_drop_down),
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

class SpinnerDataModel {
  String name;
  int id;
  bool? isSelected;
  dynamic data;

  SpinnerDataModel(
      {required this.name, required this.id, this.data, bool? isSelected})
      : isSelected = isSelected ?? false;
}
