import 'package:flutter/material.dart';
import 'package:optimize/constants/active_constants.dart';
import 'package:optimize/models/AudioFile.dart';
import 'package:optimize/screens/music_player_screen.dart';

class AudioListScreen extends StatelessWidget {
  List<AudioFile> files = [];
  String cover;
  String type;
  String subTitle;
  AudioListScreen(
      {Key? key,
      required this.files,
      required this.type,
      required this.cover,
      required this.subTitle
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: activeColors.primary,
          title: Text("$type: Audio Files"),
          centerTitle: false,
          titleSpacing: 0.0,
          titleTextStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: ListView.builder(
          itemCount: files.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print("audio_list_screen->thubmnail is ");
                print(files[index].thumbnail);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MusicPlayerScreen(
                      link: files[index].url,
                      cover: files[index].thumbnail,
                      title: files[index].name,
                      subTitle: subTitle,
                    ),
                  ),
                );
              },
              child: Card(
                child: ListTile(
                    title: Text(files[index].name),
                    leading: const Icon(Icons.music_note),
                    trailing: const Icon(Icons.arrow_forward)),
              ),
            );
          },
        ));
  }
}
