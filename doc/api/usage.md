# How to Use HZFForm

## Basic Setup

```dart
// 1. Create controller
final formController = HZFFormController();

// 2. Define fields
final nameField = HZFFormTextPlainModel(
  tag: 'name',
  title: 'Full Name',
  required: true,
);

// 3. Build form
@override
Widget build(BuildContext context) {
  return HZFForm(
    controller: formController,
    onSubmit: _handleSubmit,
    children: [
      HZFFormField(model: nameField),
      // More fields...
    ],
  );
}

// 4. Handle submission
void _handleSubmit() {
  final values = formController.getFormValues();
  print('Name: ${values['name']}');
  // Process data...
}
```

## Field Types

```dart
// Text input
HZFFormTextModel(
  tag: 'email',
  title: 'Email',
  hint: 'your@email.com',
  validateRegEx: RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
)

// Password
HZFFormPasswordModel(
  tag: 'password',
  title: 'Password',
  minLength: 8,
)

// Date picker
HZFFormDatePickerModel(
  tag: 'birthdate',
  title: 'Birth Date',
  isPastAvailable: true,
)

// Multi-select chips
HZFFormCheckChipsListModel(
  tag: 'interests',
  title: 'Interests',
  items: [
    HZFFormCheckChipsDataModel(id: 'tech', label: 'Technology'),
    HZFFormCheckChipsDataModel(id: 'sports', label: 'Sports'),
  ],
)
```

## Form Validation

```dart
// Manual validation
ElevatedButton(
  onPressed: () {
    if (formController.validateForm()) {
      // Form is valid
    }
  },
  child: Text('Validate'),
)

// Field-specific validation
formController.setFieldError('email', 'Email already exists');
```

## Custom Submission

```dart
// Reference to form key
final formKey = GlobalKey<_HZFFormState>();

// Custom submit button
ElevatedButton(
  onPressed: () => formKey.currentState?.submitForm(),
  child: Text('Custom Submit'),
)

// Form with key
HZFForm(
  key: formKey,
  controller: formController,
  onSubmit: _handleSubmit,
  submitButton: null, // Hide default button
  children: [...],
)
```

→ Create controller → define fields → build form → handle submission
→ Built-in validation for required fields and regex patterns
→ Customizable layout with optional padding and scrolling