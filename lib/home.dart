// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v_player/provider/video_provider.dart';
import 'package:v_player/utilities/video_item.dart';

import 'package:v_player/video_player_screen.dart';



class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  bool isGrid = false; // To toggle between Grid and List view

  @override
  Widget build(BuildContext context) {
    final List videoUrls = Provider.of<VideoPlayerProvider>(context).videoUrls;
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
                    //print(selectedVideoUrl.toString());
                    // Navigate to the VideoPlayerScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(videoUrl: selectedVideoUrl),
                        ),
                      );
                  },
                  child: VideoItem(videoUrl:  videoUrls[index]),);
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
                      // print(selectedVideoUrl.toString());
                      // Navigate to the VideoPlayerScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(videoUrl: selectedVideoUrl),
                        ),
                      );
                    },
                    child: VideoItem(videoUrl:  videoUrls[index])),
                );
              },
            ),
    );
  }

}