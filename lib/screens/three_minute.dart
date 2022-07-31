import 'package:flutter/material.dart';
import 'package:optimize/providers/sort_provider.dart';
import 'package:optimize/providers/three_minutes_provider.dart';
import 'package:optimize/widgets/full_screen_preloader.dart';
import 'package:optimize/widgets/three_minutes_widget.dart';
import 'package:provider/provider.dart';

import '../constants/active_constants.dart';

class ThreeMinture extends StatefulWidget {
  const ThreeMinture({Key? key}) : super(key: key);

  @override
  _ThreeMintureState createState() => _ThreeMintureState();
}

class _ThreeMintureState extends State<ThreeMinture> {
  bool _isInit = false;
  bool _isPreloading = false;

  void loadData() async {
    setState(() {
      _isPreloading = true;
    });
    bool sorted = Provider.of<SortProvider>(context, listen: true).sort;
    await Provider.of<ThreeMinutesProvider>(context, listen: false)
        .getAll(sorted);

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
    return Scaffold(
        body: _isPreloading
            ? FullScreenPreloader()
            : Consumer<ThreeMinutesProvider>(builder: (context, appState, child) {
                return ListView.builder(
                  itemCount: appState.items.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(height: 20.0),
                        ThreeMinutesWidget(data: appState.items[index]),
                        const SizedBox(height: 10.0),
                        Divider(
                          height: 2.0,
                          thickness: 1.0,
                          color: activeColors.grey,
                        ),
                      ],
                    );
                  },
                );
              }));
  }
}
