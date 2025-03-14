// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

import '../core/enums.dart';
import 'field_model.dart';

class HZFFormSearchableDropdownModel extends HZFFormFieldModel {
  /// Available items
  final List<HZFDropdownItem> items;

  /// Hint text
  final String? hint;

  /// Label text
  final String? labelText;

  /// Show search box
  final bool showSearchBox;

  /// Search hint text
  final String? searchHint;

  /// Search icon
  final IconData? searchIcon;

  /// Auto focus search field when dropdown opens
  final bool autoFocusSearchField;

  /// Popup title
  final String? popupTitle;

  /// No results text
  final String? noResultsText;

  /// Show clear button
  final bool showClearButton;

  /// Clear button icon
  final IconData? clearIcon;

  /// Maximum popup height
  final double? maxPopupHeight;

  /// Menu background color
  final Color? menuBackgroundColor;

  /// Menu border radius
  final double? menuBorderRadius;

  /// Custom item builder
  final Widget Function(BuildContext, HZFDropdownItem, bool)? customItemBuilder;

  /// Custom filter function
  final bool Function(HZFDropdownItem, String)? customFilterFn;

  /// Async items callback for remote search
  final Future<List<HZFDropdownItem>> Function(String)? asyncItemsCallback;

  /// Search debounce time in milliseconds
  final int? searchDebounceTime;

  /// Item selected callback
  final Function(HZFDropdownItem)? onItemSelected;

  /// Input border
  final InputBorder? border;

  /// Enabled border
  final InputBorder? enabledBorder;

  /// Focused border
  final InputBorder? focusedBorder;

  /// Error border
  final InputBorder? errorBorder;

  /// Field is filled
  final bool? filled;

  /// Fill color
  final Color? fillColor;

  /// Content padding
  final EdgeInsetsGeometry? contentPadding;

  HZFFormSearchableDropdownModel({
    required String tag,
    required this.items,
    this.hint,
    this.labelText,
    this.showSearchBox = true,
    this.searchHint,
    this.searchIcon,
    this.autoFocusSearchField = true,
    this.popupTitle,
    this.noResultsText,
    this.showClearButton = true,
    this.clearIcon,
    this.maxPopupHeight,
    this.menuBackgroundColor,
    this.menuBorderRadius,
    this.customItemBuilder,
    this.customFilterFn,
    this.asyncItemsCallback,
    this.searchDebounceTime,
    this.onItemSelected,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.filled,
    this.fillColor,
    this.contentPadding,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value, // String (item id)
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  }) : super(
          tag: tag,
          type: HZFFormFieldTypeEnum.searchableDropdown,
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

class HZFDropdownItem {
  /// Unique identifier
  final String id;

  /// Display text
  final String label;

  /// Optional subtitle
  final String? subtitle;

  /// Optional description
  final String? description;

  /// Optional icon
  final IconData? icon;

  /// Optional image URL
  final String? imageUrl;

  /// Whether item is disabled
  final bool disabled;

  /// Additional data
  final Map<String, dynamic>? data;

  const HZFDropdownItem({
    required this.id,
    required this.label,
    this.subtitle,
    this.description,
    this.icon,
    this.imageUrl,
    this.disabled = false,
    this.data,
  });
}


/*
USAGE:

// Basic searchable dropdown
final countryDropdown = HZFFormSearchableDropdownModel(
  tag: 'country',
  title: 'Country',
  hint: 'Select a country',
  items: [
    HZFDropdownItem(id: 'us', label: 'United States', icon: Icons.flag),
    HZFDropdownItem(id: 'ca', label: 'Canada', icon: Icons.flag),
    HZFDropdownItem(id: 'uk', label: 'United Kingdom', icon: Icons.flag),
  ],
);

// API-based autocomplete dropdown
final cityDropdown = HZFFormSearchableDropdownModel(
  tag: 'city',
  title: 'City',
  hint: 'Search for a city',
  items: [], // Initial empty list
  asyncItemsCallback: (String filter) async {
    // Call API with search term
    final response = await http.get(
      Uri.parse('https://api.example.com/cities?search=$filter'),
    );
    
    // Parse response
    final List<dynamic> data = jsonDecode(response.body);
    
    // Convert to dropdown items
    return data.map((city) => HZFDropdownItem(
      id: city['id'],
      label: city['name'],
      subtitle: city['country'],
    )).toList();
  },
  searchDebounceTime: 500, // Wait 500ms before searching
  popupTitle: 'Search Cities',
  noResultsText: 'No cities found',
);

*/