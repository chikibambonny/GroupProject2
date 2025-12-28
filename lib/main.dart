import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const VideoApp());
}

class VideoApp extends StatelessWidget {
  const VideoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Library',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      home: const VideoHomePage(),
    );
  }
}

class VideoHomePage extends StatefulWidget {
  const VideoHomePage({super.key});

  @override
  State<VideoHomePage> createState() => _VideoHomePageState();
}

class _VideoHomePageState extends State<VideoHomePage> {
  List<String> videoPaths = [];
  List<String> filteredVideos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    final String data = await rootBundle.loadString('AI/DataBase/videos.json');
    final Map<String, dynamic> jsonResult = json.decode(data);

    List<String> paths = [];
    for (var value in jsonResult.values) {
      paths.addAll(List<String>.from(value));
    }

    setState(() {
      videoPaths = paths;
      filteredVideos = paths;
      loading = false;
    });
  }

  void _filterVideos(String query) {
    setState(() {
      filteredVideos = videoPaths
          .where((path) => path.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Library'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterVideos,
              decoration: InputDecoration(
                hintText: 'Search videos...',
                fillColor: Colors.white10,
                filled: true,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : filteredVideos.isEmpty
              ? const Center(child: Text('No videos found'))
              : GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 16 / 9,
                  ),
                  itemCount: filteredVideos.length,
                  itemBuilder: (context, index) {
                    return VideoCard(videoPath: filteredVideos[index]);
                  },
                ),
    );
  }
}

class VideoCard extends StatefulWidget {
  final String videoPath;
  const VideoCard({super.key, required this.videoPath});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _controller;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    // Replace invalid characters for Windows safe paths
    String safePath = widget.videoPath.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    _controller = VideoPlayerController.asset('AI/DataBase/DOWNLOADS/$safePath')
      ..initialize().then((_) {
        setState(() {
          initialized = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          initialized
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: VideoPlayer(_controller),
                )
              : Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
                ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Text(
                widget.videoPath,
                style: const TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (initialized && !_controller.value.isPlaying)
            const Center(
              child: Icon(
                Icons.play_circle_outline,
                size: 50,
                color: Colors.white70,
              ),
            ),
        ],
      ),
    );
  }
}
