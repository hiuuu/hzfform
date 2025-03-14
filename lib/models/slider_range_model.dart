// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

import '../core/enums.dart';
import 'field_model.dart';

class HZFFormSliderRangeModel extends HZFFormFieldModel {
  /// Minimum value
  final double min;

  /// Maximum value
  final double max;

  /// Default range
  final RangeValues? defaultRange;

  /// Number of divisions
  final int? divisions;

  /// Decimal precision for display and value
  final int decimalPrecision;

  /// Minimum span between start and end
  final double? minSpan;

  /// Show values display
  final bool showValues;

  /// Show min/max labels
  final bool showMinMaxLabels;

  /// Custom min label
  final String? minLabel;

  /// Custom max label
  final String? maxLabel;

  /// Value prefix (e.g., "$")
  final String? valuePrefix;

  /// Value suffix (e.g., "kg")
  final String? valueSuffix;

  /// Custom value formatter
  final String Function(double)? formatValue;

  /// Active track color
  final Color? activeColor;

  /// Inactive track color
  final Color? inactiveColor;

  /// Value text style
  final TextStyle? valueTextStyle;

  /// Min/max label text style
  final TextStyle? minMaxLabelStyle;

  /// Value prefix style
  final TextStyle? valuePrefixStyle;

  /// Value suffix style
  final TextStyle? valueSuffixStyle;

  /// Callback when value changes
  final void Function(RangeValues)? onChanged;

  /// Callback when user starts changing value
  final void Function(RangeValues)? onChangeStart;

  /// Callback when user stops changing value
  final void Function(RangeValues)? onChangeEnd;

  HZFFormSliderRangeModel({
    required String tag,
    required this.min,
    required this.max,
    this.defaultRange,
    this.divisions,
    this.decimalPrecision = 1,
    this.minSpan,
    this.showValues = true,
    this.showMinMaxLabels = true,
    this.minLabel,
    this.maxLabel,
    this.valuePrefix,
    this.valueSuffix,
    this.formatValue,
    this.activeColor,
    this.inactiveColor,
    this.valueTextStyle,
    this.minMaxLabelStyle,
    this.valuePrefixStyle,
    this.valueSuffixStyle,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value, // RangeValues
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  })  : assert(min < max, 'Min value must be less than max value'),
        assert(
            defaultRange == null ||
                (defaultRange.start >= min && defaultRange.end <= max),
            'Default range must be between min and max'),
        assert(minSpan == null || minSpan > 0, 'Minimum span must be positive'),
        super(
          tag: tag,
          type: HZFFormFieldTypeEnum.sliderRange,
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

// Price range filter
final priceRangeFilter = HZFFormSliderRangeModel(
  tag: 'priceRange',
  title: 'Price Range',
  min: 0,
  max: 1000,
  defaultRange: RangeValues(200, 800),
  divisions: 10,
  valuePrefix: '\$',
  minSpan: 100, // Minimum $100 range
  activeColor: Colors.green,
  onChangeEnd: (range) => filterProducts(range.start, range.end),
);

// Date range with custom formatter
final dateRangeSlider = HZFFormSliderRangeModel(
  tag: 'dateRange',
  title: 'Select Date Range',
  min: 0,
  max: 30,
  defaultRange: RangeValues(5, 15),
  divisions: 30,
  // Convert slider values to date strings
  formatValue: (value) {
    final date = DateTime.now().add(Duration(days: value.toInt()));
    return '${date.month}/${date.day}';
  },
  onChanged: (range) => print('Selected dates: ${range.start.toInt()}-${range.end.toInt()} days'),
);

*/