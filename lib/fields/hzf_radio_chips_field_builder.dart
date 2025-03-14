import 'package:flutter/material.dart';

import '../models/field_model.dart';
import '../models/radio_chips_group_model.dart';
import '../widgets/controller.dart';
import 'hzf_field_builder.dart';

class RadioChipsGroupBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final radioModel = model as HZFFormRadioChipsGroupModel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chips layout
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _buildChips(radioModel, controller, context),
        ),
      ],
    );
  }

  List<Widget> _buildChips(
    HZFFormRadioChipsGroupModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    return model.items.map((item) {
      final isSelected = model.value == item.id;
      final isDisabled = model.enableReadOnly == true;

      return ChoiceChip(
        label: Text(item.label),
        selected: isSelected,
        onSelected: isDisabled
            ? null
            : (selected) {
                if (selected) {
                  controller.updateFieldValue(model.tag, item.id);
                }
              },
        labelStyle: TextStyle(
          color: isSelected
              ? model.selectedTextColor ?? Colors.white
              : model.textColor ?? Colors.black,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
        backgroundColor: model.backgroundColor ?? Colors.grey[200],
        selectedColor: model.selectedColor ?? Theme.of(context).primaryColor,
        avatar: item.icon != null
            ? Icon(
                item.icon,
                size: 18,
                color: isSelected
                    ? model.selectedTextColor ?? Colors.white
                    : model.textColor ?? Colors.black,
              )
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      );
    }).toList();
  }
}
