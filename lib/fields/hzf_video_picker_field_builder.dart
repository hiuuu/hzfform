import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';

import '../core/enums.dart';
import '../models/field_model.dart';
import '../models/video_picker_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

class VideoPickerFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final videoModel = model as HZFFormVideoPickerModel;
    final hasVideo = videoModel.value != null;

    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video preview
          if (hasVideo) _buildVideoPreview(videoModel, controller),

          // Action buttons
          if (!hasVideo || videoModel.showActionButtonsAlways)
            _buildActionButtons(videoModel, controller, context),

          // Helper text
          if (videoModel.helperText != null && !hasVideo)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                videoModel.helperText!,
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

  Widget _buildVideoPreview(
    HZFFormVideoPickerModel model,
    HZFFormController controller,
  ) {
    final videoFile = model.value as VideoFile;

    return Stack(
      children: [
        // Video thumbnail
        Container(
          height: model.previewHeight ?? 200,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          clipBehavior: Clip.antiAlias,
          child: videoFile.thumbnailPath != null
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    // Thumbnail
                    Image.file(
                      File(videoFile.thumbnailPath!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),

                    // Play button overlay
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Icon(Icons.videocam, size: 48, color: Colors.grey),
                ),
        ),

        // Video info
        Positioned(
          bottom: 16,
          left: 8,
          right: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Duration
              if (videoFile.duration != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatDuration(videoFile.duration!),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),

              // File size
              if (videoFile.size != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatFileSize(videoFile.size!),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),

        // Remove button
        if (model.enableReadOnly != true)
          Positioned(
            top: 8,
            right: 8,
            child: InkWell(
              onTap: () => controller.updateFieldValue(model.tag, null),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(
    HZFFormVideoPickerModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    return Wrap(
      spacing: 8,
      children: [
        // Record video button
        if (model.enableRecording)
          ElevatedButton.icon(
            onPressed: model.enableReadOnly == true
                ? null
                : () => _recordVideo(model, controller, context),
            icon: Icon(model.recordIcon ?? Icons.videocam),
            label: Text(model.recordButtonText ?? 'Record Video'),
            style: ElevatedButton.styleFrom(
              backgroundColor: model.recordButtonColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),

        // Pick video button
        if (model.enablePicking)
          ElevatedButton.icon(
            onPressed: model.enableReadOnly == true
                ? null
                : () => _pickVideo(model, controller, context),
            icon: Icon(model.pickIcon ?? Icons.video_library),
            label: Text(model.pickButtonText ?? 'Choose Video'),
            style: ElevatedButton.styleFrom(
              backgroundColor: model.pickButtonColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
      ],
    );
  }

  Future<void> _pickVideo(
    HZFFormVideoPickerModel model,
    HZFFormController controller,
    BuildContext context,
  ) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
        maxDuration: model.maxDuration,
      );
      if (!context.mounted) return;

      if (pickedFile != null) {
        _processVideo(pickedFile.path, model, controller, context);
      }
    } catch (e) {
      _showErrorSnackbar(context, 'Error picking video: $e');
    }
  }

  Future<void> _recordVideo(
    HZFFormVideoPickerModel model,
    HZFFormController controller,
    BuildContext context,
  ) async {
    try {
      final XFile? recordedFile = await ImagePicker().pickVideo(
        source: ImageSource.camera,
        maxDuration: model.maxDuration,
        preferredCameraDevice:
            model.useFrontCamera ? CameraDevice.front : CameraDevice.rear,
      );
      if (!context.mounted) return;

      if (recordedFile != null) {
        _processVideo(recordedFile.path, model, controller, context);
      }
    } catch (e) {
      _showErrorSnackbar(context, 'Error recording video: $e');
    }
  }

  Future<void> _processVideo(
    String videoPath,
    HZFFormVideoPickerModel model,
    HZFFormController controller,
    BuildContext context,
  ) async {
    // ignore: unused_local_variable
    final loadingDialog = _showLoadingDialog(context, 'Processing video...');

    try {
      // Get video metadata
      final videoInfo = await VideoCompress.getMediaInfo(videoPath);
      if (!context.mounted) return;
      final originalSize = videoInfo.filesize ?? 0;
      final originalDuration = videoInfo.duration?.round() ?? 0;

      // Check if video exceeds max duration
      if (model.maxDuration != null &&
          originalDuration > model.maxDuration!.inSeconds) {
        Navigator.pop(context); // Close loading dialog
        _showErrorSnackbar(
          context,
          'Video exceeds maximum duration of ${model.maxDuration!.inSeconds} seconds',
        );
        return;
      }

      // Compress video if enabled and size exceeds threshold
      String finalVideoPath = videoPath;
      int finalSize = originalSize;

      if (model.enableCompression &&
          (originalSize > (model.compressionThreshold ?? 10 * 1024 * 1024))) {
        final compressResult = await VideoCompress.compressVideo(
          videoPath,
          quality: _getCompressionQuality(model.compressionQuality),
          deleteOrigin: false,
          includeAudio: true,
        );

        if (compressResult != null && compressResult.path != null) {
          finalVideoPath = compressResult.path!;
          finalSize = compressResult.filesize ?? originalSize;
        }
      }

      // Generate thumbnail
      final thumbnailFile = await VideoCompress.getFileThumbnail(
        finalVideoPath,
        quality: 50,
        position: -1, // Default position
      );
      if (!context.mounted) return;

      final videoFile = VideoFile(
        path: finalVideoPath,
        thumbnailPath: thumbnailFile.path,
        size: finalSize,
        originalSize: originalSize,
        duration: Duration(seconds: originalDuration),
        isCompressed: finalVideoPath != videoPath,
      );

      controller.updateFieldValue(model.tag, videoFile);
      model.onVideoSelected?.call(videoFile);

      Navigator.pop(context); // Close loading dialog
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorSnackbar(context, 'Error processing video: $e');
    }
  }

  VideoQuality _getCompressionQuality(CompressionQuality? quality) {
    switch (quality) {
      case CompressionQuality.low:
        return VideoQuality.LowQuality;
      case CompressionQuality.medium:
        return VideoQuality.MediumQuality;
      case CompressionQuality.high:
        return VideoQuality.HighestQuality;
      default:
        return VideoQuality.MediumQuality;
    }
  }

  Widget _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Text(message),
              ],
            ),
          ),
        );
      },
    );

    return Container(); // Placeholder return
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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
