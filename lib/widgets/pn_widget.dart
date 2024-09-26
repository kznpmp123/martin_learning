import 'package:flutter/material.dart';
import 'package:optimize/models/Pn.dart';
import 'package:optimize/screens/pn_detail_screen.dart';

import '../constants/active_constants.dart';

class PNWidget extends StatelessWidget {
  final Pn data;
  final double marginBottom;
  const PNWidget({
    required this.data,
    this.marginBottom = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    final List<String> _categories = [
      'algorithms',
      'habits',
      'celebrate',
      'willpower',
      'best-of-optimize',
    ];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PnDetail(data: data),
          ),
        );
      },
      child: SizedBox(
        height: data.categories.length > 4 ? 230.0 : 200.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          margin: EdgeInsets.only(bottom: marginBottom),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  print('PN!');
                },
                child: Container(
                  width: deviceWidth < 400.0 ? 100.0 : 120.0,
                  height: deviceWidth < 400.0 ? 136.0 : 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: NetworkImage(
                        data.coverImage,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title.length > 15
                        ? data.title.substring(0, 12) + "..."
                        : data.title,
                    style: activeTextStyles.title,
                  ),
                  SizedBox(
                    width: deviceWidth < 400.0 ? 200.0 : 220.0,
                    child: Text(
                      data.subtitle,
                      style: activeTextStyles.caption,
                    ),
                  ),
                  Text(
                    data.authorName,
                    style: activeTextStyles.author,
                  ),
                  // Row(
                  //   children: [
                  //     GestureDetector(
                  //       onTap: () {
                  //         // Navigator.push(
                  //         //   context,
                  //         //   MaterialPageRoute(
                  //         //     builder: (context) => PDFViewScreen(
                  //         //       pdf: data.pdf,
                  //         //       title: data.title,
                  //         //     ),
                  //         //   ),
                  //         // );
                  //       },
                  //       child: Row(
                  //         children: [
                  //           Icon(
                  //             activeIcons.doc,
                  //             color: activeColors.secondary,
                  //             size: 18.0,
                  //           ),
                  //           const SizedBox(width: 3.0),
                  //           Text(
                  //             'Read',
                  //             style: activeTextStyles.actions,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     const SizedBox(width: 10.0),
                  //     GestureDetector(
                  //       onTap: () {
                  //         // Navigator.push(
                  //         //   context,
                  //         //   MaterialPageRoute(
                  //         //     builder: (context) => MusicPlayerScreen(
                  //         //       link: data.audio,
                  //         //       cover: data.coverImage,
                  //         //       title: data.title,
                  //         //       subTitle: data.subtitle,
                  //         //     ),
                  //         //   ),
                  //         // );
                  //       },
                  //       child: Row(
                  //         children: [
                  //           Icon(
                  //             activeIcons.volume,
                  //             color: activeColors.secondary,
                  //             size: 18.0,
                  //           ),
                  //           const SizedBox(width: 3.0),
                  //           Text(
                  //             'Listen',
                  //             style: activeTextStyles.actions,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     const SizedBox(width: 10.0),
                  //     GestureDetector(
                  //       onTap: () {
                  //         // Navigator.push(
                  //         //   context,
                  //         //   MaterialPageRoute(
                  //         //       builder: (context) =>
                  //         //           VideoViewScreen(url: data.video)),
                  //         // );
                  //       },
                  //       child: Row(
                  //         children: [
                  //           Icon(
                  //             activeIcons.playFill,
                  //             color: activeColors.secondary,
                  //             size: 18.0,
                  //           ),
                  //           const SizedBox(width: 3.0),
                  //           Text(
                  //             'Watch',
                  //             style: activeTextStyles.actions,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    width: deviceWidth < 400.0 ? 200.0 : 220.0,
                    child: Wrap(
                      spacing: 5.0,
                      runSpacing: 6.0,
                      children: data.categories
                          .map(
                            (cat) => Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: activeColors.grey,
                                ),
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                  horizontal: 6.0,
                                ),
                                child: Text(
                                  cat.name.toUpperCase(),
                                  style: activeTextStyles.small,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
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
