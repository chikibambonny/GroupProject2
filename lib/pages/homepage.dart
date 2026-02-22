import 'package:flutter/material.dart';
import '../services/api_config.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Create a text controller and use it to retrieve the current value of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void onClickEmail() async {
    writeToLog("[homepage.dart]- Clicked send email");
    final text = myController.text;

    if (text.isEmpty) return;
    try {
      await sendRequest(Command.email, {"content": text});
      writeToLog("[homepage.dart]- sent successfully: $text");
      myController.clear();

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Your email has been saved!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      writeToLog("[homepage.dart]- Failed to save email: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24), // standard comfortable page padding
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hello!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'This app is designed to help bridge communication between sign language and spoken language \n \n'
                'More features are coming soon, subscribe to our newsletter to become the first to learn about them:)',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              Center(
                child: SizedBox(
                  width: 250,
                  child: TextField(
                    controller: myController,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      hintText: 'Enter your email',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),

                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: onClickEmail,
                        /* () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(myController.text),
                              );
                            },
                          );
                        }, */
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
