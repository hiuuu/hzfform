// ignore_for_file: use_super_parameters

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../core/enums.dart';
import 'field_model.dart';

class HZFFormDocumentPickerModel extends HZFFormFieldModel {
  /// Enable document scanning
  final bool enableScanning;

  /// Allow multiple documents
  final bool allowMultiple;

  /// Maximum number of files
  final int? maxFiles;

  /// File type filter
  final FileType? fileType;

  /// Allowed file extensions
  final List<String>? allowedExtensions;

  /// Helper text
  final String? helperText;

  /// Pick button text
  final String? pickButtonText;

  /// Pick button icon
  final IconData? pickIcon;

  /// Pick button color
  final Color? pickButtonColor;

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

  /// Retake button text
  final String? retakeButtonText;

  /// Use scan button text
  final String? useScanButtonText;

  /// Documents selected callback
  final Function(List<DocumentFile>)? onDocumentsSelected;

  HZFFormDocumentPickerModel({
    required String tag,
    this.enableScanning = true,
    this.allowMultiple = false,
    this.maxFiles,
    this.fileType,
    this.allowedExtensions,
    this.helperText,
    this.pickButtonText,
    this.pickIcon,
    this.pickButtonColor,
    this.scanButtonText,
    this.scanIcon,
    this.scanButtonColor,
    this.scannerTitle,
    this.scanHelpText,
    this.retakeButtonText,
    this.useScanButtonText,
    this.onDocumentsSelected,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value, // List<DocumentFile>
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  }) : super(
          tag: tag,
          type: HZFFormFieldTypeEnum.documentPicker,
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

/// Document file model
class DocumentFile {
  final String path;
  final String? name;
  final int? size;
  final String? mimeType;
  String? thumbnailPath;

  DocumentFile({
    required this.path,
    this.name,
    this.size,
    this.mimeType,
    this.thumbnailPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'name': name,
      'size': size,
      'mimeType': mimeType,
      'thumbnailPath': thumbnailPath,
    };
  }

  factory DocumentFile.fromJson(Map<String, dynamic> json) {
    return DocumentFile(
      path: json['path'],
      name: json['name'],
      size: json['size'],
      mimeType: json['mimeType'],
      thumbnailPath: json['thumbnailPath'],
    );
  }
}


/*
USAGE:

// ID Document Scanner
final idDocumentField = HZFFormDocumentPickerModel(
  tag: 'idDocument',
  title: 'ID Document',
  enableScanning: true,
  allowMultiple: false,
  fileType: FileType.image,
  helperText: 'Please upload a clear photo of your ID document',
  scanButtonText: 'Scan ID',
  scanHelpText: 'Position your ID card within the frame',
  onDocumentsSelected: (docs) {
    verifyDocument(docs.first.path);
  },
);

// Multiple Receipt Upload
final receiptsField = HZFFormDocumentPickerModel(
  tag: 'receipts',
  title: 'Expense Receipts',
  enableScanning: true,
  allowMultiple: true,
  maxFiles: 5,
  fileType: FileType.custom,
  allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
  helperText: 'Upload up to 5 receipts (PDF or images)',
  pickButtonText: 'Upload Receipt',
  scanButtonText: 'Scan Receipt',
);

Note: For production use, consider adding:
Document edge detection using edge_detection or similar package
PDF generation from scanned images
OCR text extraction for document data
Cloud storage integration for documents

*/