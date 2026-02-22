import 'package:flutter/material.dart';
import '../services/api_config.dart';
import '../services/api_service.dart';

class TranslatorPage extends StatefulWidget {
  const TranslatorPage({super.key});

  @override
  State<TranslatorPage> createState() => _TranslatorPageState();
}

class _TranslatorPageState extends State<TranslatorPage> {
  /// The translation text returned from the server
  String? translationResult;

  /// What we sent to the server ("audio" or "signs")
  String? lastCommand;

  /// Whether we are currently waiting for a response
  bool isLoading = false;

  /// This function is called by ALL buttons.
  /// `command` is exactly what your server expects.
  void _handleAction(String command) async {
    setState(() {
      isLoading = true;
      lastCommand = command;
      translationResult = null;
    });

    setState(() {
      isLoading = false;
      translationResult = 'Fake translation result for "$command"';
    });
  }

  void onClickTest() async {
    writeToLog("[translatorpage.dart]- Clicked test");
    setState(() {
      isLoading = true;
    });

    const text = "tralalela";
    if (text.isEmpty) return;
    try {
      final response = await sendRequest(Command.test, {"content": text});
      writeToLog("[translatorpage.dart]- sent successfully: $text");
      writeToLog("[translatorpage.dart]- server response: $response");

      final result = response['result'];

      setState(() {
        translationResult = result;
        lastCommand = Command.test.name;
        isLoading = false;
      });

      // Show success dialog
      '''
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Your test has been sent!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      ''';
    } catch (e) {
      writeToLog("[translatorpage.dart]- Failed to send test: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Translator'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ACTION BUTTONS
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upload',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: 'Stupid test',
                        icon: Icons.cruelty_free,
                        onTap: onClickTest,
                      ),
                    ),
                    Expanded(
                      child: _ActionButton(
                        label: 'Speaking file',
                        icon: Icons.upload_file,
                        onTap: () => _handleAction('audio'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionButton(
                        label: 'Signs file',
                        icon: Icons.upload_file,
                        onTap: () => _handleAction('signs'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Record',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: 'Audio',
                        icon: Icons.mic,
                        onTap: () => _handleAction('audio'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionButton(
                        label: 'Video',
                        icon: Icons.videocam,
                        onTap: () => _handleAction('signs'),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// TRANSLATION OUTPUT
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : translationResult == null
                    ? const Text(
                        'Translation result will appear here.',
                        style: TextStyle(color: Colors.grey),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (lastCommand != null)
                            Text(
                              'Mode: $lastCommand',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            translationResult!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple reusable button used everywhere above
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
