import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import '../core/enums.dart';
import '../models/field_model.dart';
import '../models/image_picker_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

class ImagePickerFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final imageModel = model as HZFFormImagePickerModel;

    return Material(
      type: MaterialType.transparency,
      child: ValueListenableBuilder<dynamic>(
        valueListenable: _createValueNotifier(imageModel, controller),
        builder: (context, value, _) {
          return Column(
            children: [
              _buildImagePreview(context, imageModel, controller, value),
              if (imageModel.enableReadOnly != true)
                _buildPickerButton(context, imageModel, controller),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImagePreview(
    BuildContext context,
    HZFFormImagePickerModel model,
    HZFFormController controller,
    dynamic value,
  ) {
    // No image selected yet
    if (value == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildImageWidget(value),
          ),
        ),
        if (model.enableReadOnly != true)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => controller.updateFieldValue(model.tag, null),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPickerButton(
    BuildContext context,
    HZFFormImagePickerModel model,
    HZFFormController controller,
  ) {
    return GestureDetector(
      onTap: () => _showImageSourceDialog(context, model, controller),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            model.iconWidget,
            const SizedBox(width: 8),
            Text(model.hint ?? 'Select Image'),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(dynamic image) {
    if (image is File) {
      return Image.file(
        image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
        ),
      );
    } else if (image is String && image.startsWith('http')) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Center(
              child: CircularProgressIndicator(
            value: progress.expectedTotalBytes != null
                ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                : null,
          ));
        },
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
        ),
      );
    } else if (image is String) {
      // Assume local path
      return Image.asset(
        image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
        ),
      );
    }

    return const Center(child: Text('Unsupported image format'));
  }

  void _showImageSourceDialog(
    BuildContext context,
    HZFFormImagePickerModel model,
    HZFFormController controller,
  ) {
    if (model.imageSource == HZFFormImageSource.camera) {
      _pickImage(ImageSource.camera, model, controller);
      return;
    } else if (model.imageSource == HZFFormImageSource.gallery) {
      _pickImage(ImageSource.gallery, model, controller);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(model.cameraPopupTitle ?? 'Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, model, controller);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(model.galleryPopupTitle ?? 'Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, model, controller);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(
    ImageSource source,
    HZFFormImagePickerModel model,
    HZFFormController controller,
  ) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile == null) return;

      // Check file size
      final fileSize = await File(pickedFile.path).length();
      if (!model.isFileSizeValid(fileSize)) {
        model.onErrorSizeItem?.call();
        return;
      }

      if (model.showCropper == true) {
        final croppedFile = await _cropImage(pickedFile.path);
        if (croppedFile != null) {
          controller.updateFieldValue(model.tag, File(croppedFile.path));
        }
      } else {
        controller.updateFieldValue(model.tag, File(pickedFile.path));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<CroppedFile?> _cropImage(String imagePath,
      {double aspectRatioX = 1, double aspectRatioY = 1}) async {
    try {
      return await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio:
            CropAspectRatio(ratioX: aspectRatioX, ratioY: aspectRatioY),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );
    } catch (exception) {
      return null;
    }
  }

  ValueNotifier<dynamic> _createValueNotifier(
    HZFFormImagePickerModel model,
    HZFFormController controller,
  ) {
    final notifier = ValueNotifier<dynamic>(model.value);

    // Listen for changes
    controller.addListener(() {
      final updatedValue = controller.getField(model.tag)?.value;
      if (notifier.value != updatedValue) {
        notifier.value = updatedValue;
      }
    });

    return notifier;
  }
}
