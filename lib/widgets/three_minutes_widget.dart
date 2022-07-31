import 'package:flutter/material.dart';
import 'package:optimize/models/ThreeMintues.dart';
import 'package:optimize/screens/three_minutes_detail.dart';
import 'package:optimize/screens/video_view_screen.dart';

import '../constants/active_constants.dart';

class ThreeMinutesWidget extends StatelessWidget {
  final ThreeMinutes data;
  final double marginBottom;
  const ThreeMinutesWidget({Key? key, required this.data, this.marginBottom = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ThreeMinutesDetail(
              data: data,
            ),
          ),
        );
      },
      child: SizedBox(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          margin: EdgeInsets.only(bottom: marginBottom),
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
                          url: data.video, isUbube: data.isUtube),
                    ),
                  );
                },
                child: Container(
                  width: deviceWidth < 400.0 ? 123.0 : 133.0,
                  height: deviceWidth < 400.0 ? 75.0 : 90.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: data.video != null
                          ? NetworkImage(data.thumbnail)
                          : const NetworkImage(
                          'https://thumbs.dreamstime.com/b/no-thumbnail-image-placeholder-forums-blogs-websites-148010362.jpg'),
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
                          data.title,
                          style: activeTextStyles.title,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '#' + data.code,
                    style: activeTextStyles.muted,
                  ),
                  SizedBox(
                    width: 180.0,
                    child: Text(
                      data.subtitle,
                      style: activeTextStyles.caption,
                    ),
                  ),
                ],
              ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const PlusOneDetail(),
              //       ),
              //     );
              //   },
              //   child: activeIcons.download,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
