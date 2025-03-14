import 'package:flutter/material.dart';

import 'controller.dart';
import 'enums.dart';
import 'styles.dart';

/// Form action buttons configuration
class HZFFormActions {
  /// Primary submit button
  final HZFFormButton? submitButton;

  /// Secondary cancel button
  final HZFFormButton? cancelButton;

  /// Reset form button
  final HZFFormButton? resetButton;

  /// Custom buttons to add
  final List<HZFFormButton>? customButtons;

  /// Button alignment
  final MainAxisAlignment alignment;

  /// Spacing between buttons
  final double spacing;

  /// Wrap buttons if they don't fit
  final bool wrap;

  /// Constructor
  const HZFFormActions({
    this.submitButton,
    this.cancelButton,
    this.resetButton,
    this.customButtons,
    this.alignment = MainAxisAlignment.end,
    this.spacing = 8.0,
    this.wrap = true,
  });

  /// Build action buttons
  Widget build(
      BuildContext context, HZFFormController controller, HZFFormStyle style,
      {Function(Map<String, dynamic>)? onSubmit}) {
    final buttons = <Widget>[];

    // Add cancel button
    if (cancelButton != null) {
      buttons.add(
        cancelButton!.build(context, controller, style),
      );
    }

    // Add reset button
    if (resetButton != null) {
      buttons.add(
        resetButton!.build(context, controller, style),
      );
    }

    // Add custom buttons
    if (customButtons != null && customButtons!.isNotEmpty) {
      for (final button in customButtons!) {
        buttons.add(
          button.build(context, controller, style),
        );
      }
    }

    // Add submit button with onSubmit callback support
    if (submitButton != null) {
      // Create a modified submit button that also calls the form's onSubmit
      final wrappedSubmitButton = HZFFormButton(
        text: submitButton!.text,
        icon: submitButton!.icon,
        style: submitButton!.style,
        type: submitButton!.type,
        onPressed: (data) {
          // Call the button's original onPressed
          submitButton!.onPressed?.call(data);

          // Also call the form's onSubmit if provided
          onSubmit?.call(data);
        },
        enabledWhen: submitButton!.enabledWhen,
        visibleWhen: submitButton!.visibleWhen,
        initialLoading: submitButton!.isLoading.value,
      );

      buttons.add(
        wrappedSubmitButton.build(context, controller, style),
      );
    }

    // Return buttons in a row or wrap
    if (wrap) {
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        alignment: WrapAlignment.values[alignment.index],
        children: buttons,
      );
    } else {
      return Row(
        mainAxisAlignment: alignment,
        children: [
          for (int i = 0; i < buttons.length; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            buttons[i],
          ],
        ],
      );
    }
  }
}

/// Form button configuration
class HZFFormButton {
  /// Button text
  final String text;

  /// Button icon
  final IconData? icon;

  /// Button style
  final ButtonStyle? style;

  /// Button type
  final HZFFormButtonType type;

  /// Button onPressed callback
  final Function(Map<String, dynamic>)? onPressed;

  /// Button enabled condition
  final bool Function(HZFFormController)? enabledWhen;

  /// Button visibility condition
  final bool Function(HZFFormController)? visibleWhen;

  /// Loading state - can be controlled externally
  final ValueNotifier<bool> isLoading;

  /// Constructor
  HZFFormButton({
    required this.text,
    this.icon,
    this.style,
    this.type = HZFFormButtonType.elevated,
    this.onPressed,
    this.enabledWhen,
    this.visibleWhen,
    bool initialLoading = false,
  }) : isLoading = ValueNotifier(initialLoading);

  /// Build button widget
  Widget build(
      BuildContext context, HZFFormController controller, HZFFormStyle style) {
    // Check visibility
    if (visibleWhen != null && !visibleWhen!(controller)) {
      return const SizedBox.shrink();
    }

    // Determine if button should be enabled
    bool isEnabled() {
      if (isLoading.value) return false;
      if (enabledWhen != null) return enabledWhen!(controller);
      return true;
    }

    // Button click handler
    void handlePressed() {
      if (onPressed != null) {
        onPressed!(controller.getFormValues());
      }
    }

    // Get button style
    final buttonStyle = style.buttonStyle?.merge(this.style) ?? this.style;

    // Build button based on type
    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, loading, child) {
        final Widget buttonContent = loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : _buildButtonContent();

        switch (type) {
          case HZFFormButtonType.elevated:
            return ElevatedButton(
              onPressed: isEnabled() ? handlePressed : null,
              style: buttonStyle,
              child: buttonContent,
            );
          case HZFFormButtonType.outlined:
            return OutlinedButton(
              onPressed: isEnabled() ? handlePressed : null,
              style: buttonStyle,
              child: buttonContent,
            );
          case HZFFormButtonType.text:
            return TextButton(
              onPressed: isEnabled() ? handlePressed : null,
              style: buttonStyle,
              child: buttonContent,
            );
        }
      },
    );
  }

  /// Build button content (text and icon)
  Widget _buildButtonContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    } else {
      return Text(text);
    }
  }

  /// Create a submit button
  factory HZFFormButton.submit({
    String text = 'Submit',
    IconData? icon = Icons.check,
    ButtonStyle? style,
    Function(Map<String, dynamic>)? onPressed,
    bool Function(HZFFormController)? enabledWhen,
  }) {
    return HZFFormButton(
      text: text,
      icon: icon,
      style: style,
      type: HZFFormButtonType.elevated,
      onPressed: onPressed,
      enabledWhen: enabledWhen ?? ((controller) => controller.isValid()),
    );
  }

  /// Create a cancel button
  factory HZFFormButton.cancel({
    String text = 'Cancel',
    IconData? icon = Icons.close,
    ButtonStyle? style,
    Function(Map<String, dynamic>)? onPressed,
  }) {
    return HZFFormButton(
      text: text,
      icon: icon,
      style: style,
      type: HZFFormButtonType.outlined,
      onPressed: onPressed,
    );
  }

  /// Create a reset button
  factory HZFFormButton.reset({
    String text = 'Reset',
    IconData? icon = Icons.refresh,
    ButtonStyle? style,
    Function(Map<String, dynamic>)? onPressed,
  }) {
    return HZFFormButton(
      text: text,
      icon: icon,
      style: style,
      type: HZFFormButtonType.text,
      onPressed: onPressed ?? ((data) {}),
    );
  }
}

/*
USAGE:

// Basic form with submit button
final form = HZFForm(
  controller: formController,
  models: fields,
  actions: HZFFormActions(
    submitButton: HZFFormButton.submit(
      onPressed: (data) {
        print('Form submitted: $data');
        // Submit data to API
        apiService.submitForm(data).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Form submitted successfully')),
          );
        });
      },
    ),
  ),
);

// Form with submit and cancel buttons
final formWithCancel = HZFForm(
  controller: formController,
  models: fields,
  actions: HZFFormActions(
    submitButton: HZFFormButton.submit(
      text: 'Save Changes',
      icon: Icons.save,
      onPressed: (data) => saveChanges(data),
    ),
    cancelButton: HZFFormButton.cancel(
      onPressed: (_) => Navigator.pop(context),
    ),
  ),
);

// Form with custom buttons
final formWithCustomButtons = HZFForm(
  controller: formController,
  models: fields,
  actions: HZFFormActions(
    alignment: MainAxisAlignment.spaceBetween,
    customButtons: [
      HZFFormButton(
        text: 'Preview',
        icon: Icons.visibility,
        type: HZFFormButtonType.outlined,
        onPressed: (data) => showPreview(data),
      ),
      HZFFormButton(
        text: 'Save Draft',
        icon: Icons.save_outlined,
        type: HZFFormButtonType.outlined,
        onPressed: (data) => saveDraft(data),
      ),
    ],
    submitButton: HZFFormButton.submit(
      text: 'Publish',
      icon: Icons.publish,
      onPressed: (data) => publishForm(data),
    ),
  ),
);

// Form with loading state
final loadingForm = HZFForm(
  controller: formController,
  models: fields,
  actions: HZFFormActions(
    submitButton: HZFFormButton.submit(
      text: 'Submit',
      onPressed: (data) async {
        // Get button reference
        final submitBtn = formController.getButtonByTag('submit');
        
        // Set loading state
        submitBtn.isLoading.value = true;
        
        try {
          // Submit data to API (simulating delay)
          await Future.delayed(Duration(seconds: 2));
          await apiService.submitForm(data);
          
          // Success handling
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Form submitted successfully')),
          );
        } catch (e) {
          // Error handling
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        } finally {
          // Reset loading state
          submitBtn.isLoading.value = false;
        }
      },
    ),
  ),
);

// Conditional buttons
final conditionalForm = HZFForm(
  controller: formController,
  models: fields,
  actions: HZFFormActions(
    submitButton: HZFFormButton(
      text: 'Complete Registration',
      icon: Icons.person_add,
      type: HZFFormButtonType.elevated,
      onPressed: (data) => registerUser(data),
      // Only enable if terms are accepted
      enabledWhen: (controller) {
        final termsAccepted = controller.getFieldValue('termsAccepted') == true;
        return controller.isValid() && termsAccepted;
      },
    ),
    // Only show delete button for existing users
    customButtons: [
      HZFFormButton(
        text: 'Delete Account',
        icon: Icons.delete,
        type: HZFFormButtonType.outlined,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.red),
        ),
        onPressed: (data) => deleteAccount(data),
        visibleWhen: (controller) => 
          controller.getFieldValue('userId') != null,
      ),
    ],
  ),
);


*/
