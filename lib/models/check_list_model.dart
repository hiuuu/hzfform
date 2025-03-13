// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormCheckListModel extends HZFFormFieldModel {
  /// List of checkable items
  final List<CheckDataModel> items;

  /// Placeholder text when empty
  final String? hint;

  /// Custom icon for selected state
  final Widget? selectedIcon;

  /// Custom icon for unselected state
  final Widget? unSelectedIcon;

  /// Enable scrolling for list
  final bool? scrollable;

  /// Container height
  final double? height;

  /// Horizontal/vertical scrolling
  final Axis? scrollDirection;

  /// Show scrollbar indicator
  final bool? showScrollBar;

  /// Enable search functionality
  final bool searchable;

  /// Search field placeholder
  final String? searchHint;

  /// Custom search icon
  final Icon? searchIcon;

  /// Search box styling
  final BoxDecoration? searchBoxDecoration;

  /// Scrollbar color
  final Color? scrollBarColor;

  /// Validation requirement type
  final RequiredCheckListEnum? requiredCheckListEnum;

  HZFFormCheckListModel({
    required String tag,
    required this.items,
    this.hint,
    this.selectedIcon,
    this.unSelectedIcon,
    this.scrollable,
    this.height,
    this.scrollDirection,
    this.showScrollBar,
    this.searchable = false,
    this.searchHint,
    this.searchIcon,
    this.searchBoxDecoration,
    this.scrollBarColor,
    this.requiredCheckListEnum,

    // Parent class properties
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value,
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

class CheckDataModel {
  String title;
  bool isSelected;
  dynamic data;

  CheckDataModel({required this.title, required this.isSelected, this.data});
}
