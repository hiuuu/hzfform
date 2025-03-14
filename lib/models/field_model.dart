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
  int? weight;
  FocusNode? focusNode;
  FocusNode? nextFocusNode;
  dynamic value;
  bool? enableReadOnly;
  VoidCallback? onTap;

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
    this.weight,
    this.focusNode,
    this.nextFocusNode,
    this.onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  })  : status = status ?? HZFFormFieldStatusEnum.normal,
        enableReadOnly = enableReadOnly ?? false;
}

abstract class HZFFormFieldCallBack {
  bool isValid();
  dynamic getValue();
}
