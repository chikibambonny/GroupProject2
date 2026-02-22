const String host = "192.168.137.34";
const String port = "8000";

void writeToLog(String message) {
  //final logFile = File('Mobile.log');
  //final timestamp = DateTime.now().toIso8601String();
  //logFile.writeAsStringSync('[$timestamp] $message\n', mode: FileMode.append);
  print(message);
}

//================ URI COMMANDS========

final String baseUrl = "http://$host:$port";

enum Command { email, video, audio }

String processPath(Command command) {
  return "/process/${command.name}";
}

Uri buildProcessUri(Command command) {
  return Uri.parse("$baseUrl${processPath(command)}");
}
