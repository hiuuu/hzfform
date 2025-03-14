import 'package:flutter/material.dart';

import '../models/field_model.dart';
import '../models/spinner_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

class SpinnerFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final spinnerModel = model as HZFFormSpinnerModel;

    return DropdownButtonFormField<String>(
      value: spinnerModel.value,
      isExpanded: true,
      icon: spinnerModel.dropdownIcon ?? const Icon(Icons.arrow_drop_down),
      decoration: InputDecoration(
        prefixIcon: spinnerModel.prefixWidget,
        suffixIcon: spinnerModel.postfixWidget,
        border: const OutlineInputBorder(),
        hintText: spinnerModel.hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        errorStyle: const TextStyle(height: 0),
      ),
      items: spinnerModel.items
          .map((item) => DropdownMenuItem<String>(
                value: item.id,
                enabled: !item.disabled,
                child: Row(
                  children: [
                    if (item.icon != null) ...[
                      Icon(item.icon, size: 18),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        item.label,
                        overflow: TextOverflow.ellipsis,
                        style: item.disabled
                            ? TextStyle(color: Colors.grey[400])
                            : null,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
      onChanged: spinnerModel.enableReadOnly == true
          ? null
          : (value) {
              if (value != null) {
                controller.updateFieldValue(spinnerModel.tag, value);
              }
            },
      onSaved: (value) {
        if (value != null) {
          controller.updateFieldValue(spinnerModel.tag, value);
        }
      },
      menuMaxHeight: spinnerModel.menuMaxHeight,
      dropdownColor: spinnerModel.dropdownColor,
      focusNode: spinnerModel.focusNode,
      validator: (_) => null, // Validation handled by controller
    );
  }
}
