import 'package:flutter/material.dart';

class ThumbnailProvider with ChangeNotifier {
  
String? getYouTubeThumbnail(String videoUrl) {
  final uri = Uri.tryParse(videoUrl);

  if (uri != null && (uri.host.contains('youtube.com') || uri.host.contains('youtu.be'))) {
    // Extract the video ID
    if (uri.host.contains('youtube.com')) {
      return 'https://img.youtube.com/vi/${uri.queryParameters['v']}/hqdefault.jpg';
    } else if (uri.host.contains('youtu.be')) {
      final videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
    }
  }
  notifyListeners();
  return null; // Not a YouTube video
  
}



// Future<Uint8List?> getVideoThumbnail(String videoUrl) async {
//   try {
//     // Generate the thumbnail
//     final thumbnail = await VideoThumbnail.thumbnailData(
//       video: videoUrl,
//       imageFormat: ImageFormat.PNG,
//       maxHeight: 150, // Thumbnail height
//       quality: 75,    // Quality of the thumbnail (0 to 100)
//     );
//     notifyListeners();
//     return thumbnail;
    
//   } catch (e) {
//     print('Error generating thumbnail: $e');
//     return null;
//   }
// }
 

}