import 'package:flutter/material.dart';
import 'package:optimize/providers/auth_provider.dart';
import 'package:optimize/screens/my_lists.dart';
import 'package:optimize/screens/noti.dart';
import 'package:optimize/screens/user_profile_screen.dart';
import 'package:provider/provider.dart';

import '../constants/active_constants.dart';
import '../home.dart';

class DrawerItem {
  final IconData icon;
  final String pageName;

  final Function onPress;

  const DrawerItem(
      {required this.icon, required this.pageName, required this.onPress});
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DrawerItem> drawerItems = [
      DrawerItem(
          icon: activeIcons.home,
          pageName: 'Home',
          onPress: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
            );
          }),
      DrawerItem(
          icon: activeIcons.noti,
          pageName: 'Notifications',
          onPress: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const NotiScreen(),
              ),
            );
          }),
      // DrawerItem(
      //     icon: activeIcons.cloud, pageName: 'Offline content', onPress: () {}),
      DrawerItem(
          icon: activeIcons.profile,
          pageName: 'Manage Profile',
          onPress: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfileScreen(),
              ),
            );
          }),
      DrawerItem(
          icon: activeIcons.profile,
          pageName: 'My List',
          onPress: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MyLists(),
              ),
            );
          }),
      DrawerItem(
          icon: activeIcons.walker,
          pageName: 'Log Out',
          onPress: () async {
            await Provider.of<Auth>(context, listen: false).logout();
            Navigator.of(context).popAndPushNamed('/sign_in_screen');
          }),
    ];

    return Drawer(
      child: SafeArea(
        child: Container(
          color: activeColors.black,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                color: activeColors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('assets/images/logo.png',
                        width: 60, height: 60),
                    const SizedBox(width: 10.0),
                    Text(
                      'မာသင်',
                      style: TextStyle(
                        color: activeColors.black,
                        fontSize: 19.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 23.0,
                  top: 15.0,
                ),
                child: Row(
                  children: const [],
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                height: 300.0,
                child: ListView(
                  padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                  children: drawerItems
                      .map(
                        (item) => DrawerTile(
                          title: item.pageName,
                          icon: item.icon,
                          onPress: item.onPress,
                        ),
                      )
                      .toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(width: 10.0),
                  Text(
                    'MORE GOODNESS',
                    style: TextStyle(
                      color: activeColors.primary,
                      fontSize: 10.0,
                    ),
                  ),
                  SizedBox(
                    width: 174.0,
                    child: Divider(
                      color: activeColors.primary,
                      height: 1.0,
                      thickness: 1.0,
                    ),
                  )
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 10.0, left: 16, right: 16),
              //   child: DrawerTile(
              //     title: 'Optimize Podcast',
              //     icon: activeIcons.podcast,
              //     onPress: () {},
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onPress;

  const DrawerTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {onPress()},
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 23,
              color: activeColors.grey,
            ),
            const SizedBox(width: 5.0),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                title,
                style: activeTextStyles.drawer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
