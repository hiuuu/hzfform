// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

import '../core/enums.dart';
import 'field_model.dart';

class HZFFormMetaDataModel extends HZFFormFieldModel {
  /// Minimum number of entries
  final int minEntries;

  /// Maximum number of entries
  final int? maxEntries;

  /// Show entry counter
  final bool showCounter;

  /// Key column label
  final String? keyLabel;

  /// Value column label
  final String? valueLabel;

  /// Key field hint
  final String? keyHint;

  /// Value field hint
  final String? valueHint;

  /// Predefined key options for dropdown
  final List<String> keyOptions;

  /// Add button text
  final String? addButtonText;

  /// Add button tooltip
  final String? addTooltip;

  /// Add button icon
  final IconData? addIcon;

  /// Add button color
  final Color? addIconColor;

  /// Remove button tooltip
  final String? removeTooltip;

  /// Remove button icon
  final IconData? removeIcon;

  /// Remove button color
  final Color? removeIconColor;

  /// Add button position
  final AddButtonPosition addButtonPosition;

  /// Output format
  final MetaDataOutputFormat outputFormat;

  /// Key column flex
  final int keyColumnFlex;

  /// Value column flex
  final int valueColumnFlex;

  HZFFormMetaDataModel({
    required String tag,
    this.minEntries = 1,
    this.maxEntries,
    this.showCounter = true,
    this.keyLabel,
    this.valueLabel,
    this.keyHint,
    this.valueHint,
    this.keyOptions = const [],
    this.addButtonText,
    this.addTooltip,
    this.addIcon,
    this.addIconColor,
    this.removeTooltip,
    this.removeIcon,
    this.removeIconColor,
    this.addButtonPosition = AddButtonPosition.bottom,
    this.outputFormat = MetaDataOutputFormat.map,
    this.keyColumnFlex = 2,
    this.valueColumnFlex = 3,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value, // Map<String, dynamic> or List<MetaDataEntry>
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  })  : assert(minEntries > 0, 'Minimum entries must be greater than 0'),
        assert(maxEntries == null || maxEntries >= minEntries,
            'Maximum entries must be greater than or equal to minimum entries'),
        super(
          tag: tag,
          type: HZFFormFieldTypeEnum.metaData,
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

// Basic metadata field with dropdown keys
final metadataField = HZFFormMetaDataModel(
  tag: 'metadata',
  title: 'Product Attributes',
  minEntries: 1,
  maxEntries: 5,
  keyOptions: ['Color', 'Size', 'Material', 'Weight', 'Origin'],
  keyLabel: 'Attribute',
  valueLabel: 'Specification',
  outputFormat: MetaDataOutputFormat.map,
);

// Free-form metadata with custom styling
final customMetadata = HZFFormMetaDataModel(
  tag: 'customMeta',
  title: 'Custom Fields',
  keyHint: 'Field name',
  valueHint: 'Field value',
  addButtonText: 'Add Custom Field',
  addIcon: Icons.add_box,
  addIconColor: Colors.green,
  removeIcon: Icons.delete_outline,
  removeIconColor: Colors.redAccent,
  keyColumnFlex: 1,
  valueColumnFlex: 2,
);

*/