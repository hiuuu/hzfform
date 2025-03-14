// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormTextModel extends HZFFormFieldModel {
  /// Hint text
  final String? hint;

  /// Label text (floating)
  final String? labelText;

  /// Prefix text inside field
  final String? prefixText;

  /// Suffix text inside field
  final String? suffixText;

  /// Maximum number of lines
  final int? maxLines;

  /// Minimum number of lines
  final int? minLines;

  /// Maximum length
  final int? maxLength;

  /// Show character counter
  final bool showCounter;

  /// Counter position
  final CounterPosition counterPosition;

  /// Custom counter format
  final String Function(int current, int max)? counterFormat;

  /// Show clear button
  final bool showClearButton;

  /// Enable speech to text
  final bool enableSpeechToText;

  /// Text is obscured (password)
  final bool? obscureText;

  /// Text capitalization
  final TextCapitalization? textCapitalization;

  /// Keyboard type
  final TextInputType? keyboardType;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Custom border
  final InputBorder? border;

  /// Enabled border
  final InputBorder? enabledBorder;

  /// Focused border
  final InputBorder? focusedBorder;

  /// Error border
  final InputBorder? errorBorder;

  /// Disabled border
  final InputBorder? disabledBorder;

  /// Field is filled
  final bool? filled;

  /// Fill color
  final Color? fillColor;

  /// Content padding
  final EdgeInsetsGeometry? contentPadding;

  /// Text style
  final TextStyle? textStyle;

  /// Text alignment
  final TextAlign? textAlign;

  /// Text direction
  final TextDirection? textDirection;

  /// Cursor color
  final Color? cursorColor;

  /// Show cursor
  final bool? showCursor;

  /// Autofill hints
  final List<String>? autofillHints;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Mask controller (to access masked value)
  final TextEditingController? maskController;

  /// Mask pattern (e.g., "###.###.###-##")
  final String? maskPattern;

  /// Mask filter (e.g., {"#": RegExp(r'[0-9]')})
  final Map<String, RegExp>? maskFilter;

  /// Predefined mask type
  final MaskType? maskType;

  /// On text changed callback
  final Function(String)? onChanged;

  /// On field submitted callback
  final Function(String)? onFieldSubmitted;

  HZFFormTextModel({
    required String tag,
    this.hint,
    this.labelText,
    this.prefixText,
    this.suffixText,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.showCounter = false,
    this.counterPosition = CounterPosition.inline,
    this.counterFormat,
    this.showClearButton = false,
    this.enableSpeechToText = false,
    this.obscureText = false,
    this.textCapitalization,
    this.keyboardType,
    this.textInputAction,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.disabledBorder,
    this.filled,
    this.fillColor,
    this.contentPadding,
    this.textStyle,
    this.textAlign,
    this.textDirection,
    this.cursorColor,
    this.showCursor,
    this.autofillHints,
    this.inputFormatters,
    this.maskController,
    this.maskPattern,
    this.maskFilter,
    this.maskType,
    this.onChanged,
    this.onFieldSubmitted,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value, // String
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  }) : super(
          tag: tag,
          type: HZFFormFieldTypeEnum.text,
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

// Email field with numeric keypad
final emailField = HZFFormTextModel(
  tag: 'email',
  title: 'Email',
  hint: 'name@example.com',
  keyboardType: TextInputType.emailAddress,
  // Override formatter to allow numeric entry
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z@\._-]')),
  ],
  // Validate as email despite numeric input
  validateRegEx: RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
);

// Phone number with mask
final phoneField = HZFFormTextModel(
  tag: 'phone',
  title: 'Phone Number',
  hint: '(555) 123-4567',
  maskType: MaskType.phone,
  keyboardType: TextInputType.phone,
  showClearButton: true,
);

// Multiline note with counter
final noteField = HZFFormTextModel(
  tag: 'note',
  title: 'Additional Notes',
  hint: 'Enter your comments here...',
  maxLines: 5,
  minLines: 3,
  maxLength: 500,
  showCounter: true,
  counterPosition: CounterPosition.below,
);

// Speech-enabled search field
final searchField = HZFFormTextModel(
  tag: 'search',
  hint: 'Search or speak...',
  enableSpeechToText: true,
  prefixWidget: Icon(Icons.search),
  showClearButton: true,
);

// Custom mask for ID number
final idField = HZFFormTextModel(
  tag: 'id',
  title: 'ID Number',
  maskPattern: '###.###.###-##',
  maskFilter: {'#': RegExp(r'[0-9]')},
);

*/
