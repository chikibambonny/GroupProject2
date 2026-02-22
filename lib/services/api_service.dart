import 'dart:convert';
import 'dart:typed_data';
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

Future<Map<String, dynamic>> sendFile(
  Command command,
  Uint8List bytes,
  String filename,
) async {
  final uri = buildProcessUri(command);

  // Create multipart request
  final request = http.MultipartRequest('POST', uri)
    ..files.add(
      http.MultipartFile.fromBytes(
        'file', // server expects "file"
        bytes,
        filename: filename,
      ),
    );

  // Send the request
  final streamedResponse = await request.send();

  // Convert response to string
  final responseString = await streamedResponse.stream.bytesToString();

  if (streamedResponse.statusCode == 200) {
    return jsonDecode(responseString);
  } else {
    throw Exception(
      "Server error: ${streamedResponse.statusCode} $responseString",
    );
  }
}
