import 'package:flutter/material.dart';

import '../core/enums.dart';
import 'field_model.dart';

class HZFFormCheckboxModel extends HZFFormFieldModel {
  /// Label text
  final String? label;

  /// Label style
  final TextStyle? labelStyle;

  /// Label builder for custom label widget
  final Widget Function(BuildContext, bool)? labelBuilder;

  /// Active color (thumb)
  final Color? activeColor;

  /// Active track color
  final Color? activeTrackColor;

  /// Inactive thumb color
  final Color? inactiveThumbColor;

  /// Inactive track color
  final Color? inactiveTrackColor;

  /// Custom thumb icon
  final WidgetStateProperty<Icon?>? thumbIcon;

  /// Constructor
  HZFFormCheckboxModel({
    required super.tag,
    super.title,
    this.label,
    this.labelStyle,
    this.labelBuilder,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.thumbIcon,
    bool? value,
    super.errorMessage,
    super.helpMessage,
    super.required,
    super.showTitle,
    super.enableReadOnly,
    super.onTap,
    String? Function(bool?)? customValidator,
  }) : super(
          type: HZFFormFieldTypeEnum.checkbox,
          value: value ?? false,
          customValidator: customValidator != null
              ? (value) => customValidator(value as bool?)
              : null,
        );
}


/*
USAGE:

// Basic switch
final notificationsSwitch = HZFFormCheckboxModel(
  tag: 'notifications',
  title: 'Notifications',
  label: 'Enable push notifications',
);

// Styled switch with custom colors
final darkModeSwitch = HZFFormCheckboxModel(
  tag: 'darkMode',
  label: 'Dark Mode',
  activeColor: Colors.indigo,
  activeTrackColor: Colors.indigo.withOpacity(0.5),
  inactiveThumbColor: Colors.grey[300],
  inactiveTrackColor: Colors.grey[400],
);

// Switch with custom thumb icons
final bluetoothSwitch = HZFFormCheckboxModel(
  tag: 'bluetooth',
  label: 'Bluetooth',
  thumbIcon: MaterialStateProperty.resolveWith<Icon?>((states) {
    if (states.contains(MaterialState.selected)) {
      return const Icon(Icons.bluetooth, size: 16, color: Colors.white);
    }
    return const Icon(Icons.bluetooth_disabled, size: 16, color: Colors.grey);
  }),
);

*/