import 'dart:io';
// import 'package:toml/toml.dart';
import 'package:path/path.dart' as p;

class Config {
  Config._internal();
  static String host = "192.168.22.178";
  static String port = "12345";

  // COMMANDS
  static const EMAIL_COMMAND = "email_event";

  static void writeToLog(String message) {
    //final logFile = File('Mobile.log');
    //final timestamp = DateTime.now().toIso8601String();
    //logFile.writeAsStringSync('[$timestamp] $message\n', mode: FileMode.append);
    print(message);
  }

  /* static void loadConfig() {
    try {
      final exePath = Platform.script.toFilePath();
      final configPath = p.join(p.dirname(exePath), 'config.toml');

      final file = File(configPath);
      final contents = file.readAsStringSync();

      final Map<String, dynamic> data = TomlDocument.parse(contents).toMap();
      host = "https://${data['server']['host']}";
      port = ":${data['server']['port']}";
    } catch (e) {
      print("Failed to load config: $e");
    }
  } */
}
