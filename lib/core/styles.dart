import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Style configuration for HZFForm
class HZFFormStyle {
  /// Decoration for input fields
  final InputDecoration? inputDecoration;

  /// Vertical spacing between fields
  final double fieldSpacing;

  /// Vertical spacing between form sections
  final double sectionSpacing;

  /// Style for field titles
  final TextStyle? titleStyle;

  /// Style for error messages
  final TextStyle? errorStyle;

  /// Style for help messages
  final TextStyle? helpStyle;

  /// Padding for form sections
  final EdgeInsets sectionPadding;

  /// Decoration for form sections
  final BoxDecoration? sectionDecoration;

  /// Section title style
  final TextStyle? sectionTitleStyle;

  /// Required field indicator widget
  final Widget? requiredIndicator;

  /// Global border radius for input fields
  final BorderRadius? borderRadius;

  /// Button theme for form actions
  final ButtonStyle? buttonStyle;

  /// Theme for checkboxes
  final CheckboxThemeData? checkboxTheme;

  /// Theme for radio buttons
  final RadioThemeData? radioTheme;

  /// Theme for sliders
  final SliderThemeData? sliderTheme;

  /// Theme for switches
  final SwitchThemeData? switchTheme;

  /// Animation duration for field transitions
  final Duration animationDuration;

  /// Create a form style configuration
  const HZFFormStyle({
    this.inputDecoration,
    this.fieldSpacing = 16.0,
    this.sectionSpacing = 24.0,
    this.titleStyle,
    this.errorStyle,
    this.helpStyle,
    this.sectionPadding = const EdgeInsets.all(16.0),
    this.sectionDecoration,
    this.sectionTitleStyle,
    this.requiredIndicator,
    this.borderRadius,
    this.buttonStyle,
    this.checkboxTheme,
    this.radioTheme,
    this.sliderTheme,
    this.switchTheme,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  /// Create a copy with some properties changed
  HZFFormStyle copyWith({
    InputDecoration? inputDecoration,
    double? fieldSpacing,
    double? sectionSpacing,
    TextStyle? titleStyle,
    TextStyle? errorStyle,
    TextStyle? helpStyle,
    EdgeInsets? sectionPadding,
    BoxDecoration? sectionDecoration,
    TextStyle? sectionTitleStyle,
    Widget? requiredIndicator,
    BorderRadius? borderRadius,
    ButtonStyle? buttonStyle,
    CheckboxThemeData? checkboxTheme,
    RadioThemeData? radioTheme,
    SliderThemeData? sliderTheme,
    SwitchThemeData? switchTheme,
    Duration? animationDuration,
  }) {
    return HZFFormStyle(
      inputDecoration: inputDecoration ?? this.inputDecoration,
      fieldSpacing: fieldSpacing ?? this.fieldSpacing,
      sectionSpacing: sectionSpacing ?? this.sectionSpacing,
      titleStyle: titleStyle ?? this.titleStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      helpStyle: helpStyle ?? this.helpStyle,
      sectionPadding: sectionPadding ?? this.sectionPadding,
      sectionDecoration: sectionDecoration ?? this.sectionDecoration,
      sectionTitleStyle: sectionTitleStyle ?? this.sectionTitleStyle,
      requiredIndicator: requiredIndicator ?? this.requiredIndicator,
      borderRadius: borderRadius ?? this.borderRadius,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      checkboxTheme: checkboxTheme ?? this.checkboxTheme,
      radioTheme: radioTheme ?? this.radioTheme,
      sliderTheme: sliderTheme ?? this.sliderTheme,
      switchTheme: switchTheme ?? this.switchTheme,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }

  /// Create a merged style from two style configurations
  HZFFormStyle merge(HZFFormStyle? other) {
    if (other == null) return this;

    return copyWith(
      inputDecoration: other.inputDecoration,
      fieldSpacing: other.fieldSpacing,
      sectionSpacing: other.sectionSpacing,
      titleStyle: other.titleStyle,
      errorStyle: other.errorStyle,
      helpStyle: other.helpStyle,
      sectionPadding: other.sectionPadding,
      sectionDecoration: other.sectionDecoration,
      sectionTitleStyle: other.sectionTitleStyle,
      requiredIndicator: other.requiredIndicator,
      borderRadius: other.borderRadius,
      buttonStyle: other.buttonStyle,
      checkboxTheme: other.checkboxTheme,
      radioTheme: other.radioTheme,
      sliderTheme: other.sliderTheme,
      switchTheme: other.switchTheme,
      animationDuration: other.animationDuration,
    );
  }

  /// Default style preset - clean material design
  factory HZFFormStyle.material() {
    return HZFFormStyle(
      inputDecoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      fieldSpacing: 16.0,
      sectionSpacing: 24.0,
      titleStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      errorStyle: TextStyle(
        color: Colors.red[700],
        fontSize: 12,
      ),
      helpStyle: TextStyle(
        color: Colors.grey[600],
        fontSize: 12,
        fontStyle: FontStyle.italic,
      ),
      sectionTitleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.grey[800],
      ),
      requiredIndicator: Text(
        ' *',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      borderRadius: BorderRadius.circular(8),
      buttonStyle: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// iOS style preset
  factory HZFFormStyle.cupertino() {
    return HZFFormStyle(
      inputDecoration: InputDecoration(
        border: UnderlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12),
      ),
      fieldSpacing: 20.0,
      sectionSpacing: 32.0,
      titleStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Colors.grey[800],
      ),
      errorStyle: TextStyle(
        color: CupertinoColors.destructiveRed,
        fontSize: 12,
      ),
      helpStyle: TextStyle(
        color: CupertinoColors.systemGrey,
        fontSize: 12,
      ),
      sectionTitleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: CupertinoColors.activeBlue,
      ),
      requiredIndicator: Text(
        ' *',
        style: TextStyle(
          color: CupertinoColors.destructiveRed,
        ),
      ),
      buttonStyle: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(CupertinoColors.activeBlue),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  /// Compact style for dense forms
  factory HZFFormStyle.compact() {
    return HZFFormStyle(
      inputDecoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      fieldSpacing: 8.0,
      sectionSpacing: 16.0,
      titleStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      errorStyle: TextStyle(
        color: Colors.red[700],
        fontSize: 10,
      ),
      helpStyle: TextStyle(
        color: Colors.grey[600],
        fontSize: 10,
      ),
      sectionPadding: EdgeInsets.all(8.0),
      sectionTitleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      requiredIndicator: Text(
        '*',
        style: TextStyle(
          color: Colors.red,
          fontSize: 10,
        ),
      ),
      borderRadius: BorderRadius.circular(4),
      animationDuration: Duration(milliseconds: 150),
    );
  }

  /// Dark theme style
  factory HZFFormStyle.dark() {
    return HZFFormStyle(
      inputDecoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        filled: true,
        fillColor: Colors.grey[800],
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue[400]!),
        ),
      ),
      fieldSpacing: 16.0,
      sectionSpacing: 24.0,
      titleStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Colors.grey[300],
      ),
      errorStyle: TextStyle(
        color: Colors.red[400],
        fontSize: 12,
      ),
      helpStyle: TextStyle(
        color: Colors.grey[500],
        fontSize: 12,
      ),
      sectionPadding: EdgeInsets.all(16.0),
      sectionDecoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      sectionTitleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.blue[300],
      ),
      requiredIndicator: Text(
        ' *',
        style: TextStyle(
          color: Colors.red[400],
          fontWeight: FontWeight.bold,
        ),
      ),
      borderRadius: BorderRadius.circular(8),
      buttonStyle: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }
}


/*
USAGE:

// Basic usage with material design
final form = HZFForm(
  controller: formController,
  models: fields,
  style: HZFFormStyle.material(),
);

// iOS-style form
final iosForm = HZFForm(
  controller: formController,
  models: fields,
  style: HZFFormStyle.cupertino(),
);

// Custom styling
final customForm = HZFForm(
  controller: formController,
  models: fields,
  style: HZFFormStyle(
    inputDecoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
      filled: true,
      fillColor: Colors.blue[50],
    ),
    titleStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.blue[800],
    ),
    requiredIndicator: Icon(
      Icons.star,
      color: Colors.red,
      size: 10,
    ),
    sectionDecoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
  ),
);

// Theme-aware form style
final themeAwareForm = HZFForm(
  controller: formController,
  models: fields,
  style: Theme.of(context).brightness == Brightness.dark
      ? HZFFormStyle.dark()
      : HZFFormStyle.material(),
);

=== Integration with Theme ===

// Create a style from ThemeData
HZFFormStyle styleFromTheme(ThemeData theme) {
  return HZFFormStyle(
    inputDecoration: theme.inputDecorationTheme.copyWith(
      filled: true,
      fillColor: theme.colorScheme.surface,
    ),
    titleStyle: theme.textTheme.titleMedium,
    errorStyle: theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.error,
    ),
    buttonStyle: ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
    ),
    sectionTitleStyle: theme.textTheme.titleLarge,
  );
}

*/