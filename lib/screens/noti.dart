import 'package:flutter/material.dart';
import 'package:optimize/models/Noti.dart';
import 'package:optimize/providers/notification_provider.dart';
import 'package:optimize/widgets/full_screen_preloader.dart';
import 'package:provider/provider.dart';

import '../constants/active_constants.dart';

import '../widgets/minor_app_bar.dart';
import '../widgets/my_drawer.dart';

class NotiScreen extends StatefulWidget {
  const NotiScreen({Key? key}) : super(key: key);

  @override
  _NotiScreenState createState() => _NotiScreenState();
}

class _NotiScreenState extends State<NotiScreen> {
  final bool _noti = false;
  bool _isInit = false;
  bool _isPreloading = false;

  void loadData() async {
    setState(() {
      _isPreloading = true;
    });

    await Provider.of<NotificationProvider>(context, listen: false).getAll();

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
      appBar: const MinorAppBar(title: 'Notifications'),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Divider(
            height: 2.0,
            thickness: 1.0,
            color: activeColors.grey,
          ),
          Expanded(
              child: _isPreloading
                  ? FullScreenPreloader()
                  : Consumer<NotificationProvider>(
                      builder: (context, appState, child) {
                      return ListView.builder(
                        itemCount: appState.items.length,
                        itemBuilder: (context, index) {
                          return NotiTile(data: appState.items[index]);
                        },
                      );
                    })),
        ],
      ),
    );
  }
}

class NotiTile extends StatelessWidget {
  final Noti data;
  const NotiTile({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5.0),
        ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 25.0,
              vertical: 3.0,
            ),
            title: Text(
              data.title,
              style: activeTextStyles.title.copyWith(
                fontSize: 16.0,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 7.0),
              child: Text(data.body),
            ),
            trailing: data.image.isNotEmpty
                ? Image.network(
                    data.image,
                    width: 50,
                    height: 50,
                  )
                : const SizedBox()),
        const SizedBox(height: 5.0),
        Divider(
          height: 2.0,
          thickness: 1.0,
          color: activeColors.grey,
        ),
      ],
    );
  }
}
