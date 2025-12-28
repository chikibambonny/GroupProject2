import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'video_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Translate'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 Search Bar
            TextField(
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'חפש מילה או משפט',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.orange.shade50,
              ),
              onSubmitted: state.search,
            ),
            const SizedBox(height: 20),

            // 🎥 Video Grid
            Expanded(
              child: state.results.isEmpty
                  ? const Center(
                      child: Text(
                        'לא נמצאו תוצאות',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : GridView.builder(
                      itemCount: state.results.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    VideoPage(path: state.results[index]),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.deepOrange.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.play_circle_fill,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
