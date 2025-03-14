// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

import '../core/enums.dart';
import 'field_model.dart';

class HZFFormQRCodeModel extends HZFFormFieldModel {
  /// QR code mode
  final QRCodeMode mode;

  /// Default data for QR code
  final String? defaultData;

  /// QR code size
  final double? qrSize;

  /// QR code color
  final Color? qrColor;

  /// Error correction level
  final int? errorCorrectionLevel;

  /// Show shadow effect
  final bool showShadow;

  /// Show input field
  final bool showInputField;

  /// Input field hint text
  final String? inputHint;

  /// Allow multiline input
  final bool multilineInput;

  /// Scan button text
  final String? scanButtonText;

  /// Scan button icon
  final IconData? scanIcon;

  /// Scan button color
  final Color? scanButtonColor;

  /// Scanner screen title
  final String? scannerTitle;

  /// Scanner help text
  final String? scanHelpText;

  /// Scanner cutout size
  final double? scanCutoutSize;

  /// Scanner border color
  final Color? scanBorderColor;

  /// Scan error text
  final String? scanErrorText;

  /// Invalid QR code text
  final String? invalidQRText;

  /// Logo image provider
  final ImageProvider? logoImageProvider;

  /// Logo size
  final double? logoSize;

  /// Scan validator function
  final bool Function(String)? scanValidator;

  /// Scan complete callback
  final Function(String)? onScanComplete;

  HZFFormQRCodeModel({
    required String tag,
    this.mode = QRCodeMode.both,
    this.defaultData,
    this.qrSize,
    this.qrColor,
    this.errorCorrectionLevel,
    this.showShadow = true,
    this.showInputField = true,
    this.inputHint,
    this.multilineInput = false,
    this.scanButtonText,
    this.scanIcon,
    this.scanButtonColor,
    this.scannerTitle,
    this.scanHelpText,
    this.scanCutoutSize,
    this.scanBorderColor,
    this.scanErrorText,
    this.invalidQRText,
    this.logoImageProvider,
    this.logoSize,
    this.scanValidator,
    this.onScanComplete,

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
          type: HZFFormFieldTypeEnum.qrCodePicker,
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

final productQrField = HZFFormQRCodeModel(
  tag: 'productQR',
  title: 'Product QR Code',
  mode: QRCodeMode.both,
  qrSize: 220,
  showInputField: true,
  logoImageProvider: AssetImage('assets/logo.png'),
  scanValidator: (code) => code.startsWith('PROD-'),
  onScanComplete: (code) => print('Scanned: $code'),
);


Mobile Scanner Permissions:
For Android, add to AndroidManifest.xml:
<uses-permission android:name="android.permission.CAMERA" />

For iOS, add to Info.plist:
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan QR codes</string>

*/