import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/enums.dart';
import '../models/field_model.dart';
import '../core/controller.dart';
import 'field_builders.dart';

class HZFFormField extends StatefulWidget {
  final HZFFormFieldModel model;
  final EdgeInsetsGeometry padding;

  const HZFFormField({
    super.key,
    required this.model,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
  });

  @override
  State<HZFFormField> createState() => _HZFFormFieldState();
}

class _HZFFormFieldState extends State<HZFFormField> {
  late HZFFormController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = Provider.of<HZFFormController>(context, listen: false);
    _controller.registerField(widget.model);
  }

  @override
  void dispose() {
    _controller.unregisterField(widget.model.tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Padding(
          padding: widget.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldTitle(context),
              _buildFieldByType(),
              _buildErrorMessage(),
              _buildHelpMessage(),
            ],
          ),
        );
      },
    );
  }

  // Title section with required indicator
  Widget _buildFieldTitle(BuildContext context) {
    if (widget.model.showTitle == false || widget.model.title == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            widget.model.title!,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          if (widget.model.required == true)
            const Text(' *', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  // Error message if present
  Widget _buildErrorMessage() {
    if (widget.model.status != HZFFormFieldStatusEnum.error ||
        widget.model.errorMessage == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        widget.model.errorMessage!,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  // Help message if present
  Widget _buildHelpMessage() {
    if (widget.model.helpMessage == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        widget.model.helpMessage!,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }

  // Field factory based on type
  Widget _buildFieldByType() {
    // Use factory pattern to get appropriate builder
    return HZFFormFieldFactory.buildField(
      model: widget.model,
      controller: _controller,
      context: context,
    );
  }
}

/// Factory for building different field types
class HZFFormFieldFactory {
  static Widget buildField({
    required HZFFormFieldModel model,
    required HZFFormController controller,
    required BuildContext context,
  }) {
    switch (model.type) {
      case HZFFormFieldTypeEnum.text:
        return TextFieldBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.textPlain:
        return TextAreaFieldBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.password:
        return PasswordFieldBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.datePicker:
        return DatePickerBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.dateRangePicker:
        return DateRangePickerBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.imagePicker:
        return ImagePickerBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.multiImagePicker:
        return MultiImagePickerBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.radioChips:
        return RadioChipsGroupBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.checkChips:
        return CheckChipsListBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.checkList:
        return CheckListBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.spinner:
        return SpinnerFieldBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.timePicker:
        return TimePickerBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.number:
        return NumberFieldBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.radioGroup:
        return RadioGroupFieldBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.slider:
        return SliderBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.sliderRange:
        return SliderRangeBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.bankCard:
        return BankCardFieldBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.searchableDropdown:
        return SearchableDropdownBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.mapPicker:
        return MapPickerBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.colorPicker:
        return ColorPickerBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.qrCodePicker:
        return QRCodeFieldBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.documentPicker:
        return DocumentPickerFieldBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.videoPicker:
        return VideoPickerFieldBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.audioPicker:
        return AudioPickerFieldBuilder().build(model, controller, context);

      case HZFFormFieldTypeEnum.signaturePicker:
        return SignatureFieldBuilder().build(model, controller, context);

      default:
        return const SizedBox(
          child: Text("Unsupported field type"),
        );
    }
  }
}

// TODO: RTL support and localization and themes
