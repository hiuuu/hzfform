import 'package:flutter/material.dart';
import 'controller.dart';

class HZForm extends StatefulWidget {
  final HZFormController controller;
  final List<Widget> children;
  final VoidCallback? onSubmit;

  const HZForm({
    super.key,
    required this.controller,
    required this.children,
    this.onSubmit,
  });

  @override
  State<HZForm> createState() => _HZFormState();
}

class _HZFormState extends State<HZForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.children,
      ),
    );
  }
}
