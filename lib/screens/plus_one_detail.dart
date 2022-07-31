import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:optimize/models/PlusOne.dart';
import 'package:optimize/providers/plus_one_provider.dart';
import 'package:optimize/screens/music_player_screen.dart';
import 'package:optimize/screens/video_view_screen.dart';
import 'package:optimize/widgets/full_screen_preloader.dart';

import 'package:provider/provider.dart';
import '../constants/active_constants.dart';

class PlusOneDetail extends StatefulWidget {
  final PlusOne data;
  const PlusOneDetail({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<PlusOneDetail> createState() => _PlusOneDetailState();
}

class _PlusOneDetailState extends State<PlusOneDetail> {
  bool _isInit = false;
  bool _isPreloading = false;

  void loadData() async {
    setState(() {
      _isPreloading = true;
    });

    await Provider.of<PlusOneProvider>(context, listen: false)
        .getEach(widget.data.id);

    setState(() {
      _isPreloading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      loadData();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: activeColors.primary,
          title: Text(widget.data.title.toString()),
          centerTitle: false,
          titleSpacing: 0.0,
          titleTextStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: SingleChildScrollView(
            child: _isPreloading
                ? FullScreenPreloader()
                : Consumer<PlusOneProvider>(
                    builder: (context, appState, child) {
                    return Container(
                        child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (appState.item.video.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoViewScreen(
                                    url: appState.item.video,
                                    isUbube: appState.item.isUtube,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: 180,
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: NetworkImage(appState.item.thumbnail),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: activeIcons.playerCircleFill,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.1),
                          child: Column(
                            children: [
                              Text(widget.data.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  )),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                appState.item.subtitle,
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  appState.item.isLiked
                                      ? GestureDetector(
                                          onTap: () async {
                                            await Provider.of<PlusOneProvider>(
                                                    context,
                                                    listen: false)
                                                .markData("like",
                                                    appState.item.id, 0);
                                          },
                                          child: activeIcons.heartCircleFill)
                                      : GestureDetector(
                                          onTap: () async {
                                            await Provider.of<PlusOneProvider>(
                                                    context,
                                                    listen: false)
                                                .markData("like",
                                                    appState.item.id, 1);
                                          },
                                          child: activeIcons.heartCircle),
                                  const SizedBox(width: 10.0),
                                  appState.item.isTipped
                                      ? GestureDetector(
                                          onTap: () async {
                                            await Provider.of<PlusOneProvider>(
                                                    context,
                                                    listen: false)
                                                .markData(
                                                    "tip", appState.item.id, 0);
                                          },
                                          child: activeIcons.checkCircleFill)
                                      : GestureDetector(
                                          onTap: () async {
                                            await Provider.of<PlusOneProvider>(
                                                    context,
                                                    listen: false)
                                                .markData(
                                                    "tip", appState.item.id, 1);
                                          },
                                          child: activeIcons.checkCircle),
                                  const SizedBox(width: 10.0),
                                  appState.item.isBooked
                                      ? GestureDetector(
                                          onTap: () async {
                                            await Provider.of<PlusOneProvider>(
                                                    context,
                                                    listen: false)
                                                .markData("bookmark",
                                                    appState.item.id, 0);
                                          },
                                          child: activeIcons.saveCircleFill)
                                      : GestureDetector(
                                          onTap: () async {
                                            await Provider.of<PlusOneProvider>(
                                                    context,
                                                    listen: false)
                                                .markData("bookmark",
                                                    appState.item.id, 1);
                                          },
                                          child: activeIcons.saveCircle),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.1),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.1),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(vertical: 5)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              ),
                              onPressed: () {
                                if (appState.item.audio.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MusicPlayerScreen(
                                        link: appState.item.audio,
                                        cover: appState.item.thumbnail,
                                        title: appState.item.title,
                                        subTitle: appState.item.subtitle,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Column(
                                children: const [
                                  Icon(Icons.music_note),
                                  Text(
                                    "Listen",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.1),
                          child: Html(
                            data: appState.item.description,
                          ),
                        )
                      ],
                    ));
                  })));
  }
}
