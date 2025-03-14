# HZFForm Package Overview

A powerful, customizable Flutter forms library with rich field types, validation, and media support.

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Core dependencies
  provider: ^6.0.5
  intl: ^0.18.1
  uuid: ^4.1.0
  
  # Field type support
  google_maps_flutter: ^2.5.0
  file_picker: ^6.1.1
  image_picker: ^1.0.4
  signature: ^5.4.0
  qr_flutter: ^4.1.0
  mobile_scanner: ^3.4.1
  dropdown_search: ^5.0.6
  
  # Media handling
  path_provider: ^2.1.1
  ffmpeg_kit_flutter: ^6.0.3
  just_audio: ^0.9.35
  permission_handler: ^11.0.1
  
  # Utilities
  open_file: ^3.3.2
  image: ^4.1.3
  geocoding: ^2.1.1
  geolocator: ^10.0.1
```

## Features

→ **30+ Field Types**: From basic text to advanced media capture
→ **Validation**: Built-in and custom validators
→ **Form Sections**: Logical grouping of fields
→ **Dependency Handling**: Fields that react to other fields
→ **Media Support**: Document, signature, audio, video, location
→ **Theming**: Comprehensive styling options

## Usage Example

```dart
// Create form controller
final formController = HZFFormController();

// Define fields
final fields = [
  HZFFormTextFieldModel(
    tag: 'name',
    title: 'Full Name',
    required: true,
  ),
  HZFFormEmailFieldModel(
    tag: 'email',
    title: 'Email Address',
  ),
  HZFFormSignatureModel(
    tag: 'signature',
    title: 'Signature',
  ),
];

// Create form
HZFForm(
  controller: formController,
  models: fields,
  onSubmit: (data) {
    print('Form submitted: $data');
  },
)
```

## Key Benefits

 Feature  Benefit  Modular  Compose forms with reusable components  Extensible  Create custom field types  Reactive  Fields update based on dependencies  Validated  Comprehensive error checking  Media-rich  Camera, location, documents support  Cross-platform  Works on iOS, Android, and web 

→ **Getting started**: 

# HZFForm - Flutter Dynamic Form Builder

## Installation

```yaml
dependencies:
  hzfform: ^1.0.0
```

```bash
flutter pub get
```

## Basic Usage

```dart
// Import package
import 'package:hzfform/hzfform.dart';

// Create form models
final nameField = HZFFormTextFieldModel(
  tag: 'name',
  title: 'Full Name',
  required: true,
);

final emailField = HZFFormTextFieldModel(
  tag: 'email',
  title: 'Email Address',
  keyboardType: TextInputType.emailAddress,
  validateRegEx: RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
  errorMessage: 'Please enter a valid email',
);

// Create form
final form = HZFForm(
  controller: formController,
  models: [nameField, emailField],
);

// Handle submission
ElevatedButton(
  onPressed: () {
    if (formController.validate()) {
      final data = formController.getFormValues();
      print('Name: ${data['name']}');
      print('Email: ${data['email']}');
    }
  },
  child: Text('Submit'),
)
```

## Field Types

 Field Type     | Model Class                     | Description
 Text             `HZFFormTextFieldModel`           Text input with validation  
 Dropdown         `HZFFormDropdownModel`            Dropdown selection  
 Checkbox         `HZFFormCheckboxModel`            Single checkbox  
 Radio            `HZFFormRadioModel`               Radio button group  
 Date             `HZFFormDatePickerModel`          Date picker  
 Slider           `HZFFormSliderModel`              Value slider  
 Color            `HZFFormColorPickerModel`         Color selection  
 Map              `HZFFormMapPickerModel`           Location picker  
 Signature        `HZFFormSignatureModel`           Signature capture  
 Metadata         `HZFFormMetaDataModel`            Key-value pairs  
 QR Code          `HZFFormQRCodeModel`              QR code scanner/generator  
 Document         `HZFFormDocumentPickerModel`      Document upload/scan  
 Video            `HZFFormVideoPickerModel`         Video recording/selection  
 Audio            `HZFFormAudioPickerModel`         Audio recording/selection 

## Advanced Configuration

### Form Controller

```dart
// Create controller
final controller = HZFFormController();

// Set initial values
controller.initFormValues({
  'name': 'John Doe',
  'email': 'john@example.com',
});

// Listen for changes
controller.addListener(() {
  print('Form updated: ${controller.getFormValues()}');
});

// Field-specific listener
controller.addFieldListener('email', (value) {
  print('Email changed: $value');
});

// Validate specific field
controller.validateField('email');
```

### Custom Field Validation

```dart
final passwordField = HZFFormTextFieldModel(
  tag: 'password',
  title: 'Password',
  obscureText: true,
  customValidator: (value) {
    if (value == null || value.toString().length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null; // Valid
  },
);
```

### Field Dependencies

```dart
final countryField = HZFFormDropdownModel(
  tag: 'country',
  title: 'Country',
  items: ['USA', 'Canada', 'UK'],
);

final stateField = HZFFormDropdownModel(
  tag: 'state',
  title: 'State/Province',
  dependsOn: 'country',
  itemsBuilder: (country) {
    switch(country) {
      case 'USA': return ['California', 'Texas', 'New York'];
      case 'Canada': return ['Ontario', 'Quebec', 'British Columbia'];
      case 'UK': return ['England', 'Scotland', 'Wales'];
      default: return [];
    }
  },
);
```

## Media Fields Examples

### Signature Capture

```dart
final signatureField = HZFFormSignatureModel(
  tag: 'signature',
  title: 'Signature',
  height: 200,
  penColor: Colors.blue,
  strokeWidth: 3.0,
  onSignatureCaptured: (bytes) {
    // Save signature image
    saveSignature(bytes);
  },
);
```

### Location Picker

```dart
final locationField = HZFFormMapPickerModel(
  tag: 'location',
  title: 'Business Location',
  defaultCenter: LatLng(37.7749, -122.4194),
  enableSearch: true,
  placesClient: GooglePlacesClient(apiKey: 'YOUR_API_KEY'),
);
```

### Document Scanner

```dart
final documentField = HZFFormDocumentPickerModel(
  tag: 'document',
  title: 'ID Document',
  enableScanning: true,
  fileType: FileType.image,
  scanHelpText: 'Position your ID within the frame',
);
```

## Form Styling

```dart
HZFForm(
  controller: controller,
  models: fields,
  style: HZFFormStyle(
    inputDecoration: InputDecoration(
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.grey[100],
    ),
    fieldSpacing: 16.0,
    sectionSpacing: 24.0,
    titleStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    ),
    errorStyle: TextStyle(
      color: Colors.red[700],
      fontSize: 12.0,
    ),
  ),
)
```

## Form Sections

```dart
HZFForm(
  controller: controller,
  sections: [
    HZFFormSection(
      title: 'Personal Information',
      models: [nameField, emailField, phoneField],
    ),
    HZFFormSection(
      title: 'Address',
      models: [addressField, cityField, zipField],
    ),
  ],
)
```

## Form Actions

```dart
HZFForm(
  controller: controller,
  models: fields,
  actions: HZFFormActions(
    submitButton: HZFFormButton(
      text: 'Submit Application',
      icon: Icons.send,
      onPressed: (formData) {
        submitApplication(formData);
      },
    ),
    cancelButton: HZFFormButton(
      text: 'Cancel',
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
      ),
      onPressed: (_) {
        Navigator.pop(context);
      },
    ),
  ),
)
```

## Custom Field Builder

```dart
// Create custom field model
class RatingFieldModel extends HZFFormFieldModel {
  final int maxStars;
  final Function(int)? onRatingChanged;
  
  RatingFieldModel({
    required String tag,
    required String title,
    this.maxStars = 5,
    this.onRatingChanged,
  }) : super(
    tag: tag,
    title: title,
    type: HZFFormFieldTypeEnum.custom,
  );
}

// Register custom field builder
HZFForm.registerCustomBuilder(
  'rating',
  (model, controller, context) {
    final ratingModel = model as RatingFieldModel;
    final currentRating = model.value as int? ?? 0;
    
    return Row(
      children: List.generate(
        ratingModel.maxStars,
        (index) => IconButton(
          icon: Icon(
            index < currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            controller.updateFieldValue(model.tag, index + 1);
            ratingModel.onRatingChanged?.call(index + 1);
          },
        ),
      ),
    );
  },
);
```

## Performance Tips

- Use `const` widgets when possible
- Implement lazy loading for large forms
- Use `weight` property to control field order
- Consider form pagination for complex workflows
- Optimize image compression in media fields





