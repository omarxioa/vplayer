import 'package:flutter/widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Returns a widget for playing YouTube videos on mobile/desktop platforms.
Widget getYouTubePlayer(String videoUrl) {
  final videoId = YoutubePlayer.convertUrlToId(videoUrl);
  if (videoId == null) {
    return const Center(
      child: Text('Invalid YouTube URL'),
    );
  }

  final youtubeController = YoutubePlayerController(
    initialVideoId: videoId,
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
    ),
  );

  return YoutubePlayer(
    controller: youtubeController,
    showVideoProgressIndicator: true,
  );
}
