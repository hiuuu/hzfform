import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/enums.dart';
import '../models/bank_card_filed_model.dart';
import '../models/field_model.dart';
import '../widgets/controller.dart';
import 'hzf_field_builder.dart';

class BankCardFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final cardModel = model as HZFFormBankCardModel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card number field with formatting
        TextFormField(
          initialValue: cardModel.value?.number,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _CreditCardFormatter(),
          ],
          maxLength: 19, // 16 digits + 3 spaces
          decoration: InputDecoration(
            hintText: cardModel.hint ?? 'Card number',
            prefixIcon: cardModel.prefixWidget ?? const Icon(Icons.credit_card),
            suffixIcon: _buildCardTypeIcon(cardModel.detectedCardType),
            border: const OutlineInputBorder(),
            counterText: '', // Hide character counter
          ),
          enabled: cardModel.enableReadOnly != true,
          focusNode: cardModel.focusNode,
          onChanged: (value) {
            final cardType = _detectCardType(value.replaceAll(' ', ''));

            // Update card info with new number and detected type
            final updatedCard = HZFBankCardInfo(
              number: value,
              expiryMonth: cardModel.value?.expiryMonth,
              expiryYear: cardModel.value?.expiryYear,
              cvv: cardModel.value?.cvv,
              cardHolderName: cardModel.value?.cardHolderName,
              cardType: cardType,
            );

            controller.updateFieldValue(cardModel.tag, updatedCard);

            // Move to expiry field when card number is complete
            if (value.replaceAll(' ', '').length == 16 &&
                cardModel.expiryFocus != null) {
              FocusScope.of(context).requestFocus(cardModel.expiryFocus);
            }
          },
        ),

        const SizedBox(height: 12),

        // Row for expiry and CVV
        Row(
          children: [
            // Expiry date field
            Expanded(
              flex: 1,
              child: TextFormField(
                initialValue: _formatExpiry(
                    cardModel.value?.expiryMonth, cardModel.value?.expiryYear),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _ExpiryDateFormatter(),
                ],
                maxLength: 5, // MM/YY
                decoration: InputDecoration(
                  hintText: cardModel.expiryHint ?? 'MM/YY',
                  prefixIcon: const Icon(Icons.date_range),
                  border: const OutlineInputBorder(),
                  counterText: '',
                ),
                enabled: cardModel.enableReadOnly != true,
                focusNode: cardModel.expiryFocus,
                onChanged: (value) {
                  // Parse MM/YY format
                  final parts = value.split('/');
                  String? month, year;

                  if (parts.isNotEmpty) month = parts[0];
                  if (parts.length > 1) year = parts[1];

                  // Update card info with new expiry
                  final updatedCard = HZFBankCardInfo(
                    number: cardModel.value?.number,
                    expiryMonth: month,
                    expiryYear: year,
                    cvv: cardModel.value?.cvv,
                    cardHolderName: cardModel.value?.cardHolderName,
                    cardType: cardModel.value?.cardType,
                  );

                  controller.updateFieldValue(cardModel.tag, updatedCard);

                  // Move to CVV when expiry is complete
                  if (value.length == 5 && cardModel.cvvFocus != null) {
                    FocusScope.of(context).requestFocus(cardModel.cvvFocus);
                  }
                },
              ),
            ),

            const SizedBox(width: 12),

            // CVV field
            Expanded(
              flex: 1,
              child: TextFormField(
                initialValue: cardModel.value?.cvv,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(
                      cardModel.value?.cardType == HZFCardType.amex ? 4 : 3),
                ],
                maxLength:
                    cardModel.value?.cardType == HZFCardType.amex ? 4 : 3,
                decoration: InputDecoration(
                  hintText: cardModel.cvvHint ?? 'CVV',
                  prefixIcon: const Icon(Icons.security),
                  border: const OutlineInputBorder(),
                  counterText: '',
                ),
                obscureText: !cardModel.showCvv,
                enabled: cardModel.enableReadOnly != true,
                focusNode: cardModel.cvvFocus,
                onChanged: (value) {
                  // Update card info with new CVV
                  final updatedCard = HZFBankCardInfo(
                    number: cardModel.value?.number,
                    expiryMonth: cardModel.value?.expiryMonth,
                    expiryYear: cardModel.value?.expiryYear,
                    cvv: value,
                    cardHolderName: cardModel.value?.cardHolderName,
                    cardType: cardModel.value?.cardType,
                  );

                  controller.updateFieldValue(cardModel.tag, updatedCard);

                  // Move to cardholder name when CVV is complete
                  final isCvvComplete =
                      cardModel.value?.cardType == HZFCardType.amex
                          ? value.length == 4
                          : value.length == 3;

                  if (isCvvComplete && cardModel.nameFocus != null) {
                    FocusScope.of(context).requestFocus(cardModel.nameFocus);
                  }
                },
              ),
            ),
          ],
        ),

        if (cardModel.showCardholderName) ...[
          const SizedBox(height: 12),

          // Cardholder name field
          TextFormField(
            initialValue: cardModel.value?.cardHolderName,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: cardModel.nameHint ?? 'CARDHOLDER NAME',
              prefixIcon: const Icon(Icons.person),
              border: const OutlineInputBorder(),
            ),
            style: const TextStyle(letterSpacing: 1.2),
            enabled: cardModel.enableReadOnly != true,
            focusNode: cardModel.nameFocus,
            onChanged: (value) {
              // Update card info with new name
              final updatedCard = HZFBankCardInfo(
                number: cardModel.value?.number,
                expiryMonth: cardModel.value?.expiryMonth,
                expiryYear: cardModel.value?.expiryYear,
                cvv: cardModel.value?.cvv,
                cardHolderName: value,
                cardType: cardModel.value?.cardType,
              );

              controller.updateFieldValue(cardModel.tag, updatedCard);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildCardTypeIcon(HZFCardType? cardType) {
    if (cardType == null) return const SizedBox.shrink();

    IconData iconData;
    Color iconColor;

    switch (cardType) {
      case HZFCardType.visa:
        iconData = Icons.credit_card;
        iconColor = Colors.blue;
        break;
      case HZFCardType.mastercard:
        iconData = Icons.credit_card;
        iconColor = Colors.deepOrange;
        break;
      case HZFCardType.amex:
        iconData = Icons.credit_card;
        iconColor = Colors.indigo;
        break;
      case HZFCardType.discover:
        iconData = Icons.credit_card;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.credit_card;
        iconColor = Colors.grey;
    }

    return Icon(iconData, color: iconColor);
  }

  HZFCardType? _detectCardType(String cardNumber) {
    if (cardNumber.isEmpty) return null;

    // Visa: Starts with 4
    if (cardNumber.startsWith('4')) {
      return HZFCardType.visa;
    }

    // Mastercard: Starts with 51-55 or 2221-2720
    if ((cardNumber.startsWith('5') &&
            int.tryParse(cardNumber.substring(1, 2)) != null &&
            int.parse(cardNumber.substring(1, 2)) >= 1 &&
            int.parse(cardNumber.substring(1, 2)) <= 5) ||
        (cardNumber.length >= 4 &&
            int.tryParse(cardNumber.substring(0, 4)) != null &&
            int.parse(cardNumber.substring(0, 4)) >= 2221 &&
            int.parse(cardNumber.substring(0, 4)) <= 2720)) {
      return HZFCardType.mastercard;
    }

    // AMEX: Starts with 34 or 37
    if (cardNumber.startsWith('34') || cardNumber.startsWith('37')) {
      return HZFCardType.amex;
    }

    // Discover: Starts with 6011, 622126-622925, 644-649, or 65
    if (cardNumber.startsWith('6011') ||
        (cardNumber.length >= 6 &&
            int.tryParse(cardNumber.substring(0, 6)) != null &&
            int.parse(cardNumber.substring(0, 6)) >= 622126 &&
            int.parse(cardNumber.substring(0, 6)) <= 622925) ||
        (cardNumber.startsWith('64') &&
            cardNumber.length >= 3 &&
            int.tryParse(cardNumber.substring(2, 3)) != null &&
            int.parse(cardNumber.substring(2, 3)) >= 4 &&
            int.parse(cardNumber.substring(2, 3)) <= 9) ||
        cardNumber.startsWith('65')) {
      return HZFCardType.discover;
    }

    return HZFCardType.other;
  }

  String? _formatExpiry(String? month, String? year) {
    if (month == null || year == null) return null;
    return '$month/$year';
  }
}

/// Credit card formatter (XXXX XXXX XXXX XXXX)
class _CreditCardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove spaces
    String text = newValue.text.replaceAll(' ', '');

    // Add spaces every 4 characters
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    final formattedText = buffer.toString();

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(
        offset: formattedText.length,
      ),
    );
  }
}

/// Expiry date formatter (MM/YY)
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove slash
    String text = newValue.text.replaceAll('/', '');

    // Limit month to valid values (01-12)
    if (text.length >= 2) {
      final month = int.tryParse(text.substring(0, 2));
      if (month != null) {
        if (month == 0) {
          text = '01${text.substring(2)}';
        } else if (month > 12) {
          text = '12${text.substring(2)}';
        }
      }
    }

    // Add slash after month
    String formattedText = text;
    if (text.length >= 2) {
      formattedText =
          '${text.substring(0, 2)}/${text.substring(2, text.length)}';
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(
        offset: formattedText.length,
      ),
    );
  }
}
