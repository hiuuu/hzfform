import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../models/doc_picker_model.dart';
import '../models/field_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

class DocumentPickerFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final docModel = model as HZFFormDocumentPickerModel;
    final hasDocument = docModel.value != null;

    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Document preview card
          if (hasDocument) _buildDocumentPreview(docModel, controller, context),

          // Button row (Pick/Scan)
          if (!hasDocument || docModel.allowMultiple)
            _buildActionButtons(docModel, controller, context),

          // Helper text
          if (docModel.helperText != null && !hasDocument)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                docModel.helperText!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDocumentPreview(
    HZFFormDocumentPickerModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final documents = model.value as List<DocumentFile>;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 2,
          child: ListTile(
            leading: _buildDocumentIcon(doc),
            title: Text(
              doc.name ?? 'Document ${index + 1}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle:
                doc.size != null ? Text(_formatFileSize(doc.size!)) : null,
            trailing: model.enableReadOnly != true
                ? IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _removeDocument(doc, model, controller),
                  )
                : null,
            onTap: () => _previewDocument(doc, context),
          ),
        );
      },
    );
  }

  Widget _buildDocumentIcon(DocumentFile doc) {
    IconData iconData;
    Color iconColor;

    if (doc.mimeType?.startsWith('image/') == true) {
      iconData = Icons.image;
      iconColor = Colors.blue;
    } else if (doc.mimeType?.contains('pdf') == true) {
      iconData = Icons.picture_as_pdf;
      iconColor = Colors.red;
    } else if (doc.mimeType?.contains('word') == true ||
        doc.mimeType?.contains('msword') == true) {
      iconData = Icons.description;
      iconColor = Colors.blue;
    } else if (doc.mimeType?.contains('excel') == true ||
        doc.mimeType?.contains('sheet') == true) {
      iconData = Icons.table_chart;
      iconColor = Colors.green;
    } else if (doc.mimeType?.contains('presentation') == true ||
        doc.mimeType?.contains('powerpoint') == true) {
      iconData = Icons.slideshow;
      iconColor = Colors.orange;
    } else {
      iconData = Icons.insert_drive_file;
      iconColor = Colors.grey;
    }

    // If thumbnail available for image
    if (doc.thumbnailPath != null &&
        doc.mimeType?.startsWith('image/') == true) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.file(
          File(doc.thumbnailPath!),
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(iconData, color: iconColor),
    );
  }

  Widget _buildActionButtons(
    HZFFormDocumentPickerModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    return Wrap(
      spacing: 8,
      children: [
        // File picker button
        ElevatedButton.icon(
          onPressed: model.enableReadOnly == true
              ? null
              : () => _pickDocument(model, controller, context),
          icon: Icon(model.pickIcon ?? Icons.upload_file),
          label: Text(model.pickButtonText ?? 'Select Document'),
          style: ElevatedButton.styleFrom(
            backgroundColor: model.pickButtonColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),

        // Scan document button
        if (model.enableScanning)
          ElevatedButton.icon(
            onPressed: model.enableReadOnly == true
                ? null
                : () => _scanDocument(model, controller, context),
            icon: Icon(model.scanIcon ?? Icons.document_scanner),
            label: Text(model.scanButtonText ?? 'Scan Document'),
            style: ElevatedButton.styleFrom(
              backgroundColor: model.scanButtonColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
      ],
    );
  }

  Future<void> _pickDocument(
    HZFFormDocumentPickerModel model,
    HZFFormController controller,
    BuildContext context,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: model.fileType ?? FileType.any,
        allowMultiple: model.allowMultiple,
        allowedExtensions: model.allowedExtensions,
      );
      if (!context.mounted) return;

      if (result != null && result.files.isNotEmpty) {
        final docs = await _processPickedFiles(result.files, model);
        if (!context.mounted) return;
        _updateDocuments(docs, model, controller);
      }
    } catch (e) {
      _showErrorSnackbar(context, 'Error picking document: $e');
    }
  }

  Future<void> _scanDocument(
    HZFFormDocumentPickerModel model,
    HZFFormController controller,
    BuildContext context,
  ) async {
    try {
      final result = await Navigator.push<DocumentFile>(
        context,
        MaterialPageRoute(
          builder: (context) => _DocumentScannerScreen(model: model),
        ),
      );
      if (!context.mounted) return;

      if (result != null) {
        _updateDocuments([result], model, controller);
      }
    } catch (e) {
      _showErrorSnackbar(context, 'Error scanning document: $e');
    }
  }

  Future<List<DocumentFile>> _processPickedFiles(
    List<PlatformFile> files,
    HZFFormDocumentPickerModel model,
  ) async {
    final result = <DocumentFile>[];

    for (final file in files) {
      if (file.path == null) continue;

      final doc = DocumentFile(
        path: file.path!,
        name: file.name,
        size: file.size,
        mimeType: _getMimeType(file.extension),
      );

      // Generate thumbnail for images
      if (doc.mimeType?.startsWith('image/') == true) {
        doc.thumbnailPath = await _generateThumbnail(doc.path);
      }

      result.add(doc);
    }

    return result;
  }

  Future<String?> _generateThumbnail(String imagePath) async {
    try {
      final directory = await getTemporaryDirectory();
      final thumbnailPath =
          '${directory.path}/thumb_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Generate thumbnail using image package
      final image = img.decodeImage(File(imagePath).readAsBytesSync());
      if (image == null) return null;

      final thumbnail = img.copyResize(image, width: 300);
      File(thumbnailPath)
          .writeAsBytesSync(img.encodeJpg(thumbnail, quality: 70));

      return thumbnailPath;
    } catch (e) {
      debugPrint('Error generating thumbnail: $e');
      return null;
    }
  }

  void _updateDocuments(
    List<DocumentFile> newDocs,
    HZFFormDocumentPickerModel model,
    HZFFormController controller,
  ) {
    List<DocumentFile> updatedDocs;

    if (model.allowMultiple) {
      final currentDocs = model.value as List<DocumentFile>? ?? [];
      updatedDocs = [...currentDocs, ...newDocs];

      // Apply max limit if specified
      if (model.maxFiles != null && updatedDocs.length > model.maxFiles!) {
        updatedDocs = updatedDocs.sublist(0, model.maxFiles!);
      }
    } else {
      updatedDocs = newDocs;
    }

    controller.updateFieldValue(model.tag, updatedDocs);
    model.onDocumentsSelected?.call(updatedDocs);
  }

  void _removeDocument(
    DocumentFile doc,
    HZFFormDocumentPickerModel model,
    HZFFormController controller,
  ) {
    final currentDocs = model.value as List<DocumentFile>;
    final updatedDocs = currentDocs.where((d) => d.path != doc.path).toList();

    controller.updateFieldValue(
        model.tag, updatedDocs.isEmpty ? null : updatedDocs);
    model.onDocumentsSelected?.call(updatedDocs);
  }

  Future<void> _previewDocument(DocumentFile doc, BuildContext context) async {
    if (doc.mimeType?.startsWith('image/') == true) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => _ImagePreviewScreen(imagePath: doc.path),
        ),
      );
    } else {
      // Open document with external viewer
      final result = await OpenFile.open(doc.path);
      if (!context.mounted) return;
      if (result.type != ResultType.done) {
        _showErrorSnackbar(context, 'Cannot open file: ${result.message}');
      }
    }
  }

  String _getMimeType(String? extension) {
    if (extension == null) return 'application/octet-stream';

    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
      case 'docx':
        return 'application/msword';
      case 'xls':
      case 'xlsx':
        return 'application/vnd.ms-excel';
      case 'ppt':
      case 'pptx':
        return 'application/vnd.ms-powerpoint';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}

/// Document scanner screen with camera and processing
class _DocumentScannerScreen extends StatefulWidget {
  final HZFFormDocumentPickerModel model;

  const _DocumentScannerScreen({required this.model});

  @override
  _DocumentScannerScreenState createState() => _DocumentScannerScreenState();
}

class _DocumentScannerScreenState extends State<_DocumentScannerScreen> {
  final _cameraController = CameraController(
    CameraDescription(
      name: '0',
      lensDirection: CameraLensDirection.back,
      sensorOrientation: 90,
    ),
    ResolutionPreset.high,
  );

  bool _isInitialized = false;
  bool _isProcessing = false;
  DocumentFile? _scannedDocument;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _showError('No camera found on device');
        return;
      }

      await _cameraController.initialize();
      setState(() => _isInitialized = true);
    } catch (e) {
      _showError('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model.scannerTitle ?? 'Scan Document'),
        actions: [
          if (_scannedDocument != null)
            TextButton(
              onPressed: () => Navigator.pop(context, _scannedDocument),
              child: Text(
                widget.model.useScanButtonText ?? 'Use Scan',
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _isInitialized && _scannedDocument == null
          ? FloatingActionButton(
              onPressed: _isProcessing ? null : _captureImage,
              child: _isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.camera),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody() {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_scannedDocument != null) {
      return _buildScannedPreview();
    }

    return Stack(
      children: [
        // Camera preview
        Positioned.fill(
          child: CameraPreview(_cameraController),
        ),

        // Document overlay
        Positioned.fill(
          child: CustomPaint(
            painter: _DocumentOverlayPainter(),
          ),
        ),

        // Helper text
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Text(
            widget.model.scanHelpText ??
                'Position document within frame and take picture',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
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
    );
  }

  Widget _buildScannedPreview() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(_scannedDocument!.path),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Action buttons
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _retakePicture,
                icon: const Icon(Icons.refresh),
                label: Text(widget.model.retakeButtonText ?? 'Retake'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, _scannedDocument),
                icon: const Icon(Icons.check),
                label: Text(widget.model.useScanButtonText ?? 'Use Scan'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _captureImage() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final image = await _cameraController.takePicture();

      // Process document image
      final processedPath = await _processDocumentImage(image.path);

      setState(() async {
        _scannedDocument = DocumentFile(
          path: processedPath ?? image.path,
          name: 'Scanned_Doc_${DateTime.now().millisecondsSinceEpoch}.jpg',
          size: File(image.path).lengthSync(),
          mimeType: 'image/jpeg',
          thumbnailPath: await _generateThumbnail(processedPath ?? image.path),
        );
        if (!context.mounted) return;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() => _isProcessing = false);
      _showError('Error capturing image: $e');
    }
  }

  Future<String?> _processDocumentImage(String imagePath) async {
    try {
      // This would be where document edge detection and perspective correction happens
      // For demonstration, we're just returning the original image
      // In a real app, you would use a package like edge_detection or document_scanner

      return imagePath;
    } catch (e) {
      debugPrint('Error processing document: $e');
      return null;
    }
  }

  Future<String?> _generateThumbnail(String imagePath) async {
    try {
      final directory = await getTemporaryDirectory();
      final thumbnailPath =
          '${directory.path}/thumb_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final image = img.decodeImage(File(imagePath).readAsBytesSync());
      if (image == null) return null;

      final thumbnail = img.copyResize(image, width: 300);
      File(thumbnailPath)
          .writeAsBytesSync(img.encodeJpg(thumbnail, quality: 70));

      return thumbnailPath;
    } catch (e) {
      debugPrint('Error generating thumbnail: $e');
      return null;
    }
  }

  void _retakePicture() {
    setState(() => _scannedDocument = null);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}

/// Document overlay painter
class _DocumentOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    // Calculate document frame size (A4 aspect ratio)
    final double frameWidth = size.width * 0.8;
    final double frameHeight = frameWidth * 1.414; // A4 aspect ratio

    final double left = (size.width - frameWidth) / 2;
    final double top = (size.height - frameHeight) / 2;

    // Draw overlay with cutout
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(left, top, frameWidth, frameHeight),
              const Radius.circular(8),
            ),
          ),
      ),
      paint,
    );

    // Draw border around cutout
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, frameWidth, frameHeight),
        const Radius.circular(8),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Image preview screen
class _ImagePreviewScreen extends StatelessWidget {
  final String imagePath;

  const _ImagePreviewScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.file(File(imagePath)),
        ),
      ),
    );
  }
}
