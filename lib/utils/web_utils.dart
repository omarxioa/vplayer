// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui_web';
import 'package:flutter/widgets.dart';

/// Returns a widget for playing YouTube videos on the web.
Widget getYouTubePlayer(String videoUrl) {
  final videoId = Uri.tryParse(videoUrl)?.queryParameters['v'];
  if (videoId == null) {
    return const Center(
      child: Text('Invalid YouTube URL'),
    );
  }

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
}
