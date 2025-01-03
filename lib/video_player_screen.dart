import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:v_player/provider/video_provider.dart';
import 'utils/utils.dart'; // Conditional import

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  void initState() {
    super.initState();
    final videoProvider = Provider.of<VideoPlayerProvider>(context, listen: false);
    videoProvider.initialize(widget.videoUrl);
  }

  @override
  void dispose() {
    Provider.of<VideoPlayerProvider>(context, listen: false).disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('V Player')),
      body: Consumer<VideoPlayerProvider>(
        builder: (context, videoProvider, child) {
          if (videoProvider.isYouTubeVideo) {
            return getYouTubePlayer(widget.videoUrl); // Dynamically chooses web or mobile
          // ignore: unnecessary_null_comparison
          } else if (videoProvider.videoController != null) {
            return Video(controller: videoProvider.videoController);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
