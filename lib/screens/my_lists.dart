import 'package:flutter/material.dart';
import 'package:optimize/providers/my_list_provider.dart';
import 'package:optimize/widgets/full_screen_preloader.dart';

import 'package:optimize/widgets/one_z_one_widget.dart';
import 'package:optimize/widgets/plus_one_widget.dart';

import 'package:optimize/widgets/pn_widget.dart';
import 'package:optimize/widgets/three_minutes_widget.dart';
import 'package:provider/provider.dart';

import '../constants/active_constants.dart';
import '../widgets/my_drawer.dart';

import 'search.dart';

class MyLists extends StatefulWidget {
  const MyLists({Key? key}) : super(key: key);

  @override
  _MyListsState createState() => _MyListsState();
}

class _MyListsState extends State<MyLists> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  bool _isInit = false;
  bool _isPreloading = false;

  void loadData() async {
    setState(() {
      _isPreloading = true;
    });

    await Provider.of<MyListProvider>(context, listen: false).getAll();

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
    List<String> _fav = ['h'];
    List<String> _com = ['d'];
    List<String> _sav = ['v'];

    return Scaffold(
        appBar: AppBar(
          backgroundColor: activeColors.primary,
          elevation: 0.0,
          centerTitle: true,
          titleSpacing: 0.0,
          titleTextStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          title: const Text('My Lists'),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Search(),
                  ),
                );
              },
              child: activeIcons.search,
            ),
            const SizedBox(width: 20.0),
          ],
          bottom: PreferredSize(
            child: Container(
              color: activeColors.white,
              child: TabBar(
                controller: _tabController,
                indicatorWeight: 2.1,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.grey.shade700,
                labelColor: Colors.grey.shade600,
                labelStyle: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'FAVORITES'),
                  Tab(text: 'COMPLETED'),
                  Tab(text: 'SAVED'),
                ],
              ),
            ),
            preferredSize: const Size.fromHeight(48.0),
          ),
        ),
        drawer: const MyDrawer(),
        body: Consumer<MyListProvider>(builder: (context, appState, child) {
          return _isPreloading
              ? FullScreenPreloader()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _fav.isEmpty
                        ? const NoItemsMessage(
                            title: 'Favorited',
                            verb: 'faves',
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                Column(
                                  children: [
                                    for (var item in appState.favPlusOnes)
                                      PlusOneWidget(data: item),
                                  ],
                                ),
                                Column(
                                  children: [
                                    for (var item in appState.favPns)
                                      PNWidget(data: item),
                                  ],
                                ),
                                appState.favOneZOnes.isEmpty ? const Center(child: Text("No Fav Item"),) :
                                Column(
                                  children: [
                                    for (var item in appState.favOneZOnes)
                                      OneZOneWidget(data: item),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  children: [
                                    for (var item in appState.favThreeMinutes)
                                      ThreeMinutesWidget(data: item),
                                  ],
                                ),
                              ],
                            ),
                          ),
                    _com.isEmpty
                        ? const NoItemsMessage(
                            title: 'Completed',
                            verb: 'completed',
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 20),

                                appState.tipPlusOnes.isEmpty ? const Center(child: Text("No Completed Item"),) :
                                Column(
                                  children: [
                                    for (var item in appState.tipPlusOnes)
                                      PlusOneWidget(data: item),
                                  ],
                                ),
                                Column(
                                  children: [
                                    for (var item in appState.tipPns)
                                      PNWidget(data: item),
                                  ],
                                ),
                                Column(
                                  children: [
                                    for (var item in appState.tipOneZOnes)
                                      OneZOneWidget(data: item),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  children: [
                                    for (var item in appState.tipThreeMinutes)
                                      ThreeMinutesWidget(data: item),
                                  ],
                                ),
                              ],
                            ),
                          ),
                    _sav.isEmpty
                        ? const NoItemsMessage(
                            title: 'Saved',
                            verb: 'saved',
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                appState.bookPlusOnes.isEmpty ? const Center(child: Text("No Saved Item"),) :
                                Column(
                                  children: [
                                    for (var item in appState.bookPlusOnes)
                                      PlusOneWidget(data: item),
                                  ],
                                ),
                                Column(
                                  children: [
                                    for (var item in appState.bookPns)
                                      PNWidget(data: item),
                                  ],
                                ),
                                Column(
                                  children: [
                                    for (var item in appState.bookOneZOnes)
                                      OneZOneWidget(data: item),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  children: [
                                    for (var item in appState.bookThreeMinutes)
                                      ThreeMinutesWidget(data: item),
                                  ],
                                ),
                              ],
                            ),
                          ),
                  ],
                );
        }));
  }
}

class NoItemsMessage extends StatelessWidget {
  const NoItemsMessage({
    required this.title,
    required this.verb,
    Key? key,
  }) : super(key: key);

  final String title;
  final String verb;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'You have not $title any content yet.',
          style: activeTextStyles.description.copyWith(
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          width: 340.0,
          child: Text(
            'Once you $verb a +1, PhilosophersNotes, Master Class, etc., it will apper under this section of My Lists.',
            style: activeTextStyles.small.copyWith(
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: const Text(
            'Browse recent Wisdom',
          ),
        ),
        const SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            activeIcons.refresh,
            Text(
              'Refresh',
              style: TextStyle(
                color: activeColors.primary,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// class PNWidget extends StatelessWidget {
//   const PNWidget({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final deviceWidth = MediaQuery.of(context).size.width;

//     return Column(
//       children: [
//         const SizedBox(height: 20.0),
//         SizedBox(
//           height: 150.0,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     print('PN!');
//                   },
//                   child: Container(
//                     width: deviceWidth < 400.0 ? 100.0 : 120.0,
//                     height: deviceWidth < 400.0 ? 136.0 : 150.0,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       image: const DecorationImage(
//                         image: NetworkImage(
//                           "https://images.unsplash.com/photo-1487029413235-e3f7a0e8e140?fit=crop&w=1050&q=80",
//                         ),
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 15.0),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Tiny Habits',
//                       style: activeTextStyles.title,
//                     ),
//                     SizedBox(
//                       width: deviceWidth < 400.0 ? 230.0 : 250.0,
//                       child: Text(
//                         'The Small Changes That Change Everything',
//                         style: activeTextStyles.caption,
//                       ),
//                     ),
//                     Text(
//                       'B. J. Fogg',
//                       style: activeTextStyles.author,
//                     ),
//                     Row(
//                       children: [
//                         activeIcons.heartCircleFill,
//                         const SizedBox(width: 10.0),
//                         activeIcons.checkCircleFill,
//                         const SizedBox(width: 10.0),
//                         activeIcons.saveCircleFill,
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 7.0),
//         Divider(
//           height: 2.0,
//           thickness: 1.0,
//           color: activeColors.grey,
//         ),
//       ],
//     );
//   }
// }

// class PlusOneWidget extends StatelessWidget {
//   const PlusOneWidget({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final deviceWidth = MediaQuery.of(context).size.width;

//     return Column(
//       children: [
//         const SizedBox(height: 20.0),
//         SizedBox(
//           height: 120.0,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     print('Plus One!');
//                   },
//                   child: Container(
//                     width: deviceWidth < 400.0 ? 123.0 : 133.0,
//                     height: deviceWidth < 400.0 ? 75.0 : 90.0,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       image: const DecorationImage(
//                         image: NetworkImage(
//                           "https://images.unsplash.com/photo-1541329164087-0283eda68eda?fit=crop&w=634&q=80",
//                         ),
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                     child: activeIcons.playerCircleFill,
//                   ),
//                 ),
//                 const SizedBox(width: 5.0),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       width: deviceWidth < 400.0 ? 210.0 : 240.0,
//                       child: Wrap(
//                         children: [
//                           Text(
//                             'How to Celebrate',
//                             style: activeTextStyles.title,
//                           ),
//                           Text(
//                             '#1207',
//                             style: activeTextStyles.muted,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: 180.0,
//                       child: Text(
//                         'Hint: IMMEDIATELY + INTENSELY',
//                         style: activeTextStyles.caption,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         activeIcons.heartCircleFill,
//                         const SizedBox(width: 10.0),
//                         activeIcons.checkCircleFill,
//                         const SizedBox(width: 10.0),
//                         activeIcons.saveCircleFill,
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 10.0),
//         Divider(
//           height: 2.0,
//           thickness: 1.0,
//           color: activeColors.grey,
//         ),
//       ],
//     );
//   }
// }

// class OneZOneWidget extends StatelessWidget {
//   const OneZOneWidget({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final deviceWidth = MediaQuery.of(context).size.width;

//     return Column(
//       children: [
//         const SizedBox(height: 20.0),
//         SizedBox(
//           height: 230.0,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     print('One Zero One!');
//                   },
//                   child: Container(
//                     width: deviceWidth < 400.0 ? 123.0 : 133.0,
//                     height: deviceWidth < 400.0 ? 75.0 : 90.0,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       image: const DecorationImage(
//                         image: NetworkImage(
//                           "https://images.unsplash.com/photo-1513149739851-50f01dfcbd9a?fit=crop&w=1350&q=80",
//                         ),
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                     child: activeIcons.playerCircleFill,
//                   ),
//                 ),
//                 const SizedBox(width: 5.0),
//                 SizedBox(
//                   width: deviceWidth < 400.0 ? 210.0 : 240.0,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Positive Psychology 101',
//                         style: activeTextStyles.title,
//                       ),
//                       Text(
//                         'How to Tap into the Science of Optimizing + Actualizing',
//                         style: activeTextStyles.caption,
//                       ),
//                       Text(
//                         'I LOVE the science of flourishing. In this class, we have fun exploring my absolute favorite Big Ideas from my...',
//                         style: activeTextStyles.small.copyWith(
//                           fontSize: 16.0,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           activeIcons.heartCircleFill,
//                           const SizedBox(width: 10.0),
//                           activeIcons.checkCircleFill,
//                           const SizedBox(width: 10.0),
//                           activeIcons.saveCircleFill,
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 10.0),
//         Divider(
//           height: 2.0,
//           thickness: 1.0,
//           color: activeColors.grey,
//         ),
//       ],
//     );
//   }
// }
