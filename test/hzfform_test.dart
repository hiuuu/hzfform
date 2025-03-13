// ignore_for_file: unused_local_variable, unused_field

import 'package:flutter/material.dart';
import 'package:hzfform/hzfform.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formController = HZFormController();
  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    if (_formController.isValid) {
      debugPrint(_formController.values.toString());
      // Process form data
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var spacer = height * 0.05;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('HZForm Example')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: HZForm(
          controller: _formController,
          children: [
            HZTextField(
              name: 'name',
              label: 'Full Name',
              controller: _formController,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: spacer),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
