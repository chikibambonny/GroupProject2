import 'package:flutter/material.dart';
import 'package:sign_translate_app/services/configMob.dart';
import 'widgets/home_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Config.loadConfig();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sign Translator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const HomeShell(), // <- Shell page is loaded here
    );
  }
}
