// ignore_for_file: use_super_parameters

import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import '../core/enums.dart';
import 'field_model.dart';

class HZFFormSignatureModel extends HZFFormFieldModel {
  /// Signature controller - non-final to allow updates
  SignatureController signatureController;

  /// Canvas height
  final double? height;

  /// Background color
  final Color? backgroundColor;

  /// Show hint text
  final bool showHint;

  /// Hint text
  final String? hintText;

  /// Show stroke width selector
  final bool showStrokeWidthSelector;

  /// Show color selector
  final bool showColorSelector;

  /// Available colors for selection
  final List<Color>? availableColors;

  /// Clear button text
  final String? clearButtonText;

  /// Clear icon
  final IconData? clearIcon;

  /// Done icon
  final IconData? doneIcon;

  /// Done button color
  final Color? doneButtonColor;

  /// Edit icon
  final IconData? editIcon;

  /// Stroke width changed callback
  final Function(double)? onStrokeWidthChanged;

  /// Color changed callback
  final Function(Color)? onColorChanged;

  /// Signature captured callback
  final Function(Uint8List)? onSignatureCaptured;

  HZFFormSignatureModel({
    required String tag,
    SignatureController? controller,
    this.height,
    this.backgroundColor,
    Color? penColor,
    double? strokeWidth,
    this.showHint = true,
    this.hintText,
    this.showStrokeWidthSelector = true,
    this.showColorSelector = true,
    this.availableColors,
    this.clearButtonText,
    this.clearIcon,
    this.doneIcon,
    this.doneButtonColor,
    this.editIcon,
    this.onStrokeWidthChanged,
    this.onColorChanged,
    this.onSignatureCaptured,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value, // Uint8List
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  })  : signatureController = controller ??
            SignatureController(
              penStrokeWidth: strokeWidth ?? 3.0,
              penColor: penColor ?? Colors.black,
            ),
        super(
          tag: tag,
          type: HZFFormFieldTypeEnum.signaturePicker,
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

// Basic signature field
final signatureField = HZFFormSignatureModel(
  tag: 'signature',
  title: 'Signature',
  required: true,
  height: 180,
  hintText: 'Sign your name here',
  onSignatureCaptured: (data) {
    // Save signature to server or local storage
    documentService.saveSignature(data);
  },
);

// Custom styled signature
final coloredSignature = HZFFormSignatureModel(
  tag: 'coloredSignature',
  title: 'Colored Signature',
  backgroundColor: Colors.grey[100],
  penColor: Colors.blue,
  strokeWidth: 4.0,
  availableColors: [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.black,
  ],
  doneButtonColor: Colors.green,
);

*/