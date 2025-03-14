import 'package:flutter/material.dart';

import '../models/field_model.dart';
import '../models/text_area_model.dart';
import '../widgets/controller.dart';
import 'hzf_field_builder.dart';

/// Text plain field builder
class TextAreaFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final textModel = model as HZFFormTextPlainModel;

    return TextFormField(
      initialValue: textModel.value?.toString(),
      decoration: InputDecoration(
        hintText: textModel.hint,
        prefixIcon: textModel.prefixWidget,
        suffixIcon: textModel.postfixWidget,
        border: const OutlineInputBorder(),
        errorStyle: const TextStyle(height: 0),
        counterText: textModel.showCounter == true ? null : '',
      ),
      maxLines: textModel.maxLine,
      minLines: textModel.minLine,
      maxLength: textModel.maxLength,
      enabled: textModel.enableReadOnly != true,
      focusNode: textModel.focusNode,
      onChanged: (value) {
        controller.updateFieldValue(textModel.tag, value);
      },
      onFieldSubmitted: (_) {
        if (textModel.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(textModel.nextFocusNode);
        }
      },
    );
  }
}
