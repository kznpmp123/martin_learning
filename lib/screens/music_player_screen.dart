import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:optimize/constants/active_constants.dart';
import 'package:optimize/widgets/full_screen_preloader.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String cover;
  final String title;
  final String subTitle;
  final String link;
  const MusicPlayerScreen(
      {Key? key,
      required this.cover,
      required this.title,
      required this.subTitle,
      required this.link})
      : super(key: key);

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  late Duration duration = const Duration(milliseconds: 0);
  late PlayerState playerState = PlayerState.paused;
  late Duration maxDuration = const Duration();
  bool _isPreloading = false;

  @override
  void initState() {
    audioPlayer.setSourceUrl(widget.link);

    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      setState(() {
        playerState = s;
      });
      print('Current player state: $s');
    });
    setState(() {
      _isPreloading = true;
    });
    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        maxDuration = d;
        _isPreloading = false;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration p) {
      if (p.inMilliseconds > 0) {
        setState(() {
          duration = p;
        });
        print('Current position: ${p.inMilliseconds}');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        await audioPlayer.stop();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: activeColors.primary,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text("Listen :" + widget.title),
            ),
            centerTitle: false,
            titleSpacing: 0.0,
            titleTextStyle: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: _isPreloading
              ? FullScreenPreloader()
              : Container(
                  child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                      alignment: Alignment.center,
                      child: Image.network(
                        widget.cover,
                        width: screenWidth,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        )),
                    Text(
                      widget.subTitle,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 20, horizontal: screenWidth * 0.2),
                      child: ProgressBar(
                        progress: duration,
                        total: maxDuration,
                        onSeek: (d) {
                          setState(() {
                            duration = d;
                          });
                          audioPlayer.seek(d);
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              Duration newDuration = Duration(
                                  milliseconds:
                                      duration.inMilliseconds - 10000);

                              if (newDuration.inMilliseconds > 0) {
                                setState(() {
                                  duration = newDuration;
                                });
                                audioPlayer.seek(newDuration);
                              }
                            },
                            icon: const Icon(
                                Icons.settings_backup_restore_rounded)),
                        const SizedBox(
                          width: 20,
                        ),
                        playerState == PlayerState.playing
                            ? IconButton(
                                onPressed: () async {
                                  await audioPlayer.pause();
                                },
                                icon: const Icon(Icons.pause_circle))
                            : IconButton(
                                onPressed: () async {
                                  await audioPlayer.resume();
                                },
                                icon: const Icon(Icons.play_arrow)),
                        const SizedBox(
                          width: 20,
                        ),
                        RotatedBox(
                          quarterTurns: 6,
                          child: IconButton(
                              onPressed: () {
                                Duration newDuration = Duration(
                                    milliseconds:
                                        duration.inMilliseconds + 10000);

                                if (maxDuration.inMilliseconds >
                                    newDuration.inMilliseconds) {
                                  setState(() {
                                    duration = newDuration;
                                  });
                                  audioPlayer.seek(newDuration);
                                }
                              },
                              icon: const Icon(
                                  Icons.settings_backup_restore_rounded)),
                        )
                      ],
                    )
                  ],
                ))),
    );
  }
}
