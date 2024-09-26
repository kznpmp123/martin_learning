import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constants/active_constants.dart';

// import 'custom_ui.dart';

class VideoViewScreen extends StatefulWidget {
  final String url;
  final bool isUbube;
  const VideoViewScreen({required this.url, required this.isUbube});

  @override
  _VideoViewScreenState createState() => _VideoViewScreenState();
}

class _VideoViewScreenState extends State<VideoViewScreen> {
  final FijkPlayer player = FijkPlayer();
  late YoutubePlayerController _controller;

  _VideoViewScreenState();

  @override
  void initState() {
    super.initState();
    if (widget.isUbube) {
      _controller = YoutubePlayerController(
        initialVideoId: widget.url,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
        ),
      );
    } else {
      player.setOption(FijkOption.playerCategory, "mediacodec-all-videos", 1);
      startPlay();
    }
  }

  void startPlay() async {
    await player.setOption(FijkOption.hostCategory, "request-screen-on", 1);
    await player.setOption(FijkOption.hostCategory, "request-audio-focus", 1);
    await player.setDataSource(widget.url, autoPlay: true).catchError((e) {
      print("setDataSource error: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: widget.isUbube
            ? YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _controller,
                ),
                builder: (context, player) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // some widgets
                      player,
                      //some other widgets
                    ],
                  );
                })
            : Center(
                child: FijkView(
                  player: player,
                  panelBuilder: fijkPanel2Builder(snapShot: true),
                  fsFit: FijkFit.fill,
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}
