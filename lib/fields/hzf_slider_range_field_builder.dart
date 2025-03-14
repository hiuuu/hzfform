import 'dart:math' show pow;

import 'package:flutter/material.dart';

import '../models/field_model.dart';
import '../models/slider_range_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

class SliderRangeFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final rangeModel = model as HZFFormSliderRangeModel;
    final theme = Theme.of(context);

    // Current range value
    final currentRange = _getCurrentRange(rangeModel);

    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Value display
          if (rangeModel.showValues)
            _buildRangeDisplay(rangeModel, currentRange, theme),

          // Range Slider
          RangeSlider(
            values: currentRange,
            min: rangeModel.min,
            max: rangeModel.max,
            divisions: rangeModel.divisions,
            labels: RangeLabels(
              rangeModel.formatValue?.call(currentRange.start) ??
                  currentRange.start
                      .toStringAsFixed(rangeModel.decimalPrecision),
              rangeModel.formatValue?.call(currentRange.end) ??
                  currentRange.end.toStringAsFixed(rangeModel.decimalPrecision),
            ),
            activeColor: rangeModel.activeColor ?? theme.primaryColor,
            inactiveColor: rangeModel.inactiveColor ??
                theme.disabledColor.withValues(alpha: .3),
            onChanged: rangeModel.enableReadOnly == true
                ? null
                : (RangeValues range) {
                    final roundedRange = RangeValues(
                      _roundToDecimalPrecision(
                          range.start, rangeModel.decimalPrecision),
                      _roundToDecimalPrecision(
                          range.end, rangeModel.decimalPrecision),
                    );

                    // Check minimum span requirement
                    if (rangeModel.minSpan != null &&
                        roundedRange.end - roundedRange.start <
                            rangeModel.minSpan!) {
                      return; // Skip update if below minimum span
                    }

                    controller.updateFieldValue(rangeModel.tag, roundedRange);
                    rangeModel.onChanged?.call(roundedRange);
                  },
            onChangeStart: rangeModel.onChangeStart,
            onChangeEnd: rangeModel.onChangeEnd,
          ),

          // Min/Max labels
          if (rangeModel.showMinMaxLabels)
            _buildMinMaxLabels(rangeModel, theme),
        ],
      ),
    );
  }

  Widget _buildRangeDisplay(
    HZFFormSliderRangeModel model,
    RangeValues range,
    ThemeData theme,
  ) {
    final startValue = model.formatValue?.call(range.start) ??
        range.start.toStringAsFixed(model.decimalPrecision);
    final endValue = model.formatValue?.call(range.end) ??
        range.end.toStringAsFixed(model.decimalPrecision);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Start value
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (model.valuePrefix != null)
                Text(model.valuePrefix!, style: model.valuePrefixStyle),
              Text(
                startValue,
                style: model.valueTextStyle ??
                    TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: theme.primaryColor,
                    ),
              ),
              if (model.valueSuffix != null)
                Text(model.valueSuffix!, style: model.valueSuffixStyle),
            ],
          ),

          // Range indicator
          Icon(Icons.arrow_forward,
              size: 16, color: theme.textTheme.titleMedium?.color),

          // End value
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (model.valuePrefix != null)
                Text(model.valuePrefix!, style: model.valuePrefixStyle),
              Text(
                endValue,
                style: model.valueTextStyle ??
                    TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: theme.primaryColor,
                    ),
              ),
              if (model.valueSuffix != null)
                Text(model.valueSuffix!, style: model.valueSuffixStyle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMinMaxLabels(HZFFormSliderRangeModel model, ThemeData theme) {
    final minLabel = model.formatValue?.call(model.min) ??
        model.minLabel ??
        model.min.toStringAsFixed(model.decimalPrecision);

    final maxLabel = model.formatValue?.call(model.max) ??
        model.maxLabel ??
        model.max.toStringAsFixed(model.decimalPrecision);

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            minLabel,
            style: model.minMaxLabelStyle ??
                TextStyle(
                    fontSize: 12, color: theme.textTheme.titleMedium?.color),
          ),
          Text(
            maxLabel,
            style: model.minMaxLabelStyle ??
                TextStyle(
                    fontSize: 12, color: theme.textTheme.titleMedium?.color),
          ),
        ],
      ),
    );
  }

  RangeValues _getCurrentRange(HZFFormSliderRangeModel model) {
    // Use current value or default to min-max
    if (model.value != null && model.value is RangeValues) {
      return model.value as RangeValues;
    }

    return model.defaultRange ?? RangeValues(model.min, model.max);
  }

  double _roundToDecimalPrecision(double value, int precision) {
    final mod = pow(10.0, precision);
    return (value * mod).round() / mod;
  }
}
