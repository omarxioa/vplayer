// ignore_for_file: library_private_types_in_public_api

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:v_player/video_player_screen.dart';



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
    // Generate the thumbnail
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.PNG,
      maxHeight: 150, // Thumbnail height
      quality: 75,    // Quality of the thumbnail (0 to 100)
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
        print('thumbnail is loaded');
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