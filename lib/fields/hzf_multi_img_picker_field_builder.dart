import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

import '../core/enums.dart';
import '../models/field_model.dart';
import '../models/multi_image_picker_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

class MultiImagePickerFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final imageModel = model as HZFFormMultiImagePickerModel;

    return Material(
      type: MaterialType.transparency,
      child: ValueListenableBuilder<List<dynamic>>(
        valueListenable: _createValueNotifier(imageModel, controller),
        builder: (context, images, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image grid
              if (images.isNotEmpty)
                _buildImageGrid(context, imageModel, controller, images),

              // Add button (if not read-only and not at max)
              if (imageModel.enableReadOnly != true &&
                  !imageModel.isMaxImagesReached)
                _buildAddButton(context, imageModel, controller),

              // Image count indicator
              if (images.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${images.length}/${imageModel.maximumImageCount?.toInt() ?? '∞'} images',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageGrid(
    BuildContext context,
    HZFFormMultiImagePickerModel model,
    HZFFormController controller,
    List<dynamic> images,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return _buildImageItem(
            context, model, controller, images[index], index);
      },
    );
  }

  Widget _buildImageItem(
    BuildContext context,
    HZFFormMultiImagePickerModel model,
    HZFFormController controller,
    dynamic image,
    int index,
  ) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildImageWidget(image),
          ),
        ),
        // Remove button
        if (model.enableReadOnly != true)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removeImage(model, controller, index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddButton(
    BuildContext context,
    HZFFormMultiImagePickerModel model,
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
          color: Colors.grey[100],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            model.iconWidget,
            const SizedBox(width: 8),
            Text(
              model.hint ?? 'Add Images (${model.remainingSlots} remaining)',
              style: TextStyle(color: Colors.grey[800]),
            ),
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
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      );
    } else if (image is String && image.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        placeholder: (_, __) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
      );
    } else if (image is String) {
      return Image.asset(
        image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      );
    }
    return const Center(child: Text('Invalid'));
  }

  void _showImageSourceDialog(
    BuildContext context,
    HZFFormMultiImagePickerModel model,
    HZFFormController controller,
  ) {
    if (model.imageSource == HZFFormImageSource.camera) {
      _pickImage(ImageSource.camera, model, controller);
      return;
    } else if (model.imageSource == HZFFormImageSource.gallery) {
      _pickImage(ImageSource.gallery, model, controller);
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
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
    HZFFormMultiImagePickerModel model,
    HZFFormController controller,
  ) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile;

      if (source == ImageSource.gallery && model.remainingSlots > 1) {
        // Pick multiple if more than one slot available
        final pickedFiles = await picker.pickMultiImage();
        if (pickedFiles.isEmpty) return;

        // Handle multiple images
        _processMultipleImages(pickedFiles, model, controller);
        return;
      } else {
        // Single image pick
        pickedFile = await picker.pickImage(source: source);
        if (pickedFile == null) return;

        // Check file size
        final fileSize = await File(pickedFile.path).length();
        if (!_isFileSizeValid(fileSize, model)) {
          model.onErrorSizeItem?.call();
          return;
        }

        // Process single image
        final imageFile = File(pickedFile.path);
        _addImageToList(model, controller, imageFile);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _processMultipleImages(
    List<XFile> files,
    HZFFormMultiImagePickerModel model,
    HZFFormController controller,
  ) async {
    // Limit to remaining slots
    final filesToProcess = files.length > model.remainingSlots
        ? files.sublist(0, model.remainingSlots)
        : files;

    for (final file in filesToProcess) {
      // Check file size
      final fileSize = await File(file.path).length();
      if (!_isFileSizeValid(fileSize, model)) {
        continue; // Skip oversized files
      }

      // Add to list
      final imageFile = File(file.path);
      _addImageToList(model, controller, imageFile);
    }
  }

  bool _isFileSizeValid(int fileSize, HZFFormMultiImagePickerModel model) {
    if (model.maximumSizePerImageInKB == null) return true;
    return fileSize <= (model.maximumSizePerImageInKB! * 1024);
  }

  void _addImageToList(
    HZFFormMultiImagePickerModel model,
    HZFFormController controller,
    File imageFile,
  ) {
    final currentList = (controller.getField(model.tag)?.value as List?) ?? [];
    final updatedList = List<dynamic>.from(currentList)..add(imageFile);
    controller.updateFieldValue(model.tag, updatedList);
  }

  void _removeImage(
    HZFFormMultiImagePickerModel model,
    HZFFormController controller,
    int index,
  ) {
    final currentList = controller.getField(model.tag)?.value as List;
    final updatedList = List<dynamic>.from(currentList)..removeAt(index);
    controller.updateFieldValue(model.tag, updatedList);
  }

  ValueNotifier<List<dynamic>> _createValueNotifier(
    HZFFormMultiImagePickerModel model,
    HZFFormController controller,
  ) {
    final initialValue = (model.value as List?) ?? [];
    final notifier = ValueNotifier<List<dynamic>>(List.from(initialValue));

    controller.addListener(() {
      final updatedValue = controller.getField(model.tag)?.value as List?;
      if (updatedValue != null && !listEquals(notifier.value, updatedValue)) {
        notifier.value = List.from(updatedValue);
      }
    });

    return notifier;
  }
}
