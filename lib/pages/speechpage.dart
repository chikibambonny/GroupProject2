import 'package:flutter/material.dart';

class SpeechPage extends StatefulWidget {
  const SpeechPage({super.key});

  @override
  State<SpeechPage> createState() => _SpeechPageState();
}

class _SpeechPageState extends State<SpeechPage> {
  bool isListening = false;
  bool isPaused = false;
  String transcript = '';

  void startListening() {
    setState(() {
      isListening = true;
      isPaused = false;
      // Here you would trigger actual STT start
    });
  }

  void stopListening() {
    setState(() {
      isListening = false;
      isPaused = false;
      // Here you would stop STT
    });
  }

  void pauseListening() {
    setState(() {
      isPaused = true;
      // Here you would pause STT
    });
  }

  void resumeListening() {
    setState(() {
      isPaused = false;
      // Here you would resume STT
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Speech recognition',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Turn speech to text here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),

          // Listening status row (slightly narrower than transcript)
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.92, // 92% width of the parent, adjust as needed
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isListening
                        ? (isPaused ? 'Paused' : 'Listening…')
                        : 'Not listening',
                    style: theme.textTheme.titleMedium,
                  ),
                  ElevatedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          // Transcript box
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Text(
                    transcript.isEmpty
                        ? 'Your transcribed text will appear here…'
                        : transcript,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Controls
          Row(
            children: [
              Expanded(
                child: isListening
                    ? Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: isPaused
                                  ? resumeListening
                                  : pauseListening,
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
                              onPressed: stopListening,
                              icon: const Icon(Icons.stop),
                              label: const Text('Stop'),
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
                        ],
                      )
                    : ElevatedButton.icon(
                        onPressed: startListening,
                        icon: const Icon(Icons.mic),
                        label: const Text('Start'),
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
                tooltip: 'Clear text',
                onPressed: transcript.isEmpty
                    ? null
                    : () {
                        setState(() {
                          transcript = '';
                        });
                      },
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
