import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SpeechPage extends StatefulWidget {
  const SpeechPage({super.key});

  @override
  State<SpeechPage> createState() => _SpeechPageState();
}

class _SpeechPageState extends State<SpeechPage> {
  bool isRecording = false;
  bool isPaused = false;
  String? filePath;

  final recorder = AudioRecorder();

  Future<void> startRecording() async {
    if (await _recorder.hasPermission()) {
      final dir = await getApplicationDocumentsDirectory();
      filePath =
          '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _recorder.start(
        path: filePath,
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );

      setState(() {
        isRecording = true;
        isPaused = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission denied')),
      );
    }
  }

  Future<void> pauseRecording() async {
    if (await _recorder.isRecording()) {
      await _recorder.pause();
      setState(() {
        isPaused = true;
      });
    }
  }

  Future<void> resumeRecording() async {
    if (await _recorder.isPaused()) {
      await _recorder.resume();
      setState(() {
        isPaused = false;
      });
    }
  }

  Future<void> stopRecording() async {
    await _recorder.stop();
    setState(() {
      isRecording = false;
      isPaused = false;
    });
  }

  void clearRecording() {
    if (filePath != null && File(filePath!).existsSync()) {
      File(filePath!).deleteSync();
      setState(() {
        filePath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Speech recognition',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Record your voice here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),

          // Status row
          FractionallySizedBox(
            widthFactor: 0.92,
            child: Text(
              isRecording
                  ? (isPaused ? 'Paused' : 'Recording…')
                  : 'Not recording',
              style: theme.textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 16),

          // Recording info box
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Text(
                    filePath ?? 'Your recording path will appear here…',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Controls row
          Row(
            children: [
              Expanded(
                child: isRecording
                    ? Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: isPaused
                                  ? resumeRecording
                                  : pauseRecording,
                              icon: Icon(
                                isPaused ? Icons.play_arrow : Icons.pause,
                              ),
                              label: Text(isPaused ? 'Resume' : 'Pause'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: stopRecording,
                              icon: const Icon(Icons.stop),
                              label: const Text('Stop'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      )
                    : ElevatedButton.icon(
                        onPressed: startRecording,
                        icon: const Icon(Icons.mic),
                        label: const Text('Record'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              IconButton(
                tooltip: 'Clear recording',
                onPressed: filePath == null ? null : clearRecording,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
