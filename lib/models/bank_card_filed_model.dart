// ignore_for_file: use_super_parameters

import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormBankCardModel extends HZFFormFieldModel {
  /// Card number hint
  final String? hint;

  /// Expiry date hint
  final String? expiryHint;

  /// CVV hint
  final String? cvvHint;

  /// Cardholder name hint
  final String? nameHint;

  /// Show cardholder name field
  final bool showCardholderName;

  /// Show CVV instead of masking
  final bool showCvv;

  /// Focus nodes for fields
  final FocusNode? expiryFocus;
  final FocusNode? cvvFocus;
  final FocusNode? nameFocus;

  /// Detected card type (read-only)
  HZFCardType? get detectedCardType => value?.cardType;

  HZFFormBankCardModel({
    required String tag,
    this.hint,
    this.expiryHint,
    this.cvvHint,
    this.nameHint,
    this.showCardholderName = true,
    this.showCvv = false,
    this.expiryFocus,
    this.cvvFocus,
    this.nameFocus,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    HZFBankCardInfo? value,
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
          validateRegEx: validateRegEx,
          weight: weight,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          onTap: onTap,
          status: status,
          enableReadOnly: enableReadOnly,
        );
}

class HZFBankCardInfo {
  final String? number;
  final String? expiryMonth;
  final String? expiryYear;
  final String? cvv;
  final String? cardHolderName;
  final HZFCardType? cardType;

  HZFBankCardInfo({
    this.number,
    this.expiryMonth,
    this.expiryYear,
    this.cvv,
    this.cardHolderName,
    this.cardType,
  });

  bool get isValid {
    final hasValidNumber =
        number != null && number!.replaceAll(' ', '').length >= 16;
    final hasValidExpiry = expiryMonth != null &&
        expiryYear != null &&
        expiryMonth!.length == 2 &&
        expiryYear!.length == 2;
    final hasValidCvv = cvv != null &&
        (cardType == HZFCardType.amex ? cvv!.length == 4 : cvv!.length == 3);

    return hasValidNumber && hasValidExpiry && hasValidCvv;
  }

  String? get formattedExpiry {
    if (expiryMonth == null || expiryYear == null) return null;
    return '$expiryMonth/$expiryYear';
  }

  @override
  String toString() =>
      'HZFBankCardInfo(number: ${number != null ? "${number!.substring(0, min(4, number!.length))}..." : "null"}, '
      'expiry: $formattedExpiry, '
      'cvv: ${cvv != null ? "***" : "null"}, '
      'name: $cardHolderName, '
      'type: $cardType)';
}

/*
USAGE:

final cardField = HZFFormBankCardModel(
  tag: 'paymentCard',
  title: 'Payment Method',
  hint: 'Card number',
  expiryHint: 'MM/YY',
  cvvHint: 'CVV',
  nameHint: 'NAME ON CARD',
  required: true,
  showCardholderName: true,
);

*/
