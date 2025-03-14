import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../core/enums.dart';
import '../models/field_model.dart';
import '../models/qrcode_picker_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

class QRCodeFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final qrModel = model as HZFFormQRCodeModel;
    final value = qrModel.value as String? ?? qrModel.defaultData ?? '';

    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // QR code display
          if (qrModel.mode == QRCodeMode.generate ||
              qrModel.mode == QRCodeMode.both)
            _buildQRCode(value, qrModel, context),

          const SizedBox(height: 8),

          // Value input field or scanner button
          if (qrModel.showInputField)
            _buildInputField(value, qrModel, controller),

          if (qrModel.mode == QRCodeMode.scan ||
              qrModel.mode == QRCodeMode.both)
            _buildScanButton(qrModel, controller, context),
        ],
      ),
    );
  }

  Widget _buildQRCode(
      String data, HZFFormQRCodeModel model, BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: model.showShadow
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(12),
        child: data.isEmpty
            ? SizedBox(
                width: model.qrSize ?? 200,
                height: model.qrSize ?? 200,
                child: const Center(
                  child: Text('Enter data to generate QR code'),
                ),
              )
            : QrImageView(
                data: data,
                version: QrVersions.auto,
                size: model.qrSize ?? 200,
                backgroundColor: Colors.white,
                eyeStyle: QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: model.qrColor ?? Colors.black),
                errorCorrectionLevel:
                    model.errorCorrectionLevel ?? QrErrorCorrectLevel.M,
                gapless: true,
                embeddedImage: model.logoImageProvider,
                embeddedImageStyle: model.logoImageProvider != null
                    ? QrEmbeddedImageStyle(
                        size: Size(model.logoSize ?? 40, model.logoSize ?? 40),
                      )
                    : null,
              ),
      ),
    );
  }

  Widget _buildInputField(
      String value, HZFFormQRCodeModel model, HZFFormController controller) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        hintText: model.inputHint ?? 'Enter data for QR code',
        prefixIcon: model.prefixWidget ?? const Icon(Icons.qr_code),
        suffixIcon: model.postfixWidget,
        border: const OutlineInputBorder(),
      ),
      enabled: model.enableReadOnly != true,
      maxLines: model.multilineInput ? 3 : 1,
      onChanged: (newValue) {
        controller.updateFieldValue(model.tag, newValue);
      },
    );
  }

  Widget _buildScanButton(
    HZFFormQRCodeModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: model.enableReadOnly == true
              ? null
              : () => _scanQRCode(context, model, controller),
          icon: Icon(model.scanIcon ?? Icons.qr_code_scanner),
          label: Text(model.scanButtonText ?? 'Scan QR Code'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: model.scanButtonColor,
          ),
        ),
      ),
    );
  }

  Future<void> _scanQRCode(
    BuildContext context,
    HZFFormQRCodeModel model,
    HZFFormController controller,
  ) async {
    try {
      final result = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) => _QRScannerScreen(model: model),
        ),
      );
      if (!context.mounted) return;

      if (result != null) {
        controller.updateFieldValue(model.tag, result);
        model.onScanComplete?.call(result);
      }
    } catch (e) {
      debugPrint('Error scanning QR code: $e');
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(model.scanErrorText ?? 'Error scanning QR code'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

/// QR code scanner screen using mobile_scanner
class _QRScannerScreen extends StatefulWidget {
  final HZFFormQRCodeModel model;

  const _QRScannerScreen({required this.model});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<_QRScannerScreen> {
  MobileScannerController controller = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model.scannerTitle ?? 'Scan QR Code'),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off);
                  case TorchState.on:
                    return const Icon(Icons.flash_on);
                }
              },
            ),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // QR scanner view
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (_isProcessing) return;

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes[0].rawValue != null) {
                _isProcessing = true;
                _handleResult(barcodes[0].rawValue!);
              }
            },
          ),

          // Scanner overlay
          CustomPaint(
            painter: _ScannerOverlayPainter(
              borderColor: widget.model.scanBorderColor ?? Colors.green,
              cutoutSize: widget.model.scanCutoutSize ?? 300,
            ),
            child: Container(),
          ),

          // Help text
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              widget.model.scanHelpText ??
                  'Align QR code within the frame to scan',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 3,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleResult(String code) {
    // Validate scan result if validator provided
    if (widget.model.scanValidator != null) {
      final isValid = widget.model.scanValidator!(code);
      if (!isValid) {
        setState(() {
          _isProcessing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.model.invalidQRText ?? 'Invalid QR code'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // Return scan result
    Navigator.pop(context, code);
  }
}

/// Custom overlay painter for scanner
class _ScannerOverlayPainter extends CustomPainter {
  final Color borderColor;
  final double cutoutSize;

  _ScannerOverlayPainter({
    required this.borderColor,
    required this.cutoutSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final double cutoutLeft = (size.width - cutoutSize) / 2;
    final double cutoutTop = (size.height - cutoutSize) / 2;
    final double cutoutRight = cutoutLeft + cutoutSize;
    final double cutoutBottom = cutoutTop + cutoutSize;

    // Draw overlay with cutout
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(cutoutLeft, cutoutTop, cutoutSize, cutoutSize),
              const Radius.circular(12),
            ),
          ),
      ),
      paint,
    );

    // Draw border around cutout
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cutoutLeft, cutoutTop, cutoutSize, cutoutSize),
        const Radius.circular(12),
      ),
      borderPaint,
    );

    // Draw corner markers
    final double markerLength = cutoutSize * 0.1;
    final Paint markerPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    // Top left corner
    canvas.drawLine(
      Offset(cutoutLeft, cutoutTop + markerLength),
      Offset(cutoutLeft, cutoutTop),
      markerPaint,
    );
    canvas.drawLine(
      Offset(cutoutLeft, cutoutTop),
      Offset(cutoutLeft + markerLength, cutoutTop),
      markerPaint,
    );

    // Top right corner
    canvas.drawLine(
      Offset(cutoutRight - markerLength, cutoutTop),
      Offset(cutoutRight, cutoutTop),
      markerPaint,
    );
    canvas.drawLine(
      Offset(cutoutRight, cutoutTop),
      Offset(cutoutRight, cutoutTop + markerLength),
      markerPaint,
    );

    // Bottom left corner
    canvas.drawLine(
      Offset(cutoutLeft, cutoutBottom - markerLength),
      Offset(cutoutLeft, cutoutBottom),
      markerPaint,
    );
    canvas.drawLine(
      Offset(cutoutLeft, cutoutBottom),
      Offset(cutoutLeft + markerLength, cutoutBottom),
      markerPaint,
    );

    // Bottom right corner
    canvas.drawLine(
      Offset(cutoutRight - markerLength, cutoutBottom),
      Offset(cutoutRight, cutoutBottom),
      markerPaint,
    );
    canvas.drawLine(
      Offset(cutoutRight, cutoutBottom),
      Offset(cutoutRight, cutoutBottom - markerLength),
      markerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
