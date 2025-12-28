import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppState extends ChangeNotifier {
  Map<String, List<String>> videoDB = {};
  List<String> results = [];

  Future<void> loadDB() async {
    final data = await rootBundle.loadString('AI/DATABASE/videos.json');
    final decoded = json.decode(data) as Map<String, dynamic>;

    // Convert dynamic lists to List<String>
    videoDB = decoded.map((key, value) => MapEntry(
          key,
          List<String>.from(value),
        ));
  }

  void search(String input) {
    results.clear();
    final words = input.trim().split(RegExp(r'\s+')); // split by any whitespace

    final Set<String> videos = {}; // use a set to remove duplicates
    for (final word in words) {
      if (videoDB.containsKey(word)) {
        videos.addAll(videoDB[word]!);
      }
    }

    results = videos.toList(); // convert back to list
    notifyListeners();
  }
}
