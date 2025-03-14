import 'package:flutter/material.dart';
import 'controller.dart';

class HZFForm extends StatefulWidget {
  /// Form controller to manage state
  final HZFFormController controller;

  /// Form fields and other widgets
  final List<Widget> children;

  /// Submit callback
  final VoidCallback? onSubmit;

  /// Custom submit button
  final Widget? submitButton;

  /// Padding between form elements
  final EdgeInsetsGeometry contentPadding;

  /// Whether to add padding between fields in Percents
  final double? spacingPercent;

  /// Scroll physics
  final ScrollPhysics? scrollPhysics;

  const HZFForm({
    super.key,
    required this.controller,
    required this.children,
    this.onSubmit,
    this.submitButton,
    this.contentPadding = const EdgeInsets.all(16.0),
    this.spacingPercent = 5,
    this.scrollPhysics,
  });

  @override
  State<HZFForm> createState() => _HZFFormState();
}

class _HZFFormState extends State<HZFForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: widget.contentPadding,
        child: SingleChildScrollView(
          physics: widget.scrollPhysics,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildFormChildren(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    var spacer = height * 0.05;
    final List<Widget> formChildren = [];

    // Add children with optional padding
    for (int i = 0; i < widget.children.length; i++) {
      formChildren.add(widget.children[i]);

      // Add padding between fields if needed
      if (widget.spacingPercent != null && i < widget.children.length - 1) {
        formChildren.add(SizedBox(height: spacer / 100));
      }
    }

    // Add submit button if onSubmit provided
    if (widget.submitButton != null) {
      formChildren.add(SizedBox(height: spacer / 50));
      formChildren.add(widget.submitButton!);
    }

    return formChildren;
  }

  void _handleSubmit() {
    // Flutter form validation
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Custom controller validation
      final isValid = widget.controller.validateForm();

      if (isValid && widget.onSubmit != null) {
        widget.onSubmit!();
      }
    }
  }

  /// Public method to trigger form submission
  void submitForm() => _handleSubmit();
}
