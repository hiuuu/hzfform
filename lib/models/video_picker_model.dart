import 'package:flutter/material.dart';

import '../core/enums.dart';
import 'field_model.dart';

class HZFFormVideoPickerModel extends HZFFormFieldModel {
  /// Enable video recording
  final bool enableRecording;

  /// Enable video picking from gallery
  final bool enablePicking;

  /// Enable video compression
  final bool enableCompression;

  /// Compression quality
  final CompressionQuality compressionQuality;

  /// Compression threshold in bytes
  final int? compressionThreshold;

  /// Maximum video duration
  final Duration? maxDuration;

  /// Use front camera for recording
  final bool useFrontCamera;

  /// Helper text
  final String? helperText;

  /// Record button text
  final String? recordButtonText;

  /// Record button icon
  final IconData? recordIcon;

  /// Record button color
  final Color? recordButtonColor;

  /// Pick button text
  final String? pickButtonText;

  /// Pick button icon
  final IconData? pickIcon;

  /// Pick button color
  final Color? pickButtonColor;

  /// Preview height
  final double? previewHeight;

  /// Show action buttons even when video is selected
  final bool showActionButtonsAlways;

  /// Video selected callback
  final Function(VideoFile)? onVideoSelected;

  HZFFormVideoPickerModel({
    required super.tag,
    this.enableRecording = true,
    this.enablePicking = true,
    this.enableCompression = true,
    this.compressionQuality = CompressionQuality.medium,
    this.compressionThreshold,
    this.maxDuration,
    this.useFrontCamera = false,
    this.helperText,
    this.recordButtonText,
    this.recordIcon,
    this.recordButtonColor,
    this.pickButtonText,
    this.pickIcon,
    this.pickButtonColor,
    this.previewHeight,
    this.showActionButtonsAlways = false,
    this.onVideoSelected,

    // Parent props
    super.title,
    super.errorMessage,
    super.helpMessage,
    super.prefixWidget,
    super.postfixWidget,
    super.required,
    super.showTitle,
    super.value, // VideoFile
    super.validateRegEx,
    super.weight,
    super.focusNode,
    super.nextFocusNode,
    super.onTap,
    super.status,
    super.enableReadOnly,
  }) : super(
          type: HZFFormFieldTypeEnum.videoPicker,
        );
}

/// Video file model
class VideoFile {
  final String path;
  final String? thumbnailPath;
  final int? size;
  final int? originalSize;
  final Duration? duration;
  final bool isCompressed;

  VideoFile({
    required this.path,
    this.thumbnailPath,
    this.size,
    this.originalSize,
    this.duration,
    this.isCompressed = false,
  });

  double get compressionRatio {
    if (originalSize == null || size == null || originalSize == 0) return 1.0;
    return size! / originalSize!;
  }

  String get compressionPercentage {
    if (!isCompressed) return '0%';
    final percentage = (1 - compressionRatio) * 100;
    return '${percentage.toStringAsFixed(1)}%';
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'thumbnailPath': thumbnailPath,
      'size': size,
      'originalSize': originalSize,
      'duration': duration?.inSeconds,
      'isCompressed': isCompressed,
    };
  }

  factory VideoFile.fromJson(Map<String, dynamic> json) {
    return VideoFile(
      path: json['path'],
      thumbnailPath: json['thumbnailPath'],
      size: json['size'],
      originalSize: json['originalSize'],
      duration:
          json['duration'] != null ? Duration(seconds: json['duration']) : null,
      isCompressed: json['isCompressed'] ?? false,
    );
  }
}

/*
USAGE:

// Profile Video Upload
final profileVideoField = HZFFormVideoPickerModel(
  tag: 'profileVideo',
  title: 'Introduction Video',
  enableCompression: true,
  compressionQuality: CompressionQuality.medium,
  compressionThreshold: 5 * 1024 * 1024, // 5MB
  maxDuration: Duration(seconds: 30),
  helperText: 'Record a 30-second introduction about yourself',
  recordButtonText: 'Record Intro',
  pickButtonText: 'Upload Existing',
  onVideoSelected: (video) {
    print('Video selected: ${video.path}');
    print('Compression saved: ${video.compressionPercentage}');
  },
);

// Product Demo Video
final productDemoField = HZFFormVideoPickerModel(
  tag: 'productDemo',
  title: 'Product Demonstration',
  enableRecording: true,
  enablePicking: true,
  maxDuration: Duration(minutes: 2),
  compressionQuality: CompressionQuality.high,
  previewHeight: 240,
  recordButtonColor: Colors.red,
  pickButtonColor: Colors.blue,
);

*/
