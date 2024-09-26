import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:optimize/models/Pn.dart';
import 'package:optimize/providers/pn_provider.dart';
import 'package:optimize/screens/audio_list_screen.dart';
import 'package:optimize/screens/pdf_list_screen.dart';
import 'package:optimize/screens/video_list_screen.dart';
import 'package:optimize/screens/video_view_screen.dart';
import 'package:optimize/widgets/full_screen_preloader.dart';
import 'package:optimize/widgets/message_dialog.dart';
import 'package:optimize/widgets/premium_message.dart';
import 'package:provider/provider.dart';
import '../constants/active_constants.dart';

class PnDetail extends StatefulWidget {
  final Pn data;
  const PnDetail({Key? key, required this.data}) : super(key: key);

  @override
  State<PnDetail> createState() => _PnDetailState();
}

class _PnDetailState extends State<PnDetail> {
  bool _isInit = false;
  bool _isPreloading = false;

  void loadData() async {
    setState(() {
      _isPreloading = true;
    });
    try {
      await Provider.of<PnProvider>(context, listen: false)
          .getEach(widget.data.id);
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        _isPreloading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      loadData();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  Future<void> onSubscribe() async {
    await Provider.of<PnProvider>(context, listen: false)
        .subscribeCourse(widget.data.id);
    MessageDialog.show(
        context,
        "You have subcribed successfully. Please wait for admin confirmiation",
        "Success",
        "Close");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: activeColors.primary,
          title: Text("Book:" + widget.data.title.toString()),
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
                : Consumer<PnProvider>(builder: (context, appState, child) {
                    return Container(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 3,
                                    blurRadius: 2,
                                    offset: const Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Image.network(
                                appState.item.coverImage,
                                width: MediaQuery.of(context).size.width * 0.35,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.1),
                            child: Column(
                              children: [
                                Text(appState.item.title,
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
                                              await Provider.of<PnProvider>(
                                                      context,
                                                      listen: false)
                                                  .markData("like",
                                                      appState.item.id, 0);
                                            },
                                            child: activeIcons.heartCircleFill)
                                        : GestureDetector(
                                            onTap: () async {
                                              await Provider.of<PnProvider>(
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
                                              await Provider.of<PnProvider>(
                                                      context,
                                                      listen: false)
                                                  .markData("tip",
                                                      appState.item.id, 0);
                                            },
                                            child: activeIcons.checkCircleFill)
                                        : GestureDetector(
                                            onTap: () async {
                                              await Provider.of<PnProvider>(
                                                      context,
                                                      listen: false)
                                                  .markData("tip",
                                                      appState.item.id, 1);
                                            },
                                            child: activeIcons.checkCircle),
                                    const SizedBox(width: 10.0),
                                    appState.item.isBooked
                                        ? GestureDetector(
                                            onTap: () async {
                                              await Provider.of<PnProvider>(
                                                      context,
                                                      listen: false)
                                                  .markData("bookmark",
                                                      appState.item.id, 0);
                                            },
                                            child: activeIcons.saveCircleFill)
                                        : GestureDetector(
                                            onTap: () async {
                                              await Provider.of<PnProvider>(
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                                EdgeInsets>(
                                            const EdgeInsets.symmetric(vertical: 5)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.blue),
                                      ),
                                      onPressed: () {
                                        if (appState.item.isSub) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PdfListScreen(
                                                      type: "101",
                                                      files: appState
                                                          .item.pdfFiles,
                                                    )),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PremiumMessage(
                                                        onClick: onSubscribe,
                                                        type: "PN",
                                                        id: appState.item.id)),
                                          );
                                        }
                                      },
                                      child: Column(
                                        children: const [
                                          Icon(Icons.book),
                                          Text(
                                            "Read",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                                EdgeInsets>(
                                            const EdgeInsets.symmetric(vertical: 5)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.blue),
                                      ),
                                      onPressed: () {
                                        if (appState.item.isSub) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AudioListScreen(
                                                      type: "PN",
                                                      cover: appState
                                                          .item.coverImage,
                                                      subTitle:
                                                          appState.item.title,
                                                      files: appState
                                                          .item.audioFiles,
                                                    )),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PremiumMessage(
                                                        onClick: onSubscribe,
                                                        type: "PN",
                                                        id: appState.item.id)),
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
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                                EdgeInsets>(
                                            const EdgeInsets.symmetric(vertical: 5)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.blue),
                                      ),
                                      onPressed: () {
                                        if (appState.item.isSub) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  VideoListScreen(
                                                type: "PN",
                                                files: appState.item.videoFiles,
                                              ),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PremiumMessage(
                                                        onClick: onSubscribe,
                                                        type: "PN",
                                                        id: appState.item.id)),
                                          );
                                        }
                                      },
                                      child: Column(
                                        children: const [
                                          Icon(Icons.tv),
                                          Text(
                                            "Video",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.1),
                            child: Html(
                              data: appState.item.description,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoViewScreen(
                                      isUbube: false,
                                      url: appState.item.introVideo),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              alignment: Alignment.center,
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 3,
                                      blurRadius: 2,
                                      offset: const Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Image.network(
                                  appState.item.introThumbnail,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.1),
                            child: Html(
                              data: appState.item.introDescription,
                            ),
                          )
                        ],
                      ),
                    );
                  })));
  }
}
