import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:optimize/screens/blog_page_screen.dart';
import 'package:optimize/screens/three_minute.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/my_drawer.dart';
import 'constants/active_constants.dart';

// screens
import 'screens/featured.dart';
import 'screens/plus_one.dart';
import 'screens/pn.dart';
import 'screens/one_z_one.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static const List<Widget> _pages = <Widget>[
    Featured(),
    PlusOne(),
    ThreeMinture(),
    PN(),
    OneZeroOne(),
    BlogPageScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("FirebaseMessaging.onMessage.listen remoteMessage");
      print(message);
      print(message.data.toString());
      print("app_url");
      print(message.data['app_url']);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("FirebaseMessaging.onMessageOpenedApp.listen remoteMessage");
      print(message);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.body!),
                      Text(message.data['app_url'] ?? "app_url")
                    ],
                  ),
                ),
                actions: [
                  InkWell(child: const Text("Update"), onTap: (){
                    print("update on tap");
                    // open playstore link in web
                    _launchURL(message.data['app_url'] ?? "app_url");
                    },
                  )
                ],
              );
            }
            );
      }
    });
    _fcmSubscribe();
  }
  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
  void _fcmSubscribe()async{
    print("fcm_build_3 ...");
    try{
      await FirebaseMessaging.instance.subscribeToTopic('fcm_build_3');
      print("fcm_build_3 subscribed");
    }
    catch(exp){
      print("fcm_build_3 subscribe fail exp");
      print(exp);
    }
  }

  void _showDialogOwn(){
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("title"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("body"),
                  Text("another message")
                ],
              ),
            ),
            actions: [
              InkWell(child: const Text("Update"), onTap: (){
                print("update on tap");
                // open playstore link in web
                Navigator.pop(context);
                _launchURL("https://google.com");
              },
              )
            ],
          );
        }
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HomeAppBar(
        currentIndex: _selectedIndex,
        bgColor: activeColors.primary,
      ),
      drawer: const MyDrawer(),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      //floatingActionButton: _fab(),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: activeIcons.diamond,
            label: 'Featured',
          ),
          BottomNavigationBarItem(
            icon: activeIcons.calendar,
            label: '+1',
          ),
          BottomNavigationBarItem(
            icon: activeIcons.calendar,
            label: '3min',
          ),
          BottomNavigationBarItem(
            icon: activeIcons.file,
            label: 'Book',
          ),
          BottomNavigationBarItem(
            icon: activeIcons.player,
            label: 'Course',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Blog',
          ),
        ],
        backgroundColor: activeColors.black,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: activeColors.white,
        selectedIconTheme: const IconThemeData(size: 20.0),
        selectedLabelStyle: const TextStyle(
          fontSize: 11.0,
        ),
        showSelectedLabels: true,
        unselectedLabelStyle: const TextStyle(
          fontSize: 11.0,
        ),
        unselectedItemColor: Colors.grey.shade700,
        unselectedIconTheme: const IconThemeData(size: 20.0),
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _fab(){
    return FloatingActionButton(onPressed: _showDialogOwn, child: const Icon(Icons.refresh),);
  }
}
