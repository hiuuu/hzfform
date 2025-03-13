// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormBankCardModel extends HZFFormFieldModel {
  /// Hint text to display when field is empty
  final String? hint;

  /// Card number formatting pattern
  final String? cardNumberPattern;

  /// Maximum card number length
  final int maxLength;

  /// Card type detection callback
  final Function(String)? onCardTypeDetected;

  /// Whether to show card type icon
  final bool showCardTypeIcon;

  HZFFormBankCardModel({
    required String tag,
    this.hint,
    this.cardNumberPattern = 'xxxx xxxx xxxx xxxx',
    this.maxLength = 19, // 16 digits + 3 spaces
    this.onCardTypeDetected,
    this.showCardTypeIcon = true,

    // Parent class properties - passed through to super
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
          type: HZFFormFieldTypeEnum.bankCard,
          title: title,
          errorMessage: errorMessage,
          helpMessage: helpMessage,
          prefixWidget: prefixWidget,
          postfixWidget: postfixWidget,
          required: required,
          showTitle: showTitle,
          value: value,
          validateRegEx: validateRegEx ?? RegExp(r'^[0-9]{16,19}$'),
          weight: weight,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          onTap: onTap,
          status: status,
          enableReadOnly: enableReadOnly,
        );
}
