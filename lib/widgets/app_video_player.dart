import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';

class AppVideoPlayer extends StatefulWidget {
  String path;

  AppVideoPlayer(this.path);

  @override
  _AppVideoPlayerState createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadVideo();
  }

  Future<void> loadVideo() async {
    // getting a directory path for saving
    setState(() {
      loading = true;
    });

    _videoPlayerController = VideoPlayerController.network(
        'http://adminonline.clovermandalay.org/videos/Moe%20Sensei%20Intro.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
    );
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();

    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.topCenter,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
