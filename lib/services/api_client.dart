import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String _baseUrl = "http://192.168.137.167:5000";

  static Future<http.Response> post(String path, Map<String, dynamic> body) {
    final url = Uri.parse("$_baseUrl$path");

    return http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
  }
}
