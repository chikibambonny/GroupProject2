const String host = "192.168.22.178";
const String port = "8000";

enum Command { email, video, audio }

final String baseUrl = "http://$host:$port";

String processPath(Command command) {
  return "/process/${command.name}";
}

Uri buildProcessUri(Command command) {
  return Uri.parse("$baseUrl${processPath(command)}");
}
