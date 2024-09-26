import 'package:flutter/material.dart';
import 'package:optimize/providers/one_z_one_provider.dart';
import 'package:optimize/providers/sort_provider.dart';
import 'package:optimize/widgets/full_screen_preloader.dart';
import 'package:provider/provider.dart';

import '../constants/active_constants.dart';
import '../widgets/one_z_one_widget.dart';

class OneZeroOne extends StatefulWidget {
  const OneZeroOne({Key? key}) : super(key: key);

  @override
  _OneZeroOneState createState() => _OneZeroOneState();
}

class _OneZeroOneState extends State<OneZeroOne> {
  bool _isInit = false;
  bool _isPreloading = false;

  void loadData() async {
    setState(() {
      _isPreloading = true;
    });
    bool sorted = Provider.of<SortProvider>(context, listen: true).sort;
    await Provider.of<OneZOneProvider>(context, listen: false).getAll(sorted);

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
            : Consumer<OneZOneProvider>(builder: (context, appState, child) {
                return ListView.builder(
                  itemCount: appState.items.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(height: 20.0),
                        OneZOneWidget(data: appState.items[index]),
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
