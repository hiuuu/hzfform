import 'package:flutter/material.dart';

import '../models/field_model.dart';
import '../models/radio_group_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

class RadioGroupFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final radioModel = model as HZFFormRadioGroupModel;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Radio group items
        ...radioModel.items.map(
            (item) => _buildRadioTile(item, radioModel, controller, theme)),

        // Validation/error space
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildRadioTile(
    HZFFormRadioItem item,
    HZFFormRadioGroupModel model,
    HZFFormController controller,
    ThemeData theme,
  ) {
    final isSelected = model.value == item.id;
    final isDisabled = model.enableReadOnly == true || item.disabled;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: InkWell(
        onTap:
            isDisabled ? null : () => _selectItem(item.id, model, controller),
        borderRadius: BorderRadius.circular(model.dense ? 4 : 8),
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: Row(
            children: [
              // Radio button
              Radio<String>(
                value: item.id,
                groupValue: model.value,
                onChanged: isDisabled
                    ? null
                    : (value) => _selectItem(value!, model, controller),
                activeColor: model.activeColor ?? theme.primaryColor,
              ),
              const SizedBox(width: 4),

              // Optional icon
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: model.dense ? 16 : 20,
                  color: isSelected
                      ? (model.activeColor ?? theme.primaryColor)
                      : null,
                ),
                const SizedBox(width: 8),
              ],

              // Label and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.label,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.normal,
                        fontSize: model.dense ? 14 : 16,
                      ),
                    ),
                    if (item.subtitle != null)
                      Text(
                        item.subtitle!,
                        style: TextStyle(
                          fontSize: model.dense ? 12 : 14,
                          color: theme.textTheme.titleMedium?.color,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectItem(
    String id,
    HZFFormRadioGroupModel model,
    HZFFormController controller,
  ) {
    controller.updateFieldValue(model.tag, id);

    // Call selection callback if provided
    model.onItemSelected?.call(id);
  }
}
