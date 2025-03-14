import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/enums.dart';
import '../models/field_model.dart';
import '../models/number_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

class NumberFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final numberModel = model as HZFFormNumberModel;

    return Material(
      type: MaterialType.transparency,
      child: TextFormField(
        initialValue: _formatValueForDisplay(numberModel.value, numberModel),
        keyboardType: TextInputType.numberWithOptions(
          decimal: numberModel.allowDecimal ?? true,
          signed: numberModel.allowNegative ?? false,
        ),
        inputFormatters: _buildInputFormatters(numberModel),
        decoration: InputDecoration(
          hintText: numberModel.hint,
          prefixIcon: numberModel.prefixWidget,
          suffixIcon: numberModel.postfixWidget,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          errorStyle: const TextStyle(height: 0),
        ),
        enabled: numberModel.enableReadOnly != true,
        focusNode: numberModel.focusNode,
        onChanged: (value) {
          // Parse from display format to actual value
          if (value.isEmpty) {
            controller.updateFieldValue(numberModel.tag, null);
            return;
          }

          _updateNumericValue(
              _parseDisplayValue(value, numberModel), numberModel, controller);
        },
        onFieldSubmitted: (_) {
          if (numberModel.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(numberModel.nextFocusNode);
          }
        },
      ),
    );
  }

  List<TextInputFormatter> _buildInputFormatters(HZFFormNumberModel model) {
    final formatters = <TextInputFormatter>[];

    // Format based on display type
    if (model.displayFormat != null) {
      switch (model.displayFormat!) {
        case NumberDisplayFormat.currency:
          formatters.add(_CurrencyInputFormatter(
            symbol: model.currencySymbol ?? '',
            decimalPlaces: model.decimalPlaces ?? 2,
            allowNegative: model.allowNegative ?? false,
          ));
          return formatters; // Currency formatter handles all formatting

        case NumberDisplayFormat.percentage:
          formatters.add(_PercentageInputFormatter(
            decimalPlaces: model.decimalPlaces ?? 0,
            allowNegative: model.allowNegative ?? false,
          ));
          return formatters; // Percentage formatter handles all formatting

        case NumberDisplayFormat.decimal:
        case NumberDisplayFormat.integer:
          // Continue with standard formatters
          break;
      }
    }

    // Basic number filtering
    if (model.allowDecimal == true) {
      // Decimal number formatting
      formatters.add(FilteringTextInputFormatter.allow(
          model.allowNegative == true
              ? RegExp(r'^-?\d*\.?\d*$')
              : RegExp(r'^\d*\.?\d*$')));

      // Decimal precision limit
      if (model.decimalPlaces != null) {
        formatters.add(
            _DecimalTextInputFormatter(decimalRange: model.decimalPlaces!));
      }
    } else {
      // Integer-only formatting
      formatters.add(FilteringTextInputFormatter.allow(
          model.allowNegative == true ? RegExp(r'^-?\d*$') : RegExp(r'^\d*$')));
    }

    // Thousand separator
    if (model.useThousandSeparator == true) {
      formatters.add(_ThousandSeparatorFormatter(
        decimalPlaces: model.decimalPlaces,
        separator: model.thousandSeparator ?? ',',
        decimalSeparator: model.decimalSeparator ?? '.',
      ));
    }

    // Maximum value constraint
    if (model.maxValue != null) {
      formatters.add(_MaxValueFormatter(model.maxValue!));
    }

    // Custom formatter if provided
    if (model.customFormatter != null) {
      formatters.add(model.customFormatter!);
    }

    return formatters;
  }

  String? _formatValueForDisplay(dynamic value, HZFFormNumberModel model) {
    if (value == null) return null;

    num numValue;
    if (value is num) {
      numValue = value;
    } else {
      try {
        numValue = num.parse(value.toString());
      } catch (_) {
        return value.toString();
      }
    }

    if (model.displayFormat != null) {
      switch (model.displayFormat!) {
        case NumberDisplayFormat.currency:
          return _formatCurrency(
            numValue,
            model.decimalPlaces ?? 2,
            model.currencySymbol ?? '\$',
            model.thousandSeparator ?? ',',
            model.decimalSeparator ?? '.',
          );

        case NumberDisplayFormat.percentage:
          return _formatPercentage(
            numValue,
            model.decimalPlaces ?? 0,
            model.thousandSeparator ?? ',',
            model.decimalSeparator ?? '.',
          );

        case NumberDisplayFormat.decimal:
          return _formatDecimal(
            numValue,
            model.decimalPlaces ?? 2,
            model.useThousandSeparator == true,
            model.thousandSeparator ?? ',',
            model.decimalSeparator ?? '.',
          );

        case NumberDisplayFormat.integer:
          return _formatInteger(
            numValue.toInt(),
            model.useThousandSeparator == true,
            model.thousandSeparator ?? ',',
          );
      }
    }

    // Default formatting
    if (model.allowDecimal == true) {
      if (model.decimalPlaces != null) {
        return numValue.toStringAsFixed(model.decimalPlaces!);
      }
      return numValue.toString();
    } else {
      return numValue.toInt().toString();
    }
  }

  String _formatCurrency(
    num value,
    int decimalPlaces,
    String symbol,
    String thousandSeparator,
    String decimalSeparator,
  ) {
    final fixedValue = value.toStringAsFixed(decimalPlaces);
    final parts = fixedValue.split('.');

    String integerPart = parts[0];
    if (integerPart.startsWith('-')) {
      integerPart =
          '-${_addThousandSeparator(integerPart.substring(1), thousandSeparator)}';
    } else {
      integerPart = _addThousandSeparator(integerPart, thousandSeparator);
    }

    if (parts.length > 1) {
      return '$symbol$integerPart$decimalSeparator${parts[1]}';
    }

    return '$symbol$integerPart';
  }

  String _formatPercentage(
    num value,
    int decimalPlaces,
    String thousandSeparator,
    String decimalSeparator,
  ) {
    // Convert to percentage (multiply by 100)
    final percentValue = value * 100;
    final fixedValue = percentValue.toStringAsFixed(decimalPlaces);
    final parts = fixedValue.split('.');

    String integerPart = parts[0];
    if (integerPart.startsWith('-')) {
      integerPart =
          '-${_addThousandSeparator(integerPart.substring(1), thousandSeparator)}';
    } else {
      integerPart = _addThousandSeparator(integerPart, thousandSeparator);
    }

    if (parts.length > 1) {
      return '$integerPart$decimalSeparator${parts[1]}%';
    }

    return '$integerPart%';
  }

  String _formatDecimal(
    num value,
    int decimalPlaces,
    bool useThousandSeparator,
    String thousandSeparator,
    String decimalSeparator,
  ) {
    final fixedValue = value.toStringAsFixed(decimalPlaces);
    final parts = fixedValue.split('.');

    String integerPart = parts[0];
    if (useThousandSeparator) {
      if (integerPart.startsWith('-')) {
        integerPart =
            '-${_addThousandSeparator(integerPart.substring(1), thousandSeparator)}';
      } else {
        integerPart = _addThousandSeparator(integerPart, thousandSeparator);
      }
    }

    if (parts.length > 1) {
      return '$integerPart$decimalSeparator${parts[1]}';
    }

    return integerPart;
  }

  String _formatInteger(
    int value,
    bool useThousandSeparator,
    String thousandSeparator,
  ) {
    String strValue = value.toString();

    if (useThousandSeparator) {
      if (strValue.startsWith('-')) {
        return '-${_addThousandSeparator(strValue.substring(1), thousandSeparator)}';
      } else {
        return _addThousandSeparator(strValue, thousandSeparator);
      }
    }

    return strValue;
  }

  String _addThousandSeparator(String value, String separator) {
    final result = StringBuffer();
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && (value.length - i) % 3 == 0) {
        result.write(separator);
      }
      result.write(value[i]);
    }
    return result.toString();
  }

  String _parseDisplayValue(String displayValue, HZFFormNumberModel model) {
    // Remove formatting characters for parsing
    String parsable = displayValue;

    if (model.displayFormat == NumberDisplayFormat.currency) {
      parsable = parsable.replaceAll(model.currencySymbol ?? '\$', '');
    } else if (model.displayFormat == NumberDisplayFormat.percentage) {
      parsable = parsable.replaceAll('%', '');
      // Convert from percentage to decimal (divide by 100)
      try {
        final parsed =
            num.parse(parsable.replaceAll(model.thousandSeparator ?? ',', ''));
        return (parsed / 100).toString();
      } catch (_) {
        // If parsing fails, return as is
      }
    }

    // Remove thousand separators
    if (model.useThousandSeparator == true || model.displayFormat != null) {
      parsable = parsable.replaceAll(model.thousandSeparator ?? ',', '');
    }

    // Handle different decimal separators
    if (model.decimalSeparator != null && model.decimalSeparator != '.') {
      parsable = parsable.replaceAll(model.decimalSeparator!, '.');
    }

    return parsable;
  }

  void _updateNumericValue(
    String value,
    HZFFormNumberModel model,
    HZFFormController controller,
  ) {
    try {
      if (model.allowDecimal == true) {
        final doubleValue = double.parse(value);
        controller.updateFieldValue(model.tag, doubleValue);
      } else {
        final intValue = int.parse(value);
        controller.updateFieldValue(model.tag, intValue);
      }
    } catch (e) {
      // Invalid number format, keep as string
      controller.updateFieldValue(model.tag, value);
    }
  }
}

/// Currency input formatter
class _CurrencyInputFormatter extends TextInputFormatter {
  final String symbol;
  final int decimalPlaces;
  final bool allowNegative;

  _CurrencyInputFormatter({
    required this.symbol,
    required this.decimalPlaces,
    required this.allowNegative,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove symbol and commas
    String newText = newValue.text.replaceAll(symbol, '').replaceAll(',', '');

    // Handle negative sign
    bool isNegative = false;
    if (allowNegative && newText.startsWith('-')) {
      isNegative = true;
      newText = newText.substring(1);
    } else if (!allowNegative && newText.contains('-')) {
      newText = newText.replaceAll('-', '');
    }

    // Format number with commas and fixed decimal places
    try {
      // Parse the numeric value
      double value = double.parse(newText);

      // Format with fixed decimal places
      String formatted = value.toStringAsFixed(decimalPlaces);

      // Split into integer and decimal parts
      List<String> parts = formatted.split('.');

      // Add thousand separators to integer part
      String integerPart = '';
      String digits = parts[0];

      for (int i = 0; i < digits.length; i++) {
        if (i > 0 && (digits.length - i) % 3 == 0) {
          integerPart += ',';
        }
        integerPart += digits[i];
      }

      // Combine all parts
      String result = symbol;
      if (isNegative) result = '-$result';
      result += integerPart;

      if (parts.length > 1) {
        result += '.${parts[1]}';
      }

      return TextEditingValue(
        text: result,
        selection: TextSelection.collapsed(offset: result.length),
      );
    } catch (_) {
      // If parsing fails, just return with symbol
      if (newText.isEmpty) return TextEditingValue(text: symbol);

      String result = symbol;
      if (isNegative) result = '-$result';
      result += newText;

      return TextEditingValue(
        text: result,
        selection: TextSelection.collapsed(offset: result.length),
      );
    }
  }
}

/// Percentage input formatter
class _PercentageInputFormatter extends TextInputFormatter {
  final int decimalPlaces;
  final bool allowNegative;

  _PercentageInputFormatter({
    required this.decimalPlaces,
    required this.allowNegative,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove percent sign and commas
    String newText = newValue.text.replaceAll('%', '').replaceAll(',', '');

    // Handle negative sign
    bool isNegative = false;
    if (allowNegative && newText.startsWith('-')) {
      isNegative = true;
      newText = newText.substring(1);
    } else if (!allowNegative && newText.contains('-')) {
      newText = newText.replaceAll('-', '');
    }

    // Format number with commas and fixed decimal places
    try {
      // Parse the numeric value
      double value = double.parse(newText);

      // Format with fixed decimal places
      String formatted = value.toStringAsFixed(decimalPlaces);

      // Split into integer and decimal parts
      List<String> parts = formatted.split('.');

      // Add thousand separators to integer part
      String integerPart = '';
      String digits = parts[0];

      for (int i = 0; i < digits.length; i++) {
        if (i > 0 && (digits.length - i) % 3 == 0) {
          integerPart += ',';
        }
        integerPart += digits[i];
      }

      // Combine all parts
      String result = '';
      if (isNegative) result = '-';
      result += integerPart;

      if (parts.length > 1) {
        result += '.${parts[1]}';
      }

      result += '%';

      return TextEditingValue(
        text: result,
        selection: TextSelection.collapsed(offset: result.length),
      );
    } catch (_) {
      // If parsing fails, just return with percent sign
      String result = '';
      if (isNegative) result = '-';
      result += newText;
      if (!newText.endsWith('%')) result += '%';

      return TextEditingValue(
        text: result,
        selection: TextSelection.collapsed(offset: result.length),
      );
    }
  }
}

/// Thousand separator formatter
class _ThousandSeparatorFormatter extends TextInputFormatter {
  final int? decimalPlaces;
  final String separator;
  final String decimalSeparator;

  _ThousandSeparatorFormatter({
    this.decimalPlaces,
    required this.separator,
    required this.decimalSeparator,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove existing separators
    String newText = newValue.text.replaceAll(separator, '');

    // Handle decimal part
    List<String> parts = newText.split(decimalSeparator);
    String integerPart = parts[0];

    // Handle negative sign
    bool isNegative = integerPart.startsWith('-');
    if (isNegative) {
      integerPart = integerPart.substring(1);
    }

    // Add thousand separators
    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger += separator;
      }
      formattedInteger += integerPart[i];
    }

    // Reassemble with decimal part
    String result = isNegative ? '-$formattedInteger' : formattedInteger;
    if (parts.length > 1) {
      String decimalPart = parts[1];

      // Limit decimal places if specified
      if (decimalPlaces != null && decimalPart.length > decimalPlaces!) {
        decimalPart = decimalPart.substring(0, decimalPlaces!);
      }

      result += decimalSeparator + decimalPart;
    }

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

/// Custom formatter for decimal places
class _DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  _DecimalTextInputFormatter({required this.decimalRange});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;

    if (newText.contains('.')) {
      final parts = newText.split('.');
      if (parts.length == 2 && parts[1].length > decimalRange) {
        // Trim to max decimal places
        newText = '${parts[0]}.${parts[1].substring(0, decimalRange)}';
        return TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    }

    return newValue;
  }
}

/// Custom formatter for maximum value
class _MaxValueFormatter extends TextInputFormatter {
  final num maxValue;

  _MaxValueFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    try {
      final numValue = num.parse(newValue.text);
      if (numValue > maxValue) {
        // Return max value
        final maxText = maxValue.toString();
        return TextEditingValue(
          text: maxText,
          selection: TextSelection.collapsed(offset: maxText.length),
        );
      }
    } catch (_) {
      // Not a valid number yet (e.g., just a minus sign)
    }

    return newValue;
  }
}
