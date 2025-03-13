// ignore_for_file: use_super_parameters

import 'dart:io';

import 'package:flutter/material.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormMultiImagePickerModel extends HZFFormFieldModel {
  /// Placeholder text when no images selected
  final String? hint;

  /// Custom icon for picker button
  final Widget iconWidget;

  /// Camera option title in dialog
  final String? cameraPopupTitle;

  /// Gallery option title in dialog
  final String? galleryPopupTitle;

  /// Camera icon asset path
  final String? cameraPopupIcon;

  /// Gallery icon asset path
  final String? galleryPopupIcon;

  /// Default image source type
  final HZFFormImageSource? imageSource;

  /// Enable image cropping
  final bool? showCropper;

  /// Pre-loaded images paths
  final List<String>? defaultImagePath;

  /// Max file size (KB) per image
  final double? maximumSizePerImageInKB;

  /// Maximum number of images allowed
  final double? maximumImageCount;

  /// Size limit exceeded callback
  final VoidCallback? onErrorSizeItem;

  HZFFormMultiImagePickerModel({
    required String tag,
    this.hint = "Select Images",
    this.iconWidget = const Icon(Icons.add_photo_alternate),
    this.cameraPopupTitle = "Camera",
    this.galleryPopupTitle = "Gallery",
    this.cameraPopupIcon = "camera_icon",
    this.galleryPopupIcon = "gallery_icon",
    this.imageSource = HZFFormImageSource.both,
    this.showCropper = false,
    this.defaultImagePath,
    this.maximumSizePerImageInKB = 5120, // 5MB default
    this.maximumImageCount = 10,
    this.onErrorSizeItem,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value, // List<File> or List<XFile>
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  }) : super(
          tag: tag,
          type: HZFFormFieldTypeEnum.multiImagePicker,
          title: title,
          errorMessage: errorMessage ?? "Please select at least one image",
          helpMessage: helpMessage ??
              "Max ${maximumImageCount?.toInt() ?? 10} images, ${maximumSizePerImageInKB != null ? '${(maximumSizePerImageInKB / 1024).toStringAsFixed(1)}MB' : '5MB'} each",
          prefixWidget: prefixWidget,
          postfixWidget: postfixWidget,
          required: required,
          showTitle: showTitle,
          value: value ??
              defaultImagePath?.map((path) => File(path)).toList() ??
              [],
          validateRegEx: validateRegEx,
          weight: weight,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          onTap: onTap,
          status: status,
          enableReadOnly: enableReadOnly,
        );

  /// Get current image count
  int get imageCount => (value as List).length;

  /// Check if max images reached
  bool get isMaxImagesReached =>
      maximumImageCount != null && imageCount >= maximumImageCount!;

  /// Check if file size is valid
  bool isFileSizeValid(int fileSizeInBytes) {
    if (maximumSizePerImageInKB == null) return true;
    return fileSizeInBytes <= (maximumSizePerImageInKB! * 1024);
  }

  /// Get remaining image slots
  int get remainingSlots => maximumImageCount != null
      ? (maximumImageCount! - imageCount).toInt()
      : 999; // Arbitrary large number

  /// Format file size for display
  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  }
}
