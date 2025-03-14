// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

import '../models/field_model.dart';
import 'controller.dart';
import 'enums.dart';
import 'form.dart';
import 'styles.dart';

/// Section for grouping form fields
class HZFFormSection {
  /// Section identifier
  final String id;

  /// Section title
  final String? title;

  /// Section subtitle
  final String? subtitle;

  /// Form fields in this section
  final List<HZFFormFieldModel> models;

  /// Section icon
  final IconData? icon;

  /// Whether section is initially expanded
  final bool initiallyExpanded;

  /// Whether section is collapsible
  final bool collapsible;

  /// Background color
  final Color? backgroundColor;

  /// Custom decoration
  final BoxDecoration? decoration;

  /// Custom padding
  final EdgeInsets? padding;

  /// Custom section style that overrides form style
  final HZFFormStyle? style;

  /// Custom header builder
  final Widget Function(BuildContext, HZFFormSection, bool)? headerBuilder;

  /// Constructor
  HZFFormSection({
    String? id,
    this.title,
    this.subtitle,
    required this.models,
    this.icon,
    this.initiallyExpanded = true,
    this.collapsible = true,
    this.backgroundColor,
    this.decoration,
    this.padding,
    this.style,
    this.headerBuilder,
  }) : id = id ??
            title?.toLowerCase().replaceAll(' ', '_') ??
            UniqueKey().toString();

  /// Create a copy with some properties changed
  HZFFormSection copyWith({
    String? id,
    String? title,
    String? subtitle,
    List<HZFFormFieldModel>? models,
    IconData? icon,
    bool? initiallyExpanded,
    bool? collapsible,
    Color? backgroundColor,
    BoxDecoration? decoration,
    EdgeInsets? padding,
    HZFFormStyle? style,
    Widget Function(BuildContext, HZFFormSection, bool)? headerBuilder,
  }) {
    return HZFFormSection(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      models: models ?? this.models,
      icon: icon ?? this.icon,
      initiallyExpanded: initiallyExpanded ?? this.initiallyExpanded,
      collapsible: collapsible ?? this.collapsible,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      decoration: decoration ?? this.decoration,
      padding: padding ?? this.padding,
      style: style ?? this.style,
      headerBuilder: headerBuilder ?? this.headerBuilder,
    );
  }
}

/// Section widget implementation
class HZFFormSectionWidget extends StatefulWidget {
  final HZFFormSection section;
  final HZFFormController controller;
  final HZFFormStyle formStyle;

  const HZFFormSectionWidget({
    Key? key,
    required this.section,
    required this.controller,
    required this.formStyle,
  }) : super(key: key);

  @override
  State<HZFFormSectionWidget> createState() => _HZFFormSectionWidgetState();
}

class _HZFFormSectionWidgetState extends State<HZFFormSectionWidget> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.section.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    // Merge form style with section style
    final style = widget.formStyle.merge(widget.section.style);

    // Create section decoration
    final decoration = widget.section.decoration ??
        (widget.section.backgroundColor != null
            ? BoxDecoration(
                color: widget.section.backgroundColor,
                borderRadius: style.borderRadius,
              )
            : null);

    // Create section padding
    final padding = widget.section.padding ?? style.sectionPadding;

    return AnimatedContainer(
      duration: style.animationDuration,
      decoration: decoration,
      margin: EdgeInsets.only(bottom: style.sectionSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Section header
          _buildSectionHeader(context, style),

          // Section content
          AnimatedCrossFade(
            duration: style.animationDuration,
            crossFadeState: _isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildFields(style),
              ),
            ),
            secondChild: const SizedBox(height: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, HZFFormStyle style) {
    // Use custom header builder if provided
    if (widget.section.headerBuilder != null) {
      return InkWell(
        onTap: widget.section.collapsible ? _toggleExpanded : null,
        child:
            widget.section.headerBuilder!(context, widget.section, _isExpanded),
      );
    }

    // Default header implementation
    if (widget.section.title == null && widget.section.icon == null) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: widget.section.collapsible ? _toggleExpanded : null,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Section icon
            if (widget.section.icon != null) ...[
              Icon(
                widget.section.icon,
                color: style.sectionTitleStyle?.color,
              ),
              const SizedBox(width: 8),
            ],

            // Section title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.section.title != null)
                    Text(
                      widget.section.title!,
                      style: style.sectionTitleStyle,
                    ),
                  if (widget.section.subtitle != null)
                    Text(
                      widget.section.subtitle!,
                      style: style.helpStyle,
                    ),
                ],
              ),
            ),

            // Expand/collapse icon
            if (widget.section.collapsible)
              Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                color: style.sectionTitleStyle?.color,
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFields(HZFFormStyle style) {
    final result = <Widget>[];
    final fieldBuilders = HZFForm.getFieldBuilders();

    for (int i = 0; i < widget.section.models.length; i++) {
      final model = widget.section.models[i];

      // Add spacing between fields (except before the first one)
      if (i > 0) {
        result.add(SizedBox(height: style.fieldSpacing));
      }

      // Build the field using the appropriate builder
      final builder = fieldBuilders[model.type] ??
          fieldBuilders[HZFFormFieldTypeEnum.text]!;
      result.add(
        HZFFormFieldWidget(
          model: model,
          controller: widget.controller,
          builder: builder,
          style: style,
        ),
      );
    }

    return result;
  }

  void _toggleExpanded() {
    if (!widget.section.collapsible) return;
    setState(() => _isExpanded = !_isExpanded);
  }
}


/*
USAGE:

// Basic section
final personalInfoSection = HZFFormSection(
  title: 'Personal Information',
  models: [
    HZFFormTextFieldModel(
      tag: 'name',
      title: 'Full Name',
      required: true,
    ),
    HZFFormTextFieldModel(
      tag: 'email',
      title: 'Email Address',
      keyboardType: TextInputType.emailAddress,
    ),
    HZFFormDatePickerModel(
      tag: 'birthdate',
      title: 'Date of Birth',
    ),
  ],
);

// Section with icon and custom styling
final addressSection = HZFFormSection(
  title: 'Address',
  subtitle: 'Where should we deliver your order?',
  icon: Icons.location_on,
  backgroundColor: Colors.blue[50],
  padding: EdgeInsets.all(16),
  style: HZFFormStyle(
    titleStyle: TextStyle(
      color: Colors.blue[800],
      fontWeight: FontWeight.bold,
    ),
  ),
  models: [
    HZFFormTextFieldModel(tag: 'street', title: 'Street Address'),
    HZFFormTextFieldModel(tag: 'city', title: 'City'),
    HZFFormTextFieldModel(tag: 'zip', title: 'ZIP Code'),
  ],
);

// Collapsible section
final preferencesSection = HZFFormSection(
  title: 'Preferences',
  icon: Icons.settings,
  initiallyExpanded: false,
  collapsible: true,
  models: [
    HZFFormCheckboxModel(tag: 'notifications', title: 'Enable Notifications'),
    HZFFormSliderModel(
      tag: 'fontSize',
      title: 'Font Size',
      min: 12,
      max: 24,
      divisions: 6,
    ),
  ],
);

// Custom header builder
final customHeaderSection = HZFFormSection(
  models: [
    HZFFormTextFieldModel(tag: 'notes', title: 'Additional Notes'),
  ],
  headerBuilder: (context, section, isExpanded) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.blue],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          Icon(Icons.notes, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Custom Notes Section',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.white,
          ),
        ],
      ),
    );
  },
);

*/