import 'package:flutter/material.dart';
import 'package:hzfform/hzfform.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formController = HZFormController();

  void _submitForm() {
    if (_formController.isValid) {
      debugPrint(_formController.values.toString());
      // Process form data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            SizedBox(height: 16),
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
