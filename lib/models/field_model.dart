import 'package:flutter/material.dart';
import '../core/enums.dart';

abstract class HZFFormFieldModel {
  HZFFormFieldTypeEnum? type;
  String? title;
  String tag;
  String? errorMessage;
  String? helpMessage;
  Widget? prefixWidget;
  Widget? postfixWidget;
  bool? required;
  bool? showTitle;
  HZFFormFieldStatusEnum status;
  RegExp? validateRegEx;
  dynamic Function(dynamic)? customValidator;
  int? weight;
  FocusNode? focusNode;
  FocusNode? nextFocusNode;
  dynamic value;
  bool? enableReadOnly;
  VoidCallback? onTap;
  dynamic Function(String, dynamic)? onDependencyChanged;

  HZFFormFieldModel({
    this.type,
    required this.tag,
    this.showTitle,
    this.title,
    this.errorMessage,
    this.helpMessage,
    this.prefixWidget,
    this.postfixWidget,
    this.required,
    this.value,
    this.validateRegEx,
    this.customValidator,
    this.weight,
    this.focusNode,
    this.nextFocusNode,
    this.onTap,
    this.onDependencyChanged,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  })  : status = status ?? HZFFormFieldStatusEnum.normal,
        enableReadOnly = enableReadOnly ?? false;
}

abstract class HZFFormFieldCallBack {
  bool isValid();
  dynamic getValue();
}
