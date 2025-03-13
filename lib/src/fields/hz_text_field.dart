import 'package:flutter/material.dart';
import '../controller.dart';

class HZTextField extends StatefulWidget {
  final String name;
  final String label;
  final String? initialValue;
  final String? Function(String?)? validator;
  final HZFormController controller;
  final TextInputType keyboardType;
  final int maxLines;

  const HZTextField({
    super.key,
    required this.name,
    required this.label,
    required this.controller,
    this.initialValue,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  State<HZTextField> createState() => _HZTextFieldState();
}

class _HZTextFieldState extends State<HZTextField> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialValue);
    widget.controller.setValue(widget.name, widget.initialValue);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textController,
      decoration: InputDecoration(
        labelText: widget.label,
        border: OutlineInputBorder(),
      ),
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      validator: (value) {
        final error = widget.validator?.call(value);
        widget.controller.setValidity(widget.name, error == null);
        return error;
      },
      onChanged: (value) {
        widget.controller.setValue(widget.name, value);
      },
    );
  }
}
