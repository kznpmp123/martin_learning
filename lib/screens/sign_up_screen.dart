import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:optimize/constants/active_constants.dart';
import 'package:optimize/providers/auth_provider.dart';
import 'package:optimize/screens/sign_in_screen.dart';
import 'package:optimize/widgets/message_dialog.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin? fltNotification;
  bool _passwordVisible = false;
  bool _actionLoading = false;
  final Map<String, String> _authData = {
    'name': '',
    'email': '',
    'password': '',
    'password_confirmation': ''
  };
  final Map<String, String> _initValues = {
    'name': '',
    'email': '',
    'password': '',
    'password_confirmation': ''
  };
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool isValidEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(email);
  }

  @override
  void initState() {
    _passwordVisible = false;
    notitficationPermission();
    initMessaging();
  }

  Future<void> _submit() async {
    if (!_actionLoading) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          setState(() {
            _actionLoading = true;
          });
          await Provider.of<Auth>(context, listen: false).register(_authData);
          setState(() {
            _actionLoading = false;
          });
          Fluttertoast.showToast(
            msg: "Success. You can login now",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInScreen(),
            ),
          );
        } catch (error) {
          print(error);
          setState(() {
            _actionLoading = false;
          });
          MessageDialog.show(
              context, error.toString(), "Sign Up Fails", "Try Again");
        }
      } else {
        return;
      }
    }
  }



  void initMessaging() async {
    // NotificationController? notificationController = Get.lazyPut();

    var androiInit = const AndroidInitializationSettings('@mipmap/ic_launcher');

    var iosInit = const IOSInitializationSettings(requestAlertPermission: true,requestBadgePermission: true,requestSoundPermission: true,);

    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);

    fltNotification = FlutterLocalNotificationsPlugin();

    fltNotification!.initialize(initSetting);

    //register topic
    messaging.subscribeToTopic("all");

    print('vvvvvvv');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
    });
  }

  // Future selectNotification(String payload) async {
  //   if (payload != null) {
  //     debugPrint('notification payload: $payload');
  //   }
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
  //   );
  // }

  void showNotification(RemoteMessage message) async {
    // var initializationSettingsAndroid = new AndroidInitializationSettings('logovtc');

    // final InitializationSettings initializationSettings = InitializationSettings(
    //     android: initializationSettingsAndroid,);

    var androidDetails = AndroidNotificationDetails('1', message.notification!.title ?? '',icon: '@mipmap/ic_launcher',color:  const Color(0xFF0f90f3),);

    // await fltNotification!.initialize(initializationSettings,
    //     onSelectNotification: selectNotification );
    var iosDetails = const IOSNotificationDetails();

    var generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await fltNotification!.show(0, message.notification!.title ?? '',
        message.notification!.body ?? '',generalNotificationDetails,
        payload: 'Notification');
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }


  void notitficationPermission() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome !",
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
              const Text(
                "Let's Create",
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
              const Text(
                "Your Account",
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                initialValue: _initValues['name'],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Name is  required';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _authData['name'] = value!,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Type Your Name',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                initialValue: _initValues['email'],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Email is  required';
                                  } else if (!isValidEmail(value)) {
                                    return 'Your email is invalid';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _authData['email'] = value!,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Type Your Email',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Password is  required';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) =>
                                        _authData['password'] = value!,
                                    obscureText:
                                        !_passwordVisible, //This will obscure text dynamically
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Type Your Password',
                                      hintStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),

                                      border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.orange,
                                              width: 32.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),

                                      // Here is key idea
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          _passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onPressed: () {
                                          // Update the state i.e. toogle the state of passwordVisible variable
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ])),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Confirm Password is  required';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) =>
                                        _authData['password_confirmation'] =
                                            value!,
                                    obscureText:
                                        !_passwordVisible, //This will obscure text dynamically
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Type Your Confirm Password',
                                      hintStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),

                                      border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.orange,
                                              width: 32.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),

                                      // Here is key idea
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          _passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onPressed: () {
                                          // Update the state i.e. toogle the state of passwordVisible variable
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ])),
                        const SizedBox(
                          height: 30,
                        ),
                        FlatButton(
                          child: Text(
                            _actionLoading ? 'Loading...' : 'Create Account',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          color: activeColors.primary,
                          onPressed: _submit,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 15),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()),
                            );
                          },
                          child: const Text(
                            "Already a member? Sign In",
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
