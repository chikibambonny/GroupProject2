import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../services/api_config.dart';
import '../services/api_service.dart';

class TranslatorPage extends StatefulWidget {
  const TranslatorPage({super.key});

  @override
  State<TranslatorPage> createState() => _TranslatorPageState();
}

class _TranslatorPageState extends State<TranslatorPage> {
  String? translationResult;
  String? lastCommand;
  bool isLoading = false;

  Future<void> _handleAction({
    required Command command,
    String? text,
    Uint8List? fileBytes,
    String? filename,
  }) async {
    setState(() {
      isLoading = true;
      lastCommand = command.name;
      translationResult = null;
    });

    try {
      Map<String, dynamic> response;

      if (command == Command.email || command == Command.test) {
        if (text == null || text.isEmpty) throw Exception("No text provided");
        response = await sendRequest(command, {"content": text});
      } else {
        if (fileBytes == null || filename == null)
          throw Exception("No file provided");
        response = await sendFile(command, fileBytes, filename);
      }

      setState(() {
        translationResult = response['result'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        translationResult = "Failed: $e";
        isLoading = false;
      });
    }
  }

  Future<void> _pickAndSendFile(Command command) async {
    try {
      final result = await FilePicker.platform.pickFiles(withData: true);
      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      if (file.bytes == null) throw Exception("File data is null");

      await _handleAction(
        command: command,
        fileBytes: file.bytes,
        filename: file.name,
      );
    } catch (e) {
      setState(() {
        translationResult = "Failed to pick file: $e";
      });
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
            // Round toolbar buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _RoundButton(
                  icon: Icons.mic,
                  tooltip: 'Upload Speech',
                  onTap: () => _pickAndSendFile(Command.audio),
                ),
                _RoundButton(
                  icon: Icons.videocam,
                  tooltip: 'Upload Signs',
                  onTap: () => _pickAndSendFile(Command.video),
                ),
                _RoundButton(
                  icon: Icons.mic_none,
                  tooltip: 'Microphone (demo)',
                  onTap: () {},
                ),
                _RoundButton(
                  icon: Icons.camera_alt,
                  tooltip: 'Camera (demo)',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Response / translation field
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

/// Small round button used in toolbar
class _RoundButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _RoundButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Ink(
      decoration: ShapeDecoration(
        color: theme.colorScheme.primary, // uses app theme color
        shape: const CircleBorder(),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: theme.colorScheme.onPrimary), // contrast color
        tooltip: tooltip,
        onPressed: onTap,
      ),
    );
  }
}
