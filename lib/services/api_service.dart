import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

Future<Map<String, dynamic>> sendRequest(
  Command command,
  Map<String, dynamic> data,
) async {
  final uri = buildProcessUri(command);

  try {
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Server error: ${response.statusCode} ${response.body}");
    }
  } catch (e) {
    throw Exception("Network error: $e");
  }
}
