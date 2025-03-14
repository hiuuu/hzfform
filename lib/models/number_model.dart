// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormNumberModel extends HZFFormFieldModel {
  /// Hint text
  final String? hint;

  /// Allow decimal numbers
  final bool? allowDecimal;

  /// Allow negative numbers
  final bool? allowNegative;

  /// Maximum decimal places
  final int? decimalPlaces;

  /// Minimum value
  final num? minValue;

  /// Maximum value
  final num? maxValue;

  /// Use thousand separator
  final bool? useThousandSeparator;

  /// Thousand separator character
  final String? thousandSeparator;

  /// Decimal separator character
  final String? decimalSeparator;

  /// Display format
  final NumberDisplayFormat? displayFormat;

  /// Currency symbol (for currency format)
  final String? currencySymbol;

  /// Custom text input formatter
  final TextInputFormatter? customFormatter;

  HZFFormNumberModel({
    required String tag,
    this.hint,
    this.allowDecimal = true,
    this.allowNegative = false,
    this.decimalPlaces,
    this.minValue,
    this.maxValue,
    this.useThousandSeparator = false,
    this.thousandSeparator = ',',
    this.decimalSeparator = '.',
    this.displayFormat,
    this.currencySymbol = '\$',
    this.customFormatter,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value, // num (int or double)
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  }) : super(
          tag: tag,
          type: HZFFormFieldTypeEnum.number,
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

// Currency field
final priceField = HZFFormNumberModel(
  tag: 'price',
  title: 'Price',
  displayFormat: NumberDisplayFormat.currency,
  currencySymbol: '$',
  decimalPlaces: 2,
  minValue: 0,
);

// Percentage field
final discountField = HZFFormNumberModel(
  tag: 'discount',
  title: 'Discount',
  displayFormat: NumberDisplayFormat.percentage,
  decimalPlaces: 1,
  maxValue: 1.0, // 100%
);

// European format number
final europeanNumberField = HZFFormNumberModel(
  tag: 'amount',
  title: 'Amount',
  useThousandSeparator: true,
  thousandSeparator: '.',
  decimalSeparator: ',',
  decimalPlaces: 2,
);

*/