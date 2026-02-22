import 'dart:convert';
import 'package:http/http.dart' as http;

// temp variables until a config file is created
var SERVER_URL = "192.168.22.178";
var SERVER_PORT = "12345";

class ApiClient {
  static final String _baseUrl = "http://$SERVER_URL:$SERVER_PORT";

  static Future<http.Response> post(String path, Map<String, dynamic> body) {
    final url = Uri.parse("$_baseUrl$path");

    return http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
  }
}
