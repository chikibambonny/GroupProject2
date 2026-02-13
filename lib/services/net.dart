import 'dart:collection';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sign_translate_app/services/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class Net{
  late IO.Socket socket;
  //chikibambony this is for you should replace it(Queue) with stream
  late Queue<String> q= Queue<String>();
  void connect(){
    var host = Config.host;
    var port = Config.port;

    socket = IO.io('$host:$port',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build()
    );

    socket.connect();

    socket.onConnect((_) {
      print('Connected to backend');
    });
    recv();
  }
  void send(String command,List<int> bytes){
    String encoded = base64Encode(bytes);
    String command  = "translate";

    final data = {
      'command':command,
      'data':encoded,
    };
    final String jsonstr = jsonEncode(data);

    socket.emit("video_event",jsonstr);

  }
  void recv() async{
    socket.on('server_responce', (data){
      final response = ServerResponse.fromJson(data);
      q.add(response.message);
    });
  }
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