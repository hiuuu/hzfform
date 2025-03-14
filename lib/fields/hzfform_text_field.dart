import 'package:flutter/material.dart';
import '../core/enums.dart';
import '../widgets/controller.dart';
import '../core/styles.dart';

class HZFFormTextField extends StatefulWidget {
  final String name;
  final String label;
  final String? initialValue;
  final String? Function(String?)? validator;
  final HZFFormController controller;
  final TextInputType keyboardType;
  final int maxLines;
  final int? maxLength;
  final String? placeHolder;
  final bool? showCounter;
  final int? minLength;

  const HZFFormTextField({
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
  State<HZFFormTextField> createState() => _HZFFormTextFieldState();
}

class _HZFFormTextFieldState extends State<HZFFormTextField> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Container(),
    );
  }
}
