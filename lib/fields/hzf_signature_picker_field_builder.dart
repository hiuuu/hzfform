import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import '../models/field_model.dart';
import '../models/signature_picker_model.dart';
import '../widgets/controller.dart';
import 'hzf_field_builder.dart';

class SignatureFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final sigModel = model as HZFFormSignatureModel;
    final hasSignature = sigModel.value != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Signature canvas or preview
        Container(
          height: sigModel.height ?? 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: sigModel.backgroundColor ?? Colors.white,
          ),
          child: hasSignature
              ? _buildSignaturePreview(sigModel, controller)
              : _buildSignatureCanvas(sigModel, controller),
        ),

        // Action buttons
        if (sigModel.enableReadOnly != true)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (hasSignature)
                  TextButton.icon(
                    onPressed: () =>
                        controller.updateFieldValue(sigModel.tag, null),
                    icon: Icon(sigModel.clearIcon ?? Icons.clear),
                    label: Text(sigModel.clearButtonText ?? 'Clear'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  )
                else ...[
                  // Stroke width selector
                  if (sigModel.showStrokeWidthSelector)
                    _buildStrokeSelector(sigModel, controller),

                  // Color selector
                  if (sigModel.showColorSelector)
                    _buildColorSelector(sigModel, controller),
                ]
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSignatureCanvas(
    HZFFormSignatureModel model,
    HZFFormController controller,
  ) {
    return Stack(
      children: [
        // Signature canvas
        Signature(
          controller: model.signatureController,
          backgroundColor: Colors.transparent,
          width: double.infinity,
          height: model.height ?? 200,
        ),

        // Hint overlay
        if (model.showHint)
          Positioned.fill(
            child: Center(
              child: Text(
                model.hintText ?? 'Sign here',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),

        // Done button
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            mini: true,
            onPressed: () => _saveSignature(model, controller),
            backgroundColor: model.doneButtonColor ?? Colors.blue,
            child: Icon(model.doneIcon ?? Icons.check),
          ),
        ),
      ],
    );
  }

  Widget _buildSignaturePreview(
      HZFFormSignatureModel model, HZFFormController formController) {
    final bytes = model.value as Uint8List;

    return Stack(
      children: [
        // Image preview
        Positioned.fill(
          child: Image.memory(
            bytes,
            fit: BoxFit.contain,
          ),
        ),

        // Edit button
        if (model.enableReadOnly != true)
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(model.editIcon ?? Icons.edit),
              onPressed: () {
                model.signatureController.clear();
                formController.updateFieldValue(model.tag, null);
              },
              color: Colors.blue,
            ),
          ),
      ],
    );
  }

  Widget _buildStrokeSelector(
      HZFFormSignatureModel model, HZFFormController formController) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: DropdownButton<double>(
        value: model.signatureController.penStrokeWidth,
        isDense: true,
        items: [1.0, 2.0, 3.0, 5.0, 8.0].map((width) {
          return DropdownMenuItem<double>(
            value: width,
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: width,
                  color: model.signatureController.penColor,
                ),
                const SizedBox(width: 8),
                Text(width.toString()),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            // Create new controller with updated stroke width
            final points = List<Point>.from(model.signatureController.points);
            final color = model.signatureController.penColor;

            model.signatureController.clear();
            model.signatureController = SignatureController(
              penColor: color,
              penStrokeWidth: value,
            );

            if (points.isNotEmpty) {
              for (final point in points) {
                model.signatureController.addPoint(point);
              }
            }

            model.onStrokeWidthChanged?.call(value);
          }
        },
      ),
    );
  }

  Widget _buildColorSelector(
      HZFFormSignatureModel model, HZFFormController formController) {
    final colors = model.availableColors ??
        [
          Colors.black,
          Colors.blue,
          Colors.red,
          Colors.green,
        ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: colors.map((color) {
        final isSelected =
            model.signatureController.penColor.toARGB32() == color.toARGB32();

        return GestureDetector(
          onTap: () {
            // Create new controller with updated color
            final points = List<Point>.from(model.signatureController.points);
            final strokeWidth = model.signatureController.penStrokeWidth;

            model.signatureController.clear();
            model.signatureController = SignatureController(
              penColor: color,
              penStrokeWidth: strokeWidth,
            );

            if (points.isNotEmpty) {
              for (final point in points) {
                model.signatureController.addPoint(point);
              }
            }

            model.onColorChanged?.call(color);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.grey[600]! : Colors.transparent,
                width: 2,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _saveSignature(
    HZFFormSignatureModel model,
    HZFFormController controller,
  ) async {
    // Check if signature is empty
    if (model.signatureController.isEmpty) {
      return;
    }

    // Get signature image data
    final signatureImage = await model.signatureController.toPngBytes();
    if (signatureImage == null) return;

    // Update form value with signature bytes
    controller.updateFieldValue(model.tag, signatureImage);
    model.onSignatureCaptured?.call(signatureImage);
  }
}
