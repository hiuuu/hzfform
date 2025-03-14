import 'dart:math' show pow;

import 'package:flutter/material.dart';

import '../models/field_model.dart';
import '../models/slider_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

class SliderFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final sliderModel = model as HZFFormSliderModel;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Value display
        if (sliderModel.showValue) _buildValueDisplay(sliderModel, theme),

        // Slider
        Slider(
          value: _getCurrentValue(sliderModel),
          min: sliderModel.min,
          max: sliderModel.max,
          divisions: sliderModel.divisions,
          label: sliderModel.formatValue?.call(_getCurrentValue(sliderModel)) ??
              _getCurrentValue(sliderModel)
                  .toStringAsFixed(sliderModel.decimalPrecision),
          activeColor: sliderModel.activeColor ?? theme.primaryColor,
          inactiveColor: sliderModel.inactiveColor ??
              theme.disabledColor.withValues(alpha: .3),
          thumbColor: sliderModel.thumbColor,
          onChanged: sliderModel.enableReadOnly == true
              ? null
              : (value) {
                  final roundedValue = _roundToDecimalPrecision(
                      value, sliderModel.decimalPrecision);
                  controller.updateFieldValue(sliderModel.tag, roundedValue);
                  sliderModel.onChanged?.call(roundedValue);
                },
          onChangeStart: sliderModel.onChangeStart,
          onChangeEnd: sliderModel.onChangeEnd,
        ),

        // Min/Max labels
        if (sliderModel.showMinMaxLabels)
          _buildMinMaxLabels(sliderModel, theme),
      ],
    );
  }

  Widget _buildValueDisplay(HZFFormSliderModel model, ThemeData theme) {
    final displayValue = model.formatValue?.call(_getCurrentValue(model)) ??
        _getCurrentValue(model).toStringAsFixed(model.decimalPrecision);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (model.valuePrefix != null)
            Text(model.valuePrefix!, style: model.valuePrefixStyle),
          Text(
            displayValue,
            style: model.valueTextStyle ??
                TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
          ),
          if (model.valueSuffix != null)
            Text(model.valueSuffix!, style: model.valueSuffixStyle),
        ],
      ),
    );
  }

  Widget _buildMinMaxLabels(HZFFormSliderModel model, ThemeData theme) {
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

  double _getCurrentValue(HZFFormSliderModel model) {
    // Use current value or default to min
    if (model.value != null) {
      return (model.value as num).toDouble();
    }
    return model.defaultValue ?? model.min;
  }

  double _roundToDecimalPrecision(double value, int precision) {
    final mod = pow(10.0, precision);
    return (value * mod).round() / mod;
  }
}
