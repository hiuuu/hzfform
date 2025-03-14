// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormCheckListModel extends HZFFormFieldModel {
  /// Items to display
  final List<HZFFormCheckListItem> items;

  /// Enable search filtering
  final bool enableSearch;

  /// Search hint text
  final String? searchHint;

  /// No results text
  final String? noResultsText;

  /// Show selection counter
  final bool showCounter;

  /// Enable bulk actions (select all/clear)
  final bool enableBulkActions;

  /// Select all button text
  final String? selectAllText;

  /// Clear selection button text
  final String? clearSelectionText;

  /// Checkbox color
  final Color? checkColor;

  /// Maximum selectable items
  final int? maxSelection;

  /// Search controller
  final TextEditingController searchController = TextEditingController();

  HZFFormCheckListModel({
    required String tag,
    required this.items,
    this.enableSearch = false,
    this.searchHint,
    this.noResultsText,
    this.showCounter = true,
    this.enableBulkActions = true,
    this.selectAllText,
    this.clearSelectionText,
    this.checkColor,
    this.maxSelection,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value, // List<String> (item ids)
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  }) : super(
          tag: tag,
          type: HZFFormFieldTypeEnum.checkList,
          title: title,
          errorMessage: errorMessage,
          helpMessage: helpMessage,
          prefixWidget: prefixWidget,
          postfixWidget: postfixWidget,
          required: required,
          showTitle: showTitle,
          value: value ?? <String>[],
          validateRegEx: validateRegEx,
          weight: weight,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          onTap: onTap,
          status: status,
          enableReadOnly: enableReadOnly,
        );

  void dispose() {
    searchController.dispose();
  }
}

/// Item for checklist
class HZFFormCheckListItem {
  /// Unique identifier
  final String id;

  /// Display text
  final String label;

  /// Optional subtitle
  final String? subtitle;

  /// Optional icon
  final IconData? icon;

  /// Whether item is disabled
  final bool disabled;

  const HZFFormCheckListItem({
    required this.id,
    required this.label,
    this.subtitle,
    this.icon,
    this.disabled = false,
  });
}

/*
USAGE:

HZFFormCheckListModel(
  tag: 'features',
  title: 'Select Features',
  items: [
    HZFFormCheckListItem(id: 'dark_mode', label: 'Dark Mode', icon: Icons.dark_mode),
    HZFFormCheckListItem(id: 'backup', label: 'Cloud Backup', subtitle: '2 GB free'),
    HZFFormCheckListItem(id: 'premium', label: 'Premium Features', disabled: true),
  ],
  enableSearch: true,
  maxSelection: 2,
)

*/
