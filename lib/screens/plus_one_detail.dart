import 'package:comment_box/comment/comment.dart';
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
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List filedata = [
    {
      'name': 'Jisoo',
      'pic':
          'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgqkvAbF41MS2VLRfIbsm6ogZUWla32EL2-RqRrNRRXnaYSbgz5lNas8lOOJANTp_yNA8JXW1W3N2YySTHuanO6EUudcRUxIRKZ1ZIpov7b-3MZXOfy2PHZ79Hww3wQZsrzS49SIlOVnh02WzduwaNRA3cYzyiLbjh9mdgyxwjWPXG3kfXVvzx_93MSTg/s16000/Jisoo.jpg',
      'message': 'Nice'
    },
    {
      'name': 'Lisa',
      'pic':
          'https://6.viki.io/image/755126efed4042a9900fdc8d788ff9a6/dummy.jpeg?s=900x600&e=t',
      'message': 'Very cool'
    },
    {
      'name': 'Jennie',
      'pic':
          'https://lh3.googleusercontent.com/kSue6Hy7y1joZRrGLZOhOZKUrQ1OvKFO74qhM5HHztyg71lDHK3K-631VrSiHbljuhBG7pJH90RS3MAPvrcODd90aYy4V93RTw=w960-rj-nu-e365',
      'message': 'Very cool'
    },
    {
      'name': 'Rosé',
      'pic':
          'https://blogger.googleusercontent.com/img/a/AVvXsEjbBFcf_WZs5zyor8cRzZDaKjnzsFq0RvPbAH_SUcCpcW2jqxRuY2WnpN1FtrlbHKeeOnnpnHgzPloI5fgLkmDhQeBQy_b9_T6UW3zR4oX5XfIA9VkXKMUXAU3NHOoZfZ1jU3BGe8yhpc_eK8R7jTeWcT9l05gEpGEj7HEovFtTTphH-8uCVXQGZxWT=s16000',
      'message': 'Very cool'
    },
  ];

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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: commentController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: "Comment Here",
                                    suffixIcon: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.send_rounded),
                                    ),
                                  ),
                          
                                  // textInputAction: TextInputAction.next,
                                  // validator: (val) {
                                  //   if (val!.isEmpty) {
                                  //     return "$validator is Required";
                                  //   } else {
                                  //     return null;
                                  //   }
                                  // },
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: filedata.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: GestureDetector(
                                          onTap: () async {
                                            // Display the image in large form.
                                            print("Comment Clicked");
                                          },
                                          child: Container(
                                            height: 50.0,
                                            width: 50.0,
                                            decoration: const BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50))),
                                            child: CircleAvatar(
                                                radius: 50,
                                                backgroundImage: NetworkImage(
                                                    filedata[index]['pic'])),
                                          ),
                                        ),
                                        title: Text(
                                          filedata[index]['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle:
                                            Text(filedata[index]['message']),
                                      );
                                    })
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  })));
  }
}
