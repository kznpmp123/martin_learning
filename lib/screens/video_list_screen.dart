import 'package:flutter/material.dart';
import 'package:optimize/constants/active_constants.dart';
import 'package:optimize/models/VideoFile.dart';
import 'package:optimize/screens/video_view_screen.dart';

class VideoListScreen extends StatelessWidget {
  List<VideoFile> files = [];

  String type;
  VideoListScreen({Key? key, required this.files, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: activeColors.primary,
          title: Text("$type: Videos"),
          centerTitle: false,
          titleSpacing: 0.0,
          titleTextStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 20),
          child: ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoViewScreen(
                          url: files[index].url,
                          isUbube: files[index].isYouTube),
                    ),
                  );
                },
                child: SizedBox(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoViewScreen(
                                    url: files[index].url,
                                    isUbube: files[index].isYouTube),
                              ),
                            );
                          },
                          child: Container(
                            width: deviceWidth < 400.0 ? 123.0 : 133.0,
                            height: deviceWidth < 400.0 ? 75.0 : 90.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: NetworkImage(files[index].thumbnail),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: activeIcons.playerCircleFill,
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: deviceWidth < 400.0 ? 180.0 : 200.0,
                              child: Wrap(
                                children: [
                                  Text(
                                    files[index].name,
                                    style: activeTextStyles.title,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 180.0,
                              child: Text(
                                files[index].subTitle,
                                style: activeTextStyles.caption,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
