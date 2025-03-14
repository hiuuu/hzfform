import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../models/field_model.dart';
import '../models/time_picker_model.dart';
import '../widgets/controller.dart';
import 'hzf_field_builder.dart';

class TimePickerBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final timeModel = model as HZFFormTimePickerModel;

    return InkWell(
      onTap: timeModel.enableReadOnly == true
          ? null
          : () => _showTimePicker(
                context,
                timeModel,
                controller,
              ),
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: timeModel.hint ?? 'Select time',
          prefixIcon: timeModel.prefixWidget ?? const Icon(Icons.access_time),
          suffixIcon:
              timeModel.postfixWidget ?? const Icon(Icons.arrow_drop_down),
          border: const OutlineInputBorder(),
          errorStyle: const TextStyle(height: 0),
        ),
        child: Text(
          timeModel.value != null
              ? _formatTimeOfDay(timeModel.value, timeModel.timeFormat)
              : timeModel.hint ?? 'Select time',
          style: timeModel.value == null
              ? TextStyle(color: Theme.of(context).hintColor)
              : null,
        ),
      ),
    );
  }

  Future<void> _showTimePicker(
    BuildContext context,
    HZFFormTimePickerModel model,
    HZFFormController controller,
  ) async {
    // Initialize with current value or current time
    final initialTime = model.value ?? TimeOfDay.now();

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: model.initialEntryMode ?? TimePickerEntryMode.dial,
      builder: (context, child) {
        // Apply theme if specified
        if (model.useThemeData) {
          return Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: model.timePickerTheme,
              colorScheme: model.colorScheme ?? Theme.of(context).colorScheme,
            ),
            child: child!,
          );
        }
        return child!;
      },
    );
    if (!context.mounted) return;

    if (selectedTime != null) {
      controller.updateFieldValue(model.tag, selectedTime);

      // Handle time selection callback
      model.onTimeSelected?.call(selectedTime);

      // Move focus to next field if specified
      if (model.nextFocusNode != null) {
        FocusScope.of(context).requestFocus(model.nextFocusNode);
      }
    }
  }

  String _formatTimeOfDay(TimeOfDay time, HZFTimeFormat? format) {
    final hour = format == HZFTimeFormat.military
        ? time.hour.toString().padLeft(2, '0')
        : (time.hour > 12
                ? (time.hour - 12)
                : (time.hour == 0 ? 12 : time.hour))
            .toString();

    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';

    switch (format) {
      case HZFTimeFormat.military:
        return '$hour:$minute';
      case HZFTimeFormat.amPmLowercase:
        return '$hour:$minute ${period.toLowerCase()}';
      case HZFTimeFormat.amPmUppercase:
      default:
        return '$hour:$minute $period';
    }
  }
}


/*
USAGE:

final appointmentTime = HZFFormTimePickerModel(
  tag: 'appointmentTime',
  title: 'Appointment Time',
  hint: 'Select preferred time',
  required: true,
  timeFormat: HZFTimeFormat.amPmUppercase,
  initialEntryMode: TimePickerEntryMode.input,
  onTimeSelected: (time) => print('Selected: $time'),
);

*/