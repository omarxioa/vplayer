// ignore: avoid_web_libraries_in_flutter
import 'dart:html'; // Only for Flutter Web
import 'dart:ui_web';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:v_player/provider/video_provider.dart';

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
          if (kIsWeb) {
            if (videoProvider.isYouTubeVideo) {
              final videoId = Uri.tryParse(widget.videoUrl)?.queryParameters['v'];
              if (videoId == null) {
                return const Center(
                  child: Text('Invalid YouTube URL'),
                );
              }

              // Register an iframe for YouTube playback
              platformViewRegistry.registerViewFactory(
                'youtube-video-$videoId',
                (int viewId) => IFrameElement()
                  ..width = '100%'
                  ..height = '100%'
                  ..src = 'https://www.youtube.com/embed/$videoId'
                  ..style.border = 'none',
              );

              return Center(
                child: HtmlElementView(viewType: 'youtube-video-$videoId'),
              );
            } else {
              return Video(controller: videoProvider.videoController);
            }
          } else {
            if (videoProvider.isYouTubeVideo) {
              //to-do
              // should add youtube player here
              return const Center(
                child: Text('Enable youtube for other platforms.'),
              );
            // ignore: unnecessary_null_comparison
            } else if (videoProvider.videoController != null) {
              return Video(controller: videoProvider.videoController);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        },
      ),
    );
  }
}
