import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';
import 'package:v_player/provider/thumbnail_provider.dart';
import 'package:v_player/video_player_screen.dart';


class VideoItem extends StatefulWidget {
  const VideoItem({super.key, required this.videoUrl});
  final String videoUrl;

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  /// Extracts the YouTube thumbnail URL from the video URL.
  // String? getYouTubeThumbnail(String videoUrl) {
  //   try {
  //     final uri = Uri.tryParse(videoUrl);
  //     if (uri != null && (uri.host.contains('youtube.com') || uri.host.contains('youtu.be'))) {
  //       // Extract the video ID
  //       if (uri.host.contains('youtube.com')) {
  //         final videoId = uri.queryParameters['v'];
  //         if (videoId != null) {
  //           return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  //         }
  //       } else if (uri.host.contains('youtu.be')) {
  //         final videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
  //         if (videoId != null) {
  //           return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint('Error extracting YouTube thumbnail: $e');
  //   }
  //   return null; // Not a YouTube video
  // }

  // Generates a thumbnail for non-YouTube videos.
  Future<Uint8List?> getVideoThumbnail(String videoUrl) async {
    try {
      return await VideoThumbnail.thumbnailData(
        video: videoUrl,
        imageFormat: ImageFormat.PNG,
        maxHeight: 150, // Thumbnail height
        quality: 75,    // Quality of the thumbnail (0 to 100)
      );
    } catch (e) {
      debugPrint('Error generating thumbnail: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final  getYouTubeThumbnail = Provider.of<ThumbnailProvider>(context).getYouTubeThumbnail(widget.videoUrl);
    final youtubeThumbnail = getYouTubeThumbnail;
    if (youtubeThumbnail != null) {
      //print(youtubeThumbnail);
      // If it's a YouTube video, use the YouTube thumbnail
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ImageNetwork(
               image: youtubeThumbnail, 
               height: MediaQuery.of(context).size.height / 1.5, 
               width: MediaQuery.of(context).size.width / 1.5,
               fitWeb: BoxFitWeb.cover,
               onLoading: const CircularProgressIndicator(),
               onTap: (){
                Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(videoUrl: widget.videoUrl),
                        ),
                      );
               },
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

    // For non-YouTube videos, generate a thumbnail dynamically
    return FutureBuilder<Uint8List?>(
      future: getVideoThumbnail(widget.videoUrl),
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

        // If thumbnail generation fails, show a fallback UI
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            color: Colors.black12,
            child: const Icon(
              Icons.play_circle_fill,
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }
}
