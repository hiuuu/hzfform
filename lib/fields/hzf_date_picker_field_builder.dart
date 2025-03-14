import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../models/date_picker_model.dart';
import '../models/field_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

/// Date picker field builder
class DatePickerBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final dateModel = model as HZFFormDatePickerModel;

    return InkWell(
      onTap: dateModel.enableReadOnly == true
          ? null
          : () => _showDatePicker(
                context,
                dateModel,
                controller,
              ),
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: dateModel.hint ?? 'Select date',
          prefixIcon:
              dateModel.prefixWidget ?? const Icon(Icons.calendar_today),
          suffixIcon:
              dateModel.postfixWidget ?? const Icon(Icons.arrow_drop_down),
          border: const OutlineInputBorder(),
          errorStyle: const TextStyle(height: 0),
        ),
        child: Text(
          dateModel.value != null
              ? dateModel.getFormattedDate() ?? 'Select date'
              : dateModel.hint ?? 'Select date',
          style: dateModel.value == null
              ? TextStyle(color: Theme.of(context).hintColor)
              : null,
        ),
      ),
    );
  }

  Future<void> _showDatePicker(
    BuildContext context,
    HZFFormDatePickerModel model,
    HZFFormController controller,
  ) async {
    // Calculate date constraints
    final now = DateTime.now();
    final firstDate = model.isPastAvailable == false
        ? now
        : model.availableFrom?.toDateTime() ?? DateTime(1900);
    final lastDate = model.availableTo?.toDateTime() ?? DateTime(2100);

    // Current value or today
    final initialDate = model.value != null
        ? (model.value as HZFFormDate).toDateTime()
        : (model.initialDate?.toDateTime() ?? now);

    // Show correct picker based on calendar type
    final DateTime? pickedDate;

    if (model.calendarType == HZFFormCalendarType.gregorian) {
      pickedDate = await showDatePicker(
        context: context,
        initialDate: _getValidInitialDate(initialDate, firstDate, lastDate),
        firstDate: firstDate,
        lastDate: lastDate,
      );
    } else {
      // For non-Gregorian calendars, would need custom implementations
      // or third-party packages like hijri_picker for Islamic calendar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${model.calendarType} calendar not implemented')),
      );
      return;
    }

    if (pickedDate != null) {
      // Convert to HZFFormDate and update
      final formDate = HZFFormDate.fromDateTime(pickedDate);
      controller.updateFieldValue(model.tag, formDate);
    }
  }

  // Ensure initial date is within valid range
  DateTime _getValidInitialDate(
    DateTime initialDate,
    DateTime firstDate,
    DateTime lastDate,
  ) {
    if (initialDate.isBefore(firstDate)) return firstDate;
    if (initialDate.isAfter(lastDate)) return lastDate;
    return initialDate;
  }
}
