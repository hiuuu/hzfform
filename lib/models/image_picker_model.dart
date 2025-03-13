// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'field_model.dart';
import '../core/enums.dart';

class HZFFormImagePickerModel extends HZFFormFieldModel {
  /// Placeholder text when no image selected
  final String? hint;

  /// Custom icon for the picker button
  final Widget iconWidget;

  /// Camera option title in selection dialog
  final String? cameraPopupTitle;

  /// Gallery option title in selection dialog
  final String? galleryPopupTitle;

  /// Camera icon in selection dialog
  final String? cameraPopupIcon;

  /// Gallery icon in selection dialog
  final String? galleryPopupIcon;

  /// Default image source (camera/gallery/both)
  final HZFFormImageSource? imageSource;

  /// Enable image cropping after selection
  final bool? showCropper;

  /// Maximum file size in bytes
  final double? maximumSizePerImageInBytes;

  /// Callback when image exceeds size limit
  final VoidCallback? onErrorSizeItem;

  HZFFormImagePickerModel({
    required String tag,
    this.hint = "Select Image",
    this.iconWidget = const Icon(Icons.add_a_photo),
    this.cameraPopupTitle = "Camera",
    this.galleryPopupTitle = "Gallery",
    this.cameraPopupIcon = "camera_icon",
    this.galleryPopupIcon = "gallery_icon",
    this.imageSource = HZFFormImageSource.both,
    this.showCropper = false,
    this.maximumSizePerImageInBytes = 5242880, // 5MB default
    this.onErrorSizeItem,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value, // File or XFile
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  }) : super(
          tag: tag,
          type: HZFFormFieldTypeEnum.imagePicker,
          title: title,
          errorMessage: errorMessage ?? "Please select an image",
          helpMessage: helpMessage ??
              (maximumSizePerImageInBytes != null
                  ? "Max size: ${(maximumSizePerImageInBytes / 1048576).toStringAsFixed(1)}MB"
                  : null),
          prefixWidget: prefixWidget,
          postfixWidget: postfixWidget,
          required: required,
          showTitle: showTitle,
          value: value,
          validateRegEx: validateRegEx,
          weight: weight,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          onTap: onTap,
          status: status,
          enableReadOnly: enableReadOnly,
        );

  /// Check if file size is within limits
  bool isFileSizeValid(int fileSizeInBytes) {
    return maximumSizePerImageInBytes == null ||
        fileSizeInBytes <= maximumSizePerImageInBytes!;
  }

  /// Get formatted size string
  String getFormattedSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  }
}
