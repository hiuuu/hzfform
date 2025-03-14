import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../models/color_picker_model.dart';
import '../models/field_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

class ColorPickerFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final colorModel = model as HZFFormColorPickerModel;

    // Current color value
    final selectedColor = colorModel.value != null
        ? (colorModel.value is Color
            ? colorModel.value as Color
            : Color(int.parse(colorModel.value.toString())))
        : colorModel.defaultColor ?? Colors.blue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Color preview
        InkWell(
          onTap: colorModel.enableReadOnly == true
              ? null
              : () => _showColorPicker(
                  context, colorModel, controller, selectedColor),
          child: Container(
            height: colorModel.previewHeight ?? 50,
            decoration: BoxDecoration(
              color: selectedColor,
              borderRadius:
                  BorderRadius.circular(colorModel.previewBorderRadius ?? 8),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1.0,
              ),
              boxShadow: colorModel.showShadow
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: colorModel.showHexValue
                ? Center(
                    child: Text(
                      _colorToHex(selectedColor),
                      style: TextStyle(
                        color: _contrastColor(selectedColor),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
          ),
        ),

        // Color picker button (optional)
        if (colorModel.showPickerButton)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: colorModel.enableReadOnly == true
                    ? null
                    : () => _showColorPicker(
                        context, colorModel, controller, selectedColor),
                icon: Icon(colorModel.pickerButtonIcon ?? Icons.color_lens),
                label: Text(colorModel.pickerButtonText ?? 'Change Color'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),

        // Predefined colors palette (optional)
        if (colorModel.showPredefinedColors &&
            colorModel.predefinedColors.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: colorModel.predefinedColors.map((color) {
                final isSelected = selectedColor.toARGB32() == color.toARGB32();
                return InkWell(
                  onTap: colorModel.enableReadOnly == true
                      ? null
                      : () {
                          controller.updateFieldValue(colorModel.tag, color);
                          colorModel.onColorSelected?.call(color);
                        },
                  child: Container(
                    width: colorModel.predefinedColorSize ?? 36,
                    height: colorModel.predefinedColorSize ?? 36,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(
                          colorModel.predefinedColorBorderRadius ?? 4),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                        width: isSelected ? 2.0 : 1.0,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: _contrastColor(color),
                            size: 18,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Future<void> _showColorPicker(
    BuildContext context,
    HZFFormColorPickerModel model,
    HZFFormController controller,
    Color initialColor,
  ) async {
    final result = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return _ColorPickerDialog(
          initialColor: initialColor,
          model: model,
        );
      },
    );

    if (result != null) {
      controller.updateFieldValue(model.tag, result);
      model.onColorSelected?.call(result);
    }
  }

  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  Color _contrastColor(Color color) {
    // Calculate contrast color (black or white) based on luminance
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// Color picker dialog
class _ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  final HZFFormColorPickerModel model;

  const _ColorPickerDialog({
    required this.initialColor,
    required this.model,
  });

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color currentColor;
  late TextEditingController hexController;

  @override
  void initState() {
    super.initState();
    currentColor = widget.initialColor;
    hexController = TextEditingController(text: _colorToHex(currentColor));
  }

  @override
  void dispose() {
    hexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.model.pickerTitle ?? 'Select Color'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Color preview
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: currentColor,
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.only(bottom: 16),
            ),

            // Color picker based on mode
            _buildColorPicker(),

            // Hex input field
            if (widget.model.showHexInput)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: hexController,
                  decoration: const InputDecoration(
                    labelText: 'Hex Color',
                    prefixText: '#',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 6,
                  onChanged: (value) {
                    if (value.length == 6) {
                      try {
                        final color = Color(int.parse('FF$value', radix: 16));
                        setState(() {
                          currentColor = color;
                        });
                      } catch (e) {
                        // Invalid hex
                      }
                    }
                  },
                ),
              ),

            // RGB sliders
            if (widget.model.pickerMode == ColorPickerMode.rgb)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: [
                    _buildRGBSlider('R', Colors.red, currentColor.r.round()),
                    _buildRGBSlider('G', Colors.green, currentColor.g.round()),
                    _buildRGBSlider('B', Colors.blue, currentColor.b.round()),
                    if (widget.model.enableOpacity)
                      _buildRGBSlider('A', Colors.grey, currentColor.a.round()),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.model.cancelText ?? 'Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(currentColor),
          child: Text(widget.model.confirmText ?? 'Select'),
        ),
      ],
    );
  }

  Widget _buildColorPicker() {
    switch (widget.model.pickerMode) {
      case ColorPickerMode.material:
        return _buildMaterialPicker();
      case ColorPickerMode.rgb:
        return const SizedBox(); // Handled by RGB sliders
      case ColorPickerMode.hsl:
        return _buildHSLPicker();
      case ColorPickerMode.wheel:
        return _buildWheelPicker();
    }
  }

  Widget _buildMaterialPicker() {
    // Material design color picker
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: Colors.primaries.length,
      itemBuilder: (context, index) {
        final color = Colors.primaries[index];
        return InkWell(
          onTap: () {
            setState(() {
              currentColor = color;
              hexController.text = _colorToHex(color).substring(1);
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: currentColor.toARGB32() == color.toARGB32()
                    ? Colors.white
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: currentColor.toARGB32() == color.toARGB32()
                ? const Center(child: Icon(Icons.check, color: Colors.white))
                : null,
          ),
        );
      },
    );
  }

  Widget _buildHSLPicker() {
    // HSL color picker with saturation/lightness grid
    final hslColor = HSLColor.fromColor(currentColor);

    return Column(
      children: [
        // Hue slider
        Slider(
          value: hslColor.hue,
          min: 0,
          max: 360,
          divisions: 360,
          label: '${hslColor.hue.round()}°',
          onChanged: (value) {
            setState(() {
              final newColor = hslColor.withHue(value).toColor();
              currentColor = newColor;
              hexController.text = _colorToHex(newColor).substring(1);
            });
          },
        ),

        // Saturation/lightness grid
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                HSLColor.fromAHSL(1, hslColor.hue, 0, 0.5).toColor(),
                HSLColor.fromAHSL(1, hslColor.hue, 1, 0.5).toColor(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWheelPicker() {
    // Color wheel picker
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.blue,
            Colors.indigo,
            Colors.purple,
            Colors.red,
          ],
        ),
      ),
    );
  }

  Widget _buildRGBSlider(String label, Color trackColor, int value) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Text(label),
        ),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 255,
            divisions: 255,
            activeColor: trackColor,
            onChanged: (newValue) {
              final intValue = newValue.round();
              Color newColor;

              if (label == 'R') {
                newColor = currentColor.withRed(intValue);
              } else if (label == 'G') {
                newColor = currentColor.withGreen(intValue);
              } else if (label == 'B') {
                newColor = currentColor.withBlue(intValue);
              } else {
                newColor = currentColor.withAlpha(intValue);
              }

              setState(() {
                currentColor = newColor;
                hexController.text = _colorToHex(newColor).substring(1);
              });
            },
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(value.toString()),
        ),
      ],
    );
  }

  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}
