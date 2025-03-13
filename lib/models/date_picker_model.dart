// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormDatePickerModel extends HZFFormFieldModel {
  /// Placeholder text when no date selected
  final String? hint;

  /// Date display format (e.g., MM/dd/yyyy, dd-MM-yyyy)
  final HZFFormDateFormatType? dateFormatType;

  /// Whether past dates can be selected
  final bool? isPastAvailable;

  /// Default selected date
  final HZFFormDate? initialDate;

  /// Start of selectable date range
  final HZFFormDate? availableFrom;

  /// End of selectable date range
  final HZFFormDate? availableTo;

  /// Calendar display type (gregorian, hijri, etc)
  final HZFFormCalendarType calendarType;

  HZFFormDatePickerModel({
    required String tag,
    this.hint,
    this.dateFormatType = HZFFormDateFormatType.mmddyyyy,
    this.isPastAvailable = true,
    this.initialDate,
    this.availableFrom,
    this.availableTo,
    this.calendarType = HZFFormCalendarType.gregorian,

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
  })  : assert(
            availableFrom == null ||
                availableTo == null ||
                !availableFrom.isAfter(availableTo),
            'availableFrom must be before availableTo'),
        assert(
            initialDate == null ||
                availableFrom == null ||
                !initialDate.isBefore(availableFrom),
            'initialDate must be after availableFrom'),
        assert(
            initialDate == null ||
                availableTo == null ||
                !initialDate.isAfter(availableTo),
            'initialDate must be before availableTo'),
        super(
          tag: tag,
          type: HZFFormFieldTypeEnum.datePicker,
          title: title,
          errorMessage: errorMessage,
          helpMessage: helpMessage,
          prefixWidget: prefixWidget ?? const Icon(Icons.calendar_today),
          postfixWidget: postfixWidget,
          required: required,
          showTitle: showTitle,
          value: value ?? initialDate,
          validateRegEx: validateRegEx,
          weight: weight,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          onTap: onTap,
          status: status,
          enableReadOnly: enableReadOnly,
        );

  /// Get formatted date string based on dateFormatType
  String? getFormattedDate() {
    if (value == null) return null;

    final date = value as HZFFormDate;
    switch (dateFormatType) {
      case HZFFormDateFormatType.mmddyyyy:
        return '${date.month}/${date.day}/${date.year}';
      case HZFFormDateFormatType.ddmmyyyy:
        return '${date.day}/${date.month}/${date.year}';
      case HZFFormDateFormatType.yyyymmdd:
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      default:
        return date.toString();
    }
  }
}

/// Date wrapper class with comparison helpers
class HZFFormDate {
  final int year;
  final int month;
  final int day;

  const HZFFormDate({
    required this.year,
    required this.month,
    required this.day,
  });

  /// Create from DateTime
  factory HZFFormDate.fromDateTime(DateTime dateTime) {
    return HZFFormDate(
      year: dateTime.year,
      month: dateTime.month,
      day: dateTime.day,
    );
  }

  /// Convert to DateTime
  DateTime toDateTime() => DateTime(year, month, day);

  /// Check if this date is after another
  bool isAfter(HZFFormDate other) {
    return toDateTime().isAfter(other.toDateTime());
  }

  /// Check if this date is before another
  bool isBefore(HZFFormDate other) {
    return toDateTime().isBefore(other.toDateTime());
  }

  @override
  String toString() =>
      '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}
