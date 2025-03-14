// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

import '../core/enums.dart';
import 'field_model.dart';

class HZFFormAudioPickerModel extends HZFFormFieldModel {
  /// Enable audio recording
  final bool enableRecording;

  /// Enable audio picking from storage
  final bool enablePicking;

  /// Enable audio compression
  final bool enableCompression;

  /// Compression quality
  final CompressionQuality compressionQuality;

  /// Compression threshold in bytes
  final int? compressionThreshold;

  /// Maximum audio duration
  final Duration? maxDuration;

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

  /// Recorder screen title
  final String? recorderTitle;

  /// Retake button text
  final String? retakeButtonText;

  /// Use recording button text
  final String? useRecordingButtonText;

  /// Show action buttons even when audio is selected
  final bool showActionButtonsAlways;

  /// Audio selected callback
  final Function(AudioFile)? onAudioSelected;

  HZFFormAudioPickerModel({
    required String tag,
    this.enableRecording = true,
    this.enablePicking = true,
    this.enableCompression = true,
    this.compressionQuality = CompressionQuality.medium,
    this.compressionThreshold,
    this.maxDuration,
    this.helperText,
    this.recordButtonText,
    this.recordIcon,
    this.recordButtonColor,
    this.pickButtonText,
    this.pickIcon,
    this.pickButtonColor,
    this.recorderTitle,
    this.retakeButtonText,
    this.useRecordingButtonText,
    this.showActionButtonsAlways = false,
    this.onAudioSelected,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value, // AudioFile
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  }) : super(
          tag: tag,
          type: HZFFormFieldTypeEnum.audioPicker,
          title: title,
          errorMessage: errorMessage,
          helpMessage: helpMessage,
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
}

/// Audio file model
class AudioFile {
  final String path;
  final int? size;
  final int? originalSize;
  final Duration? duration;
  final List<double>? waveformData;
  final bool isCompressed;

  AudioFile({
    required this.path,
    this.size,
    this.originalSize,
    this.duration,
    this.waveformData,
    this.isCompressed = false,
  });

  double get compressionRatio {
    if (originalSize == null || size == null || originalSize == 0) return 1.0;
    return size! / originalSize!;
  }

  String get compressionPercentage {
    if (!isCompressed) return '0%';
    final percentage = (1 - compressionRatio) * 100;
    return '${percentage.toStringAsFixed(0)}%';
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'size': size,
      'originalSize': originalSize,
      'duration': duration?.inSeconds,
      'waveformData': waveformData,
      'isCompressed': isCompressed,
    };
  }

  factory AudioFile.fromJson(Map<String, dynamic> json) {
    return AudioFile(
      path: json['path'],
      size: json['size'],
      originalSize: json['originalSize'],
      duration:
          json['duration'] != null ? Duration(seconds: json['duration']) : null,
      waveformData: json['waveformData'] != null
          ? List<double>.from(json['waveformData'])
          : null,
      isCompressed: json['isCompressed'] ?? false,
    );
  }
}

/*
USAGE:

// Voice note recorder
final voiceNoteField = HZFFormAudioPickerModel(
  tag: 'voiceNote',
  title: 'Voice Note',
  enableCompression: true,
  maxDuration: Duration(minutes: 2),
  compressionQuality: CompressionQuality.medium,
  helperText: 'Record a voice note (max 2 minutes)',
  recordButtonText: 'Record Voice',
  onAudioSelected: (audio) {
    print('Audio recorded: ${audio.path}');
    print('Duration: ${audio.duration}');
    if (audio.isCompressed) {
      print('Compression saved: ${audio.compressionPercentage}');
    }
  },
);

// Audio attachment
final audioAttachmentField = HZFFormAudioPickerModel(
  tag: 'audioAttachment',
  title: 'Audio Attachment',
  enableRecording: true,
  enablePicking: true,
  compressionThreshold: 3 * 1024 * 1024, // 3MB
  recordButtonColor: Colors.red,
  pickButtonColor: Colors.blue,
);

*/
