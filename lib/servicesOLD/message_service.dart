import 'api_client.dart';

class MessageService {
  static Future<void> send(String text) async {
    print("Sending message: $text");
    final response = await ApiClient.post("/message", {"text": text});

    if (response.statusCode != 200) {
      throw Exception("Failed to send message");
    }
  }
}
