import 'package:flutter/material.dart';
import 'package:optimize/models/OneZOne.dart';
import 'package:optimize/screens/one_z_one_detail_screen.dart';
import 'package:optimize/screens/video_view_screen.dart';

import '../constants/active_constants.dart';

class OneZOneWidget extends StatelessWidget {
  final OneZOne data;
  final double marginBottom;
  const OneZOneWidget({Key? key, required this.data, this.marginBottom = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OneZOneDetailScreen(data: data),
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
                        url: data.video,
                        isUbube: data.isUtube,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: deviceWidth < 400.0 ? 123.0 : 133.0,
                  height: deviceWidth < 400.0 ? 75.0 : 90.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: NetworkImage(
                        data.thumbnail,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: activeIcons.playerCircleFill,
                ),
              ),
              const SizedBox(width: 5.0),
              SizedBox(
                width: deviceWidth < 400.0 ? 180.0 : 200.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: activeTextStyles.title,
                    ),
                    Text(
                      data.subtitle,
                      style: activeTextStyles.caption,
                    ),
                    // Text(
                    //   data.description,
                    //   style: activeTextStyles.small.copyWith(
                    //     fontSize: 16.0,
                    //   ),
                    // ),
                  ],
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(
              //     //     builder: (context) => const Home(),
              //     //   ),
              //     // );
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
