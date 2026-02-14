import 'dart:collection';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:sign_translate_app/services/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:typed_data';
import 'configMob.dart';

class Net {
  late IO.Socket socket;
  //chikibambony this is for you should replace it(Queue) with stream
  late Queue<String> q = Queue<String>();

  void connect() async {
    Config.writeToLog("[net.dart]- connect method called");
    //Config.loadConfig();
    var host = Config.host;
    var port = Config.port;

    socket = IO.io(
      'http://$host:$port',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();
    Config.writeToLog("[net.dart]- socket connected at $host:$port");

    socket.onConnect((_) {
      Config.writeToLog("[net.dart]- Connected to backend at $host:$port");
    });
    await recv();
  }

  bool send(String command, String msg) {
    final data = {'command': command, 'data': msg};
    final String jsonstr = jsonEncode(data);

    socket.emit("video_event", jsonstr);
    return true;
  }

  Future<void> recv() async {
    socket.on('server_response', (data) {
      final response = ServerResponse.fromJson(data);
      q.add(response.message);
    });
  }

  /* Daniel's send
  void send(String command, List<int> bytes) {
    String encoded = base64Encode(bytes);
    //String command = "translate";

    final data = {'command': command, 'data': encoded};
    final String jsonstr = jsonEncode(data);

    socket.emit("video_event", jsonstr);
  }
   */
}

class ServerResponse {
  final String message;
  final bool success;

  ServerResponse({required this.message, required this.success});

  factory ServerResponse.fromJson(Map<String, dynamic> json) {
    return ServerResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}
