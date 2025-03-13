// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormRadioGroupModel extends HZFFormFieldModel {
  /// Radio options to display
  final List<RadioDataModel> items;

  /// Placeholder text
  final String? hint;

  /// Custom icon for selected state
  final Widget? selectedIcon;

  /// Custom icon for unselected state
  final Widget? unSelectedIcon;

  /// Enable list scrolling
  final bool? scrollable;

  /// Container height
  final double? height;

  /// Scroll direction (horizontal/vertical)
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

  /// Selection change callback
  final ValueChanged<RadioDataModel> callBack;

  HZFFormRadioGroupModel({
    required String tag,
    required this.items,
    required this.callBack,
    this.hint,
    this.selectedIcon,
    this.unSelectedIcon,
    this.scrollable,
    this.height,
    this.scrollDirection = Axis.vertical,
    this.showScrollBar,
    this.searchable = false,
    this.searchHint,
    this.searchIcon,
    this.searchBoxDecoration,
    this.scrollBarColor,

    // Parent props
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
          type: HZFFormFieldTypeEnum.radioGroup,
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

class RadioDataModel {
  String title;
  bool isSelected;
  dynamic data;

  RadioDataModel({required this.title, required this.isSelected, this.data});
}
