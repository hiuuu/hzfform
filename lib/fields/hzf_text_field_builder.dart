import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:provider/provider.dart';

import '../core/enums.dart';
import '../models/field_model.dart';
import '../models/text_field_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

class TextFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final textModel = model as HZFFormTextModel;
    final maskController = textModel.maskController ??
        TextEditingController(text: textModel.value?.toString());

    // Initialize speech recognition if enabled
    final speechEnabled = textModel.enableSpeechToText && _isSpeechAvailable();
    final isListening = ValueNotifier<bool>(false);
    SpeechToText? speech;

    if (speechEnabled) {
      speech = SpeechToText();
      speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            isListening.value = false;
          }
        },
        onError: (_) => isListening.value = false,
      );
    }

    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder(
              valueListenable: isListening,
              builder: (context, listening, _) {
                return Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextFormField(
                      controller: maskController,
                      decoration:
                          _buildInputDecoration(textModel, context, listening),
                      keyboardType: _getKeyboardType(textModel),
                      textCapitalization: textModel.textCapitalization ??
                          TextCapitalization.none,
                      textInputAction:
                          textModel.textInputAction ?? TextInputAction.next,
                      maxLines: textModel.maxLines ?? 1,
                      minLines: textModel.minLines,
                      maxLength: textModel.maxLength,
                      inputFormatters: _buildInputFormatters(textModel),
                      obscureText: textModel.obscureText ?? false,
                      enabled: textModel.enableReadOnly != true,
                      focusNode: textModel.focusNode,
                      style: textModel.textStyle,
                      textAlign: textModel.textAlign ?? TextAlign.start,
                      cursorColor: textModel.cursorColor,
                      showCursor: textModel.showCursor,
                      textDirection: textModel.textDirection,
                      autofillHints: textModel.autofillHints,
                      onChanged: (value) {
                        controller.updateFieldValue(textModel.tag, value);
                        textModel.onChanged?.call(value);
                      },
                      onFieldSubmitted: (_) {
                        if (textModel.nextFocusNode != null) {
                          FocusScope.of(context)
                              .requestFocus(textModel.nextFocusNode);
                        }
                        // ignore: no_wildcard_variable_uses
                        textModel.onFieldSubmitted?.call(_);
                      },
                    ),
                    if (listening)
                      Positioned(
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: .2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.mic,
                              color: Colors.red, size: 20),
                        ),
                      ),
                  ],
                );
              }),

          // Character counter (if enabled but not showing in decoration)
          if (textModel.showCounter &&
              textModel.counterPosition == CounterPosition.below)
            _buildExternalCounter(maskController, textModel),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    HZFFormTextModel model,
    BuildContext context,
    bool listening,
  ) {
    final hasText = model.maskController?.text.isNotEmpty ?? false;

    return InputDecoration(
      hintText: model.hint,
      labelText: model.labelText,
      prefixIcon: model.prefixWidget,
      suffixIcon: _buildSuffixWidget(model, context, listening, hasText),
      prefixText: model.prefixText,
      suffixText: model.suffixText,
      border: model.border ?? const OutlineInputBorder(),
      enabledBorder: model.enabledBorder,
      focusedBorder: model.focusedBorder,
      errorBorder: model.errorBorder,
      disabledBorder: model.disabledBorder,
      filled: model.filled,
      fillColor: model.fillColor,
      contentPadding: model.contentPadding ??
          EdgeInsets.symmetric(
              horizontal: 12,
              vertical:
                  model.maxLines != null && model.maxLines! > 1 ? 16 : 12),
      errorStyle: const TextStyle(height: 0),
      counterText:
          model.showCounter && model.counterPosition == CounterPosition.inline
              ? null // Use default counter
              : '', // Hide default counter
    );
  }

  Widget? _buildSuffixWidget(
    HZFFormTextModel model,
    BuildContext context,
    bool listening,
    bool hasText,
  ) {
    // Priority order for suffix widgets
    if (listening) {
      // Speech recording indicator takes priority
      return null; // Handled in stack
    } else if (model.postfixWidget != null) {
      // User-provided widget comes next
      return model.postfixWidget;
    } else if (model.enableSpeechToText && _isSpeechAvailable()) {
      // Speech button if enabled and available
      return IconButton(
        icon: const Icon(Icons.mic_none),
        onPressed: () => _startListening(model, context),
      );
    } else if (model.showClearButton && hasText) {
      // Clear button if text exists and enabled
      return IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          model.maskController?.clear();
          // Update the form controller
          Provider.of<HZFFormController>(context, listen: false)
              .updateFieldValue(model.tag, '');
          model.onChanged?.call('');
        },
      );
    }

    return null;
  }

  List<TextInputFormatter> _buildInputFormatters(HZFFormTextModel model) {
    final formatters = <TextInputFormatter>[];

    // Add custom formatters
    if (model.inputFormatters != null) {
      formatters.addAll(model.inputFormatters!);
    }

    // Add mask formatter if mask pattern provided
    if (model.maskPattern != null) {
      formatters
          .add(_createMaskFormatter(model.maskPattern!, model.maskFilter));
    } else if (model.maskType != null) {
      // Add predefined mask based on type
      switch (model.maskType!) {
        case MaskType.phone:
          formatters.add(
              _createMaskFormatter('(###) ###-####', {'#': RegExp(r'[0-9]')}));
          break;
        case MaskType.date:
          formatters
              .add(_createMaskFormatter('##/##/####', {'#': RegExp(r'[0-9]')}));
          break;
        case MaskType.time:
          formatters
              .add(_createMaskFormatter('##:##', {'#': RegExp(r'[0-9]')}));
          break;
        case MaskType.creditCard:
          formatters.add(_createMaskFormatter(
              '#### #### #### ####', {'#': RegExp(r'[0-9]')}));
          break;
        case MaskType.zipCode:
          formatters
              .add(_createMaskFormatter('#####-####', {'#': RegExp(r'[0-9]')}));
          break;
        case MaskType.currency:
          formatters.add(
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')));
          break;
      }
    }

    return formatters;
  }

  TextInputType _getKeyboardType(HZFFormTextModel model) {
    // Return user-specified keyboard type if provided
    if (model.keyboardType != null) {
      return model.keyboardType!;
    }

    // Infer keyboard type from mask type
    if (model.maskType != null) {
      switch (model.maskType!) {
        case MaskType.phone:
          return TextInputType.phone;
        case MaskType.date:
        case MaskType.time:
        case MaskType.zipCode:
        case MaskType.creditCard:
        case MaskType.currency:
          return TextInputType.number;
      }
    }

    // Default to multiline for multiple lines, text otherwise
    return model.maxLines != null && model.maxLines! > 1
        ? TextInputType.multiline
        : TextInputType.text;
  }

  Widget _buildExternalCounter(
    TextEditingController controller,
    HZFFormTextModel model,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, right: 4.0),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) {
          final currentLength = value.text.length;
          final maxLength = model.maxLength ?? 0;

          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                model.counterFormat != null
                    ? model.counterFormat!(currentLength, maxLength)
                    : '$currentLength${maxLength > 0 ? '/$maxLength' : ''}',
                style: TextStyle(
                  fontSize: 12,
                  color: currentLength > maxLength && maxLength > 0
                      ? Colors.red
                      : Colors.grey[600],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  MaskTextInputFormatter _createMaskFormatter(
      String pattern, Map<String, RegExp>? filter) {
    return MaskTextInputFormatter(
      mask: pattern,
      filter: filter,
      type: MaskAutoCompletionType.lazy,
    );
  }

  bool _isSpeechAvailable() {
    // This would normally check platform compatibility
    // For implementation, we'd need to add the speech_to_text package
    return true;
  }

  void _startListening(HZFFormTextModel model, BuildContext context) async {
    // Implementation requires speech_to_text package
    // This is a simplified version
    final speech = SpeechToText();
    final available = await speech.initialize();

    if (available) {
      speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            final text = result.recognizedWords;
            model.maskController?.text = text;
            Provider.of<HZFFormController>(context, listen: false)
                .updateFieldValue(model.tag, text);
          }
        },
      );
    }
  }
}
