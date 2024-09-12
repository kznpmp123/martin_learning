import 'package:flutter/material.dart';

import '../widgets/home_app_bar.dart';
import '../widgets/my_drawer.dart';
import '../constants/active_constants.dart';

class FeaturedFull extends StatefulWidget {
  const FeaturedFull({Key? key}) : super(key: key);

  @override
  _FeaturedFullState createState() => _FeaturedFullState();
}

class _FeaturedFullState extends State<FeaturedFull> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        currentIndex: 0,
        bgColor: activeColors.primary,
      ),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25.0),
            Center(
              child: Text(
                'Daily Wisdom',
                style: activeTextStyles.header,
              ),
            ),
            const SizedBox(height: 10.0),
            Center(
              child: Text(
                'A daily guided tour through the most',
                style: activeTextStyles.description,
              ),
            ),
            Center(
              child: Text(
                'life-changing wisdom from the Optimize library.',
                style: activeTextStyles.description,
              ),
            ),
            const SizedBox(height: 36.0),
            //    const PNWidget(),
            const SizedBox(height: 25.0),
            //      const PlusOneWidget(),
            const SizedBox(height: 25.0),
            //      const OneZOneWidget(),
          ],
        ),
      ),
    );
  }
}
