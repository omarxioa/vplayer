import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v_player/home.dart';
import 'package:v_player/provider/video_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: VideoPlayerProvider(),)
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'V Player',
        home: VideoListScreen()
        //VideoPlayerScreen(videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4')
       
      ),
    );
  }
}




