// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import '../fields/field_builders.dart';
import '../fields/hzf_field_builder.dart';
import '../models/field_model.dart';
import 'actions.dart';
import 'controller.dart';
import 'enums.dart';
import 'sections.dart';
import 'styles.dart';

/// Dynamic form builder with customizable fields and sections
class HZFForm extends StatefulWidget {
  /// Form controller
  final HZFFormController controller;

  /// Field models (used when not using sections)
  final List<HZFFormFieldModel>? models;

  /// Form sections
  final List<HZFFormSection>? sections;

  /// Form style
  final HZFFormStyle style;

  /// Form actions
  final HZFFormActions? actions;

  /// Padding around the form
  final EdgeInsets? padding;

  /// Scroll physics
  final ScrollPhysics? scrollPhysics;

  /// Scroll controller
  final ScrollController? scrollController;

  /// Form completion callback
  final Function(Map<String, dynamic>)? onSubmit;

  /// Form change callback
  final Function(Map<String, dynamic>)? onChanged;

  /// Auto-validate mode
  final AutovalidateMode autovalidateMode;

  /// Custom field builders registry
  static final Map<HZFFormFieldTypeEnum, FieldBuilder Function()>
      _fieldBuilders = {};

  /// Constructor
  const HZFForm({
    super.key,
    required this.controller,
    this.models,
    this.sections,
    this.style = const HZFFormStyle(),
    this.actions,
    this.padding,
    this.scrollPhysics,
    this.scrollController,
    this.onSubmit,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.disabled,
  }) : assert(models != null || sections != null,
            'Either models or sections must be provided');

  @override
  State<HZFForm> createState() => _HZFFormState();

  /// Register custom field builder
  static void registerFieldBuilder(
    HZFFormFieldTypeEnum type,
    FieldBuilder Function() builderFactory,
  ) {
    _fieldBuilders[type] = builderFactory;
  }

  /// Register custom field builder with type string
  static void registerCustomBuilder(
    String typeString,
    Widget Function(HZFFormFieldModel, HZFFormController, BuildContext) builder,
  ) {
    // Create custom enum value or use a mapping system
    final customType = HZFFormFieldTypeEnum.custom;

    _fieldBuilders[customType] = () => _CustomFieldBuilder(
          typeString: typeString,
          builderFn: builder,
        );
  }

  /// Get field builders map
  static Map<HZFFormFieldTypeEnum, FieldBuilder> getFieldBuilders() {
    final builders = <HZFFormFieldTypeEnum, FieldBuilder>{};

    // Initialize default builders
    _initializeDefaultBuilders();

    // Create instances of all registered builders
    for (final entry in _fieldBuilders.entries) {
      builders[entry.key] = entry.value();
    }

    return builders;
  }

  /// Initialize default field builders
  static void _initializeDefaultBuilders() {
    // Register default builders if not already registered
    if (_fieldBuilders.isEmpty) {
      _fieldBuilders[HZFFormFieldTypeEnum.text] = () => TextFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.searchableDropdown] =
          () => SearchableDropdownBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.checkbox] =
          () => CheckboxFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.datePicker] =
          () => DatePickerFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.slider] = () => SliderFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.colorPicker] =
          () => ColorPickerFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.mapPicker] =
          () => MapPickerFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.signaturePicker] =
          () => SignatureFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.metaData] =
          () => MetaDataFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.qrCodePicker] =
          () => QRCodeFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.documentPicker] =
          () => DocumentPickerFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.videoPicker] =
          () => VideoPickerFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.audioPicker] =
          () => AudioPickerFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.imagePicker] =
          () => ImagePickerFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.multiImagePicker] =
          () => MultiImagePickerFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.radioChips] =
          () => RadioChipsGroupBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.checkChips] =
          () => CheckboxChipsListBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.textPlain] =
          () => TextAreaFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.password] =
          () => PasswordFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.dateRangePicker] =
          () => DateRangePickerBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.timePicker] =
          () => TimePickerFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.bankCard] =
          () => BankCardFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.checkChips] =
          () => CheckboxChipsListBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.checkList] =
          () => CheckListFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.dateRangePicker] =
          () => DateRangePickerBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.number] = () => NumberFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.radioChips] =
          () => RadioChipsGroupBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.radioGroup] =
          () => RadioGroupFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.slider] = () => SliderFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.sliderRange] =
          () => SliderRangeFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.spinner] =
          () => SpinnerFieldBuilder();
      _fieldBuilders[HZFFormFieldTypeEnum.textPlain] =
          () => TextAreaFieldBuilder();
    }
  }
}

class _HZFFormState extends State<HZFForm> {
  @override
  void initState() {
    super.initState();
    _registerFields();

    // Listen for form changes
    widget.controller.addListener(_handleFormChanged);

    // Set auto-validate mode
    if (widget.autovalidateMode == AutovalidateMode.always) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.controller.validate();
      });
    }
  }

  @override
  void didUpdateWidget(HZFForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controller listener if changed
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleFormChanged);
      widget.controller.addListener(_handleFormChanged);
      _registerFields();
    }

    // Re-register fields if models or sections changed
    if (oldWidget.models != widget.models ||
        oldWidget.sections != widget.sections) {
      _registerFields();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleFormChanged);
    super.dispose();
  }

  void _registerFields() {
    // Register all fields with the controller
    if (widget.models != null) {
      widget.controller.registerFields(widget.models!);
    }

    if (widget.sections != null) {
      for (final section in widget.sections!) {
        widget.controller.registerFields(section.models);
      }
    }

    // Register action buttons
    if (widget.actions != null) {
      if (widget.actions!.submitButton != null) {
        widget.controller
            .registerButton('submit', widget.actions!.submitButton!);
      }
      if (widget.actions!.cancelButton != null) {
        widget.controller
            .registerButton('cancel', widget.actions!.cancelButton!);
      }
      if (widget.actions!.resetButton != null) {
        widget.controller.registerButton('reset', widget.actions!.resetButton!);
      }
    }
  }

  void _handleFormChanged() {
    widget.onChanged?.call(widget.controller.getFormValues());
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = widget.style;

    return SingleChildScrollView(
      physics: widget.scrollPhysics,
      controller: widget.scrollController,
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Build sections or create default section from models
          if (widget.sections != null)
            ...widget.sections!.map((section) => HZFFormSectionWidget(
                  section: section,
                  controller: widget.controller,
                  formStyle: effectiveStyle,
                )),

          if (widget.sections == null && widget.models != null)
            HZFFormSectionWidget(
              section: HZFFormSection(models: widget.models!),
              controller: widget.controller,
              formStyle: effectiveStyle,
            ),

          // Form actions
          if (widget.actions != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: widget.actions!.build(
                context,
                widget.controller,
                effectiveStyle,
                onSubmit: widget.onSubmit,
              ),
            ),
        ],
      ),
    );
  }
}

/// Field builder widget
class HZFFormFieldWidget extends StatelessWidget {
  final HZFFormFieldModel model;
  final HZFFormController controller;
  final FieldBuilder builder;
  final HZFFormStyle style;

  const HZFFormFieldWidget({
    Key? key,
    required this.model,
    required this.controller,
    required this.builder,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check visibility condition
    if (!controller.isFieldVisible(model.tag)) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field title
        if (model.showTitle != false && model.title != null)
          Row(
            children: [
              Text(
                model.title!,
                style: style.titleStyle,
              ),
              if (model.required == true)
                style.requiredIndicator ??
                    const Text(
                      ' *',
                      style: TextStyle(color: Colors.red),
                    ),
            ],
          ),

        if (model.showTitle != false && model.title != null)
          const SizedBox(height: 8),

        // Field content
        builder.build(model, controller, context),

        // Error message
        Builder(builder: (context) {
          final error = controller.getFieldError(model.tag);
          if (error == null) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              error,
              style: style.errorStyle ??
                  TextStyle(color: Colors.red[700], fontSize: 12),
            ),
          );
        }),

        // Helper message
        if (model.helpMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              model.helpMessage!,
              style: style.helpStyle ??
                  TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
      ],
    );
  }
}

/// Custom field builder implementation
class _CustomFieldBuilder implements FieldBuilder {
  final String typeString;
  final Widget Function(HZFFormFieldModel, HZFFormController, BuildContext)
      builderFn;

  _CustomFieldBuilder({
    required this.typeString,
    required this.builderFn,
  });

  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    // Directly return the Widget from the builder function
    return builderFn(model, controller, context);
  }
}
