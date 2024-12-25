import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';



class VideoPlayerProvider with ChangeNotifier {
  late final Player _player;
  late final VideoController _videoController;
  bool _isYouTubeVideo = false;
  bool _isInitialized = false;

  VideoController get videoController => _videoController;
  bool get isYouTubeVideo => _isYouTubeVideo;
  bool get isInitialized => _isInitialized;

  VideoPlayerProvider() {
    _player = Player();
  }

  Future<void> initialize(String videoUrl) async {
    _isYouTubeVideo = Uri.tryParse(videoUrl)?.host.contains('youtube') ?? false;

    if (!_isYouTubeVideo) {
      // Initialize VideoController directly
      _videoController = VideoController(_player);
      await _player.open(Media(videoUrl));
      _isInitialized = true;
      notifyListeners();
    }
  }

  void play() {
    _player.play();
    notifyListeners();
  }

  void pause() {
    _player.pause();
    notifyListeners();
  }

  void disposePlayer() {
    _player.dispose(); // Dispose the Player instance
    super.dispose(); // Call the parent class's dispose method
  }

  // Sample video data
  final List<String> videoUrls = [
    'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    'https://www.youtube.com/watch?v=uvX4k_3Cmvs',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
  ];
 

}

