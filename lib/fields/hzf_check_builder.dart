import 'package:flutter/material.dart';

import '../core/controller.dart';
// import '../core/styles.dart';
import '../models/check_model.dart';
import '../models/field_model.dart';
import 'hzf_field_builder.dart';

class CheckboxFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final checkboxModel = model as HZFFormCheckboxModel;
    final value = controller.getFieldValue(model.tag) as bool? ?? false;

    // Use theme data from form style if available
    final theme = Theme.of(context);
    // final switchTheme =
    //     Theme.of(context).extension<HZFFormStyle>()?.switchTheme;

    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            // Switch component
            Switch(
              value: value,
              onChanged: checkboxModel.enableReadOnly == true
                  ? null
                  : (newValue) =>
                      controller.updateFieldValue(model.tag, newValue),
              activeColor:
                  checkboxModel.activeColor ?? theme.colorScheme.primary,
              activeTrackColor: checkboxModel.activeTrackColor,
              inactiveThumbColor: checkboxModel.inactiveThumbColor,
              inactiveTrackColor: checkboxModel.inactiveTrackColor,
              thumbIcon: checkboxModel.thumbIcon,
            ),

            const SizedBox(width: 8),

            // Label
            Expanded(
              child: GestureDetector(
                onTap: checkboxModel.enableReadOnly == true
                    ? null
                    : () => controller.updateFieldValue(model.tag, !value),
                child: checkboxModel.labelBuilder?.call(context, value) ??
                    Text(
                      checkboxModel.label ?? checkboxModel.title ?? '',
                      style: checkboxModel.labelStyle ??
                          TextStyle(
                            color: checkboxModel.enableReadOnly == true
                                ? theme.disabledColor
                                : theme.textTheme.bodyMedium?.color,
                          ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
