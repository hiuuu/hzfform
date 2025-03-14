import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../models/date_picker_model.dart';
import '../models/date_range_picker_model.dart';
import '../models/field_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

/// Date range picker field builder
class DateRangePickerBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final rangeModel = model as HZFFormDateRangePickerModel;

    return InkWell(
      onTap: rangeModel.enableReadOnly == true
          ? null
          : () => _showRangePicker(
                context,
                rangeModel,
                controller,
              ),
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: rangeModel.hint ?? 'Select date range',
          prefixIcon: rangeModel.prefixWidget ?? const Icon(Icons.date_range),
          suffixIcon:
              rangeModel.postfixWidget ?? const Icon(Icons.arrow_drop_down),
          border: const OutlineInputBorder(),
        ),
        child: _buildRangeDisplay(context, rangeModel),
      ),
    );
  }

  Widget _buildRangeDisplay(
      BuildContext context, HZFFormDateRangePickerModel model) {
    if (model.value == null) {
      return Text(
        model.hint ?? 'Select date range',
        style: TextStyle(color: Theme.of(context).hintColor),
      );
    }

    final range = model.value as HZFFormDateRange;
    final formatter = _getFormatter(model.dateFormatType);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(model.from ?? 'From',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(formatter(range.start)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.arrow_forward, size: 16),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(model.to ?? 'To',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(formatter(range.end)),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showRangePicker(
    BuildContext context,
    HZFFormDateRangePickerModel model,
    HZFFormController controller,
  ) async {
    // Date constraints
    final now = DateTime.now();
    final firstDate = model.isPastAvailable == false
        ? now
        : model.availableFrom?.toDateTime() ?? DateTime(1900);
    final lastDate = model.availableTo?.toDateTime() ?? DateTime(2100);

    // Current range or defaults
    final initialRange = model.value as HZFFormDateRange?;
    final initialDateRange = initialRange != null
        ? DateTimeRange(
            start: initialRange.start.toDateTime(),
            end: initialRange.end.toDateTime(),
          )
        : (model.initialStartDate != null && model.initialEndDate != null
            ? DateTimeRange(
                start: model.initialStartDate!.toDateTime(),
                end: model.initialEndDate!.toDateTime(),
              )
            : null);

    if (model.calendarType == HZFFormCalendarType.gregorian) {
      final pickedRange = await showDateRangePicker(
        context: context,
        initialDateRange: initialDateRange,
        firstDate: firstDate,
        lastDate: lastDate,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedRange != null) {
        final formRange = HZFFormDateRange(
          start: HZFFormDate.fromDateTime(pickedRange.start),
          end: HZFFormDate.fromDateTime(pickedRange.end),
        );
        controller.updateFieldValue(model.tag, formRange);
      }
    } else {
      // Handle alternative calendar systems
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${model.calendarType} calendar not implemented')),
      );
    }
  }

  // Get date formatter based on format type
  String Function(HZFFormDate) _getFormatter(
      HZFFormDateFormatType? formatType) {
    switch (formatType) {
      case HZFFormDateFormatType.mmddyyyy:
        return (date) => '${date.month}/${date.day}/${date.year}';
      case HZFFormDateFormatType.ddmmyyyy:
        return (date) => '${date.day}/${date.month}/${date.year}';
      case HZFFormDateFormatType.yyyymmdd:
        return (date) =>
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      default:
        return (date) => '${date.month}/${date.day}/${date.year}';
    }
  }
}
