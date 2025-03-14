import 'package:flutter/material.dart';

import '../models/field_model.dart';
import '../models/text_password_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

/// Password field builder
class PasswordFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final passwordModel = model as HZFFormPasswordModel;
    final ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);

    return ValueListenableBuilder<bool>(
      valueListenable: obscureText,
      builder: (context, isObscured, _) {
        return TextFormField(
          initialValue: passwordModel.value?.toString(),
          obscureText: isObscured,
          decoration: InputDecoration(
            hintText: passwordModel.hint,
            prefixIcon: passwordModel.prefixWidget,
            suffixIcon: InkWell(
              onTap: () => obscureText.value = !isObscured,
              child: Icon(
                isObscured ? Icons.visibility_off : Icons.visibility,
              ),
            ),
            border: const OutlineInputBorder(),
            errorStyle: const TextStyle(height: 0),
          ),
          maxLength: passwordModel.maxLength,
          enabled: passwordModel.enableReadOnly != true,
          focusNode: passwordModel.focusNode,
          onChanged: (value) {
            controller.updateFieldValue(passwordModel.tag, value);
          },
          onFieldSubmitted: (_) {
            if (passwordModel.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(passwordModel.nextFocusNode);
            }
          },
        );
      },
    );
  }
}
