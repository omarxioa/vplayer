// ignore_for_file: library_private_types_in_public_api

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:v_player/video_plsyer_screen.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  bool isGrid = false; // To toggle between Grid and List view

  // Sample video data
  final List<String> videoUrls = [
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Videos'),
        actions: [
          IconButton(
            icon: Icon(isGrid ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
          ),
        ],
      ),
      body: isGrid
          ? GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 16 / 9, // Aspect ratio of videos
              ),
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                final selectedVideoUrl = videoUrls[index];
                return InkWell
                (
                  onTap: () {
                    print(selectedVideoUrl.toString());
                    // Navigate to the VideoPlayerScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(videoUrl: selectedVideoUrl),
                        ),
                      );
                  },
                  child: _buildVideoItem(videoUrls[index]),);
              },
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                final selectedVideoUrl = videoUrls[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InkWell(
                    onTap: () {
                      print(selectedVideoUrl.toString());
                      // Navigate to the VideoPlayerScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(videoUrl: selectedVideoUrl),
                        ),
                      );
                    },
                    child: _buildVideoItem(videoUrls[index])),
                );
              },
            ),
    );
  }

   Future<Uint8List?> getVideoThumbnail(String videoUrl) async {
  try {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.PNG,
      maxHeight: 150, // Specify the height of the thumbnail
      quality: 75, // Quality from 0 (low) to 100 (high)
    );
    return thumbnail;
  } catch (e) {
    print('Error generating thumbnail: $e');
    return null;
  }
}

  Widget _buildVideoItem(String videoUrl) {
  return FutureBuilder<Uint8List?>(
    future: getVideoThumbnail(videoUrl),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            color: Colors.black12,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }

      if (snapshot.hasData && snapshot.data != null) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Icon(
              Icons.play_circle_fill,
              color: Colors.white,
              size: 50.0,
            ),
          ],
        );
      }

      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black12,
          child: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        ),
      );
    },
  );
}

}


// void main() {
//   runApp(
//     const MaterialApp(
//       home: UniversalVideoPlayer(
//         videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', // Replace with any video URL
//       ),
//     ),
//   );
// }
