// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'field_model.dart';
import 'date_picker_model.dart';
import '../core/enums.dart';

class HZFFormDateRangePickerModel extends HZFFormFieldModel {
  /// Placeholder text when no dates selected
  final String? hint;

  /// Date display format
  final HZFFormDateFormatType? dateFormatType;

  /// Whether past dates can be selected
  final bool? isPastAvailable;

  /// Default start date
  final HZFFormDate? initialStartDate;

  /// Default end date
  final HZFFormDate? initialEndDate;

  /// Minimum selectable date
  final HZFFormDate? availableFrom;

  /// Maximum selectable date
  final HZFFormDate? availableTo;

  /// Calendar display type
  final HZFFormCalendarType calendarType;

  /// Label for start date
  final String? from;

  /// Label for end date
  final String? to;

  HZFFormDateRangePickerModel({
    required String tag,
    this.hint,
    this.dateFormatType = HZFFormDateFormatType.mmddyyyy,
    this.isPastAvailable = true,
    this.initialStartDate,
    this.initialEndDate,
    this.availableFrom,
    this.availableTo,
    this.calendarType = HZFFormCalendarType.gregorian,
    this.from = "From",
    this.to = "To",

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value, // HZFFormDateRange
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  })  : assert(
            availableFrom == null ||
                availableTo == null ||
                !availableFrom.isAfter(availableTo),
            'availableFrom must be before availableTo'),
        assert(
            initialStartDate == null ||
                initialEndDate == null ||
                !initialStartDate.isAfter(initialEndDate),
            'initialStartDate must be before initialEndDate'),
        assert(
            initialStartDate == null ||
                availableFrom == null ||
                !initialStartDate.isBefore(availableFrom),
            'initialStartDate must be after availableFrom'),
        assert(
            initialEndDate == null ||
                availableTo == null ||
                !initialEndDate.isAfter(availableTo),
            'initialEndDate must be before availableTo'),
        super(
          tag: tag,
          type: HZFFormFieldTypeEnum.dateRangePicker,
          title: title,
          errorMessage: errorMessage,
          helpMessage: helpMessage,
          prefixWidget: prefixWidget ?? const Icon(Icons.date_range),
          postfixWidget: postfixWidget,
          required: required,
          showTitle: showTitle,
          value: value ??
              (initialStartDate != null && initialEndDate != null
                  ? HZFFormDateRange(
                      start: initialStartDate, end: initialEndDate)
                  : null),
          validateRegEx: validateRegEx,
          weight: weight,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          onTap: onTap,
          status: status,
          enableReadOnly: enableReadOnly,
        );

  /// Get formatted date range string
  String? getFormattedDateRange() {
    if (value == null) return null;

    final range = value as HZFFormDateRange;
    final formatter = _getFormatter();

    return '${from ?? "From"}: ${formatter(range.start)} - ${to ?? "To"}: ${formatter(range.end)}';
  }

  /// Get formatter function based on dateFormatType
  String Function(HZFFormDate) _getFormatter() {
    switch (dateFormatType) {
      case HZFFormDateFormatType.mmddyyyy:
        return (date) => '${date.month}/${date.day}/${date.year}';
      case HZFFormDateFormatType.ddmmyyyy:
        return (date) => '${date.day}/${date.month}/${date.year}';
      case HZFFormDateFormatType.yyyymmdd:
        return (date) =>
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      default:
        return (date) => date.toString();
    }
  }
}

/// Date range container
class HZFFormDateRange {
  final HZFFormDate start;
  final HZFFormDate end;

  const HZFFormDateRange({
    required this.start,
    required this.end,
  });

  /// Duration between dates
  int get durationInDays =>
      end.toDateTime().difference(start.toDateTime()).inDays;

  /// Check if range includes date
  bool includes(HZFFormDate date) {
    final dt = date.toDateTime();
    return !dt.isBefore(start.toDateTime()) &&
        !dt.isAfter(end.toDateTime().add(const Duration(days: 1)));
  }
}
