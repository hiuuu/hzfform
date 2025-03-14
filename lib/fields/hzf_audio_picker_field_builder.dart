import 'dart:async';
import 'dart:io';
import 'dart:math' show Random;

import 'package:record/record.dart' as record;
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart' show ReturnCode;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/enums.dart';
import '../models/audio_picker_model.dart';
import '../models/field_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

class AudioPickerFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final audioModel = model as HZFFormAudioPickerModel;
    final hasAudio = audioModel.value != null;

    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Audio player/preview
          if (hasAudio) _buildAudioPreview(audioModel, controller, context),

          // Action buttons
          if (!hasAudio || audioModel.showActionButtonsAlways)
            _buildActionButtons(audioModel, controller, context),

          // Helper text
          if (audioModel.helperText != null && !hasAudio)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                audioModel.helperText!,
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

  Widget _buildAudioPreview(
    HZFFormAudioPickerModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final audioFile = model.value as AudioFile;

    return AudioPlayerWidget(
      audioFile: audioFile,
      onDelete: model.enableReadOnly != true
          ? () => controller.updateFieldValue(model.tag, null)
          : null,
    );
  }

  Widget _buildActionButtons(
    HZFFormAudioPickerModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    return Wrap(
      spacing: 8,
      children: [
        // Record audio button
        if (model.enableRecording)
          ElevatedButton.icon(
            onPressed: model.enableReadOnly == true
                ? null
                : () => _recordAudio(model, controller, context),
            icon: Icon(model.recordIcon ?? Icons.mic),
            label: Text(model.recordButtonText ?? 'Record Audio'),
            style: ElevatedButton.styleFrom(
              backgroundColor: model.recordButtonColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),

        // Pick audio button
        if (model.enablePicking)
          ElevatedButton.icon(
            onPressed: model.enableReadOnly == true
                ? null
                : () => _pickAudio(model, controller, context),
            icon: Icon(model.pickIcon ?? Icons.audio_file),
            label: Text(model.pickButtonText ?? 'Choose Audio'),
            style: ElevatedButton.styleFrom(
              backgroundColor: model.pickButtonColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
      ],
    );
  }

  Future<void> _pickAudio(
    HZFFormAudioPickerModel model,
    HZFFormController controller,
    BuildContext context,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (!context.mounted) return;

      if (result != null &&
          result.files.isNotEmpty &&
          result.files.first.path != null) {
        _processAudio(result.files.first.path!, model, controller, context);
      }
    } catch (e) {
      _showErrorSnackbar(context, 'Error picking audio: $e');
    }
  }

  Future<void> _recordAudio(
    HZFFormAudioPickerModel model,
    HZFFormController controller,
    BuildContext context,
  ) async {
    try {
      final recordedFile = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) => _AudioRecorderScreen(model: model),
        ),
      );
      if (!context.mounted) return;

      if (recordedFile != null) {
        _processAudio(recordedFile, model, controller, context);
      }
    } catch (e) {
      _showErrorSnackbar(context, 'Error recording audio: $e');
    }
  }

  Future<void> _processAudio(
    String audioPath,
    HZFFormAudioPickerModel model,
    HZFFormController controller,
    BuildContext context,
  ) async {
    // ignore: unused_local_variable
    final loadingDialog = _showLoadingDialog(context, 'Processing audio...');

    try {
      // Get audio metadata
      final file = File(audioPath);
      final originalSize = await file.length();

      // Extract duration with just_audio
      final player = AudioPlayer();
      await player.setFilePath(audioPath);
      final duration = player.duration;
      await player.dispose();
      if (!context.mounted) return;
      // Check if audio exceeds max duration
      if (model.maxDuration != null &&
          duration != null &&
          duration > model.maxDuration!) {
        Navigator.pop(context); // Close loading dialog
        _showErrorSnackbar(
          context,
          'Audio exceeds maximum duration of ${model.maxDuration!.inSeconds} seconds',
        );
        return;
      }

      // Compress audio if enabled and size exceeds threshold
      String finalAudioPath = audioPath;
      int finalSize = originalSize;

      if (model.enableCompression &&
          originalSize > (model.compressionThreshold ?? 5 * 1024 * 1024)) {
        final compressedPath = await _compressAudio(
          audioPath,
          model.compressionQuality,
        );

        if (compressedPath != null) {
          finalAudioPath = compressedPath;
          finalSize = await File(compressedPath).length();
        }
      }

      // Generate waveform data for visualization
      final waveformData = await _generateWaveformData(finalAudioPath);
      if (!context.mounted) return;
      final audioFile = AudioFile(
        path: finalAudioPath,
        size: finalSize,
        originalSize: originalSize,
        duration: duration,
        waveformData: waveformData,
        isCompressed: finalAudioPath != audioPath,
      );

      controller.updateFieldValue(model.tag, audioFile);
      model.onAudioSelected?.call(audioFile);

      Navigator.pop(context); // Close loading dialog
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorSnackbar(context, 'Error processing audio: $e');
    }
  }

  Future<String?> _compressAudio(
      String audioPath, CompressionQuality? quality) async {
    try {
      final directory = await getTemporaryDirectory();
      final outputPath =
          '${directory.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.mp3';

      // Determine bitrate based on quality
      int bitrate;
      switch (quality) {
        case CompressionQuality.low:
          bitrate = 64; // 64 kbps
          break;
        case CompressionQuality.medium:
          bitrate = 128; // 128 kbps
          break;
        case CompressionQuality.high:
          bitrate = 192; // 192 kbps
          break;
        default:
          bitrate = 128; // Default medium quality
      }

      // Use FFmpeg to compress audio
      final result = await FFmpegKit.execute(
          '-i "$audioPath" -b:a ${bitrate}k -y "$outputPath"');

      final returnCode = await result.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        return outputPath;
      } else {
        debugPrint('FFmpeg process exited with code $returnCode');
        return null;
      }
    } catch (e) {
      debugPrint('Error compressing audio: $e');
      return null;
    }
  }

  Future<List<double>> _generateWaveformData(String audioPath) async {
    try {
      // Use FFmpeg to extract audio samples for waveform
      final directory = await getTemporaryDirectory();
      final wavPath =
          '${directory.path}/temp_${DateTime.now().millisecondsSinceEpoch}.wav';

      // Convert to WAV for easier processing
      final result =
          await FFmpegKit.execute('-i "$audioPath" -ac 1 -ar 8000 "$wavPath"');

      final returnCode = await result.getReturnCode();

      if (!ReturnCode.isSuccess(returnCode)) {
        return List.filled(100, 0.5); // Return flat waveform on error
      }

      // Read WAV file
      final file = File(wavPath);
      final bytes = await file.readAsBytes();

      // Skip WAV header (44 bytes)
      const headerSize = 44;

      // Extract 100 sample points for the waveform
      final samples = <double>[];
      final sampleCount = (bytes.length - headerSize) ~/ 2; // 16-bit samples
      final step = sampleCount ~/ 100;

      for (var i = 0; i < 100; i++) {
        final sampleIndex = headerSize + (i * step * 2);
        if (sampleIndex + 1 < bytes.length) {
          // Convert 16-bit sample to double between 0 and 1
          final sample = bytes[sampleIndex] + (bytes[sampleIndex + 1] << 8);
          final normalizedSample = (sample / 32768).abs();
          samples.add(normalizedSample);
        } else {
          samples.add(0.5);
        }
      }

      // Clean up temporary file
      await file.delete();

      return samples;
    } catch (e) {
      debugPrint('Error generating waveform: $e');
      return List.filled(100, 0.5); // Return flat waveform on error
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

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}

/// Audio recorder screen
class _AudioRecorderScreen extends StatefulWidget {
  final HZFFormAudioPickerModel model;

  const _AudioRecorderScreen({required this.model});

  @override
  _AudioRecorderScreenState createState() => _AudioRecorderScreenState();
}

class _AudioRecorderScreenState extends State<_AudioRecorderScreen> {
  final _recorder = record.AudioRecorder();
  bool _isRecording = false;
  String? _recordedPath;
  Timer? _durationTimer;
  int _recordDuration = 0;
  List<double> _waveData = List.filled(100, 0.1);
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.microphone.request();
    if (!context.mounted) return;
    if (status != PermissionStatus.granted) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  Future<void> _startRecording() async {
    try {
      final directory = await getTemporaryDirectory();
      final path =
          '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _recorder.start(const record.RecordConfig(), path: path);

      setState(() {
        _isRecording = true;
        _recordDuration = 0;
        _waveData = List.filled(100, 0.1);
      });

      // Start timer for duration tracking
      _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordDuration++;

          // Update waveform visualization with simulated data
          // In a real app, you'd use the actual amplitude data from the recorder
          final index = _recordDuration % 100;
          if (index < _waveData.length) {
            _waveData[index] = 0.1 + _random.nextDouble() * 0.8;
          }
        });

        // Check if max duration reached
        if (widget.model.maxDuration != null &&
            _recordDuration >= widget.model.maxDuration!.inSeconds) {
          _stopRecording();
        }
      });
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    _durationTimer?.cancel();

    try {
      final path = await _recorder.stop();
      setState(() {
        _isRecording = false;
        _recordedPath = path;
      });
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      setState(() => _isRecording = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model.recorderTitle ?? 'Record Audio'),
        actions: [
          if (_recordedPath != null)
            TextButton(
              onPressed: () => Navigator.pop(context, _recordedPath),
              child: Text(
                widget.model.useRecordingButtonText ?? 'Use Recording',
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Waveform visualization
              Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _buildWaveform(),
              ),

              const SizedBox(height: 32),

              // Duration display
              Text(
                _formatDuration(_recordDuration),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 32),

              // Recording controls
              if (_recordedPath == null)
                FloatingActionButton(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  backgroundColor: _isRecording ? Colors.red : Colors.blue,
                  child: Icon(_isRecording ? Icons.stop : Icons.mic),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() => _recordedPath = null);
                      },
                      icon: const Icon(Icons.refresh),
                      label:
                          Text(widget.model.retakeButtonText ?? 'Record Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context, _recordedPath),
                      icon: const Icon(Icons.check),
                      label: Text(widget.model.useRecordingButtonText ??
                          'Use Recording'),
                    ),
                  ],
                ),

              const SizedBox(height: 16),

              // Max duration note
              if (widget.model.maxDuration != null && _recordedPath == null)
                Text(
                  'Max duration: ${_formatDuration(widget.model.maxDuration!.inSeconds)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaveform() {
    return CustomPaint(
      painter: _WaveformPainter(
        waveData: _waveData,
        color: _isRecording ? Colors.red : Colors.blue,
      ),
      size: const Size(double.infinity, 120),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor().toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }
}

/// Waveform painter
class _WaveformPainter extends CustomPainter {
  final List<double> waveData;
  final Color color;

  _WaveformPainter({
    required this.waveData,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final barWidth = size.width / waveData.length;
    final middle = size.height / 2;

    for (var i = 0; i < waveData.length; i++) {
      final x = i * barWidth;
      final amplitude = waveData[i] * size.height / 2;

      canvas.drawLine(
        Offset(x, middle - amplitude),
        Offset(x, middle + amplitude),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Audio player widget
class AudioPlayerWidget extends StatefulWidget {
  final AudioFile audioFile;
  final VoidCallback? onDelete;

  const AudioPlayerWidget({
    super.key,
    required this.audioFile,
    this.onDelete,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isInitialized = false;
  Duration? _duration;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      await _player.setFilePath(widget.audioFile.path);
      _duration = _player.duration ?? widget.audioFile.duration;

      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() => _isPlaying = false);
          _player.seek(Duration.zero);
        }
      });

      _player.positionStream.listen((position) {
        setState(() => _position = position);
      });

      setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint('Error initializing player: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _playPause() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // Top row with controls and info
          Row(
            children: [
              // Play/pause button
              IconButton(
                onPressed: _isInitialized ? _playPause : null,
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                color: Colors.blue,
              ),

              const SizedBox(width: 8),

              // File info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Audio Recording',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.audioFile.size != null)
                      Text(
                        _formatFileSize(widget.audioFile.size!),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),

              // Compression badge
              if (widget.audioFile.isCompressed)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.audioFile.compressionPercentage,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[800],
                    ),
                  ),
                ),

              // Delete button
              if (widget.onDelete != null)
                IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                ),
            ],
          ),

          const SizedBox(height: 8),

          // Waveform visualization
          if (widget.audioFile.waveformData != null)
            SizedBox(
              height: 60,
              child: CustomPaint(
                painter: _WaveformPainter(
                  waveData: widget.audioFile.waveformData!,
                  color: Colors.blue,
                ),
                size: const Size(double.infinity, 60),
              ),
            ),

          const SizedBox(height: 8),

          // Seek bar
          Row(
            children: [
              Text(_formatDuration(_position)),
              Expanded(
                child: Slider(
                  value: _position.inSeconds.toDouble(),
                  min: 0,
                  max: _duration?.inSeconds.toDouble() ?? 0,
                  onChanged: _isInitialized
                      ? (value) {
                          final position = Duration(seconds: value.toInt());
                          _player.seek(position);
                          setState(() => _position = position);
                        }
                      : null,
                ),
              ),
              Text(_formatDuration(_duration ?? Duration.zero)),
            ],
          ),
        ],
      ),
    );
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
}
