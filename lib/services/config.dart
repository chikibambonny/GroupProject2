import 'dart:io';
import 'package:toml/toml.dart';

class Config {
  Config._internal();
  static String host =  "https://";
  static String port = ":";

  static void loadConfig() {
    try {
      final file = File('config.toml');
      final contents = file.readAsStringSync();

      final Map<String, dynamic> data = TomlDocument.parse(contents).toMap();

      host += data['server']['host'];
      port = data['server']['port'];

    } catch (e) {
      print("Failed to load config: $e");
    }
  }
}