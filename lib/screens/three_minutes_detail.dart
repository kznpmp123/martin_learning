import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:optimize/constants/colors.dart';
import 'package:optimize/models/Comment.dart';
import 'package:optimize/models/ThreeMintues.dart';
import 'package:optimize/providers/auth_provider.dart';
import 'package:optimize/providers/comment_provider.dart';
import 'package:optimize/providers/three_minutes_provider.dart';
import 'package:optimize/screens/music_player_screen.dart';
import 'package:optimize/screens/video_view_screen.dart';
import 'package:optimize/widgets/full_screen_preloader.dart';
import 'package:provider/provider.dart';
import '../constants/active_constants.dart';

class ThreeMinutesDetail extends StatefulWidget {
  final ThreeMinutes data;
  const ThreeMinutesDetail({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<ThreeMinutesDetail> createState() => _ThreeMinutesDetailState();
}

class _ThreeMinutesDetailState extends State<ThreeMinutesDetail> {
  bool _isInit = false;
  bool _isPreloading = false;
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  void loadData() async {
    setState(() {
      _isPreloading = true;
    });

    await Provider.of<ThreeMinutesProvider>(context, listen: false)
        .getEach(widget.data.id);

    setState(() {
      _isPreloading = false;
    });
  }

  void loadComment() async {
    setState(() {
      _isPreloading = true;
    });
    await Provider.of<CommentProvider>(context, listen: false)
        .getAll('three-minutes', widget.data.id);
    setState(() {
      _isPreloading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      loadData();
      loadComment();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);

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
            : Consumer<ThreeMinutesProvider>(
                builder: (context, appState, child) {
                  return Column(
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
                                          await Provider.of<
                                                      ThreeMinutesProvider>(
                                                  context,
                                                  listen: false)
                                              .markData(
                                                  "like", appState.item.id, 0);
                                        },
                                        child: activeIcons.heartCircleFill)
                                    : GestureDetector(
                                        onTap: () async {
                                          await Provider.of<
                                                      ThreeMinutesProvider>(
                                                  context,
                                                  listen: false)
                                              .markData(
                                                  "like", appState.item.id, 1);
                                        },
                                        child: activeIcons.heartCircle),
                                const SizedBox(width: 10.0),
                                appState.item.isTipped
                                    ? GestureDetector(
                                        onTap: () async {
                                          await Provider.of<
                                                      ThreeMinutesProvider>(
                                                  context,
                                                  listen: false)
                                              .markData(
                                                  "tip", appState.item.id, 0);
                                        },
                                        child: activeIcons.checkCircleFill)
                                    : GestureDetector(
                                        onTap: () async {
                                          await Provider.of<
                                                      ThreeMinutesProvider>(
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
                                          await Provider.of<
                                                      ThreeMinutesProvider>(
                                                  context,
                                                  listen: false)
                                              .markData("bookmark",
                                                  appState.item.id, 0);
                                        },
                                        child: activeIcons.saveCircleFill)
                                    : GestureDetector(
                                        onTap: () async {
                                          await Provider.of<
                                                      ThreeMinutesProvider>(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
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
                              const SizedBox(width: 10.0),
                              ElevatedButton(
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
                            ],
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: commentController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Comment is  required';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Type Your Comment',
                                  hintStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: colorScheme1.black),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: colorScheme1.black),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: colorScheme1.black),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        await Provider.of<CommentProvider>(
                                                context,
                                                listen: false)
                                            .postComment(
                                                'three-minutes',
                                                {
                                                  'body': commentController.text
                                                },
                                                widget.data.id);
                                        commentController.clear();
                                      }
                                    },
                                    icon: Icon(
                                      Icons.send_rounded,
                                      color: colorScheme1.black,
                                    ),
                                  ),
                                ),
                              ),
                              Consumer<CommentProvider>(
                                builder: (context, appState, child) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: appState.comments.length,
                                    itemBuilder: (context, index) {
                                      CommentModel comment =
                                          appState.comments[index];

                                      return ListTile(
                                        title: Text(
                                          comment.user.username,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          comment.body,
                                        ),
                                        trailing: auth.currentUser.id ==
                                                comment.user.id
                                            ? InkWell(
                                                onTap: () async {
                                                  await Provider.of<
                                                              CommentProvider>(
                                                          context,
                                                          listen: false)
                                                      .deleteComment(
                                                          'three-minutes',
                                                          comment.id);
                                                },
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              )
                                            : null,
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
