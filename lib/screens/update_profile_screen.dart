import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:optimize/constants/active_constants.dart';
import 'package:optimize/providers/auth_provider.dart';
import 'package:optimize/widgets/full_screen_preloader.dart';
import 'package:optimize/widgets/message_dialog.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  bool _isInit = false;
  bool _isPreloading = false;
  bool _passwordVisible = false;
  bool _actionLoading = false;
  final Map<String, String> _authData = {
    'name': '',
  };
  final Map<String, String> _initValues = {
    'name': '',
  };
  final GlobalKey<FormState> _formKey = GlobalKey();

  void loadData() async {
    setState(() {
      _isPreloading = true;
    });

    await Provider.of<Auth>(context, listen: false).getUser();

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

  bool isValidEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(email);
  }

  @override
  void initState() {
    _passwordVisible = false;
  }

  Future<void> _submit() async {
    if (!_actionLoading) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          setState(() {
            _actionLoading = true;
          });
          await Provider.of<Auth>(context, listen: false)
              .updateProfile(_authData);
          setState(() {
            _actionLoading = false;
          });
          Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        } catch (error) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: activeColors.primary,
        title: const Text("   Update Profile"),
        centerTitle: false,
        titleSpacing: 0.0,
        titleTextStyle: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: _isPreloading
          ? FullScreenPreloader()
          : Consumer<Auth>(builder: (context, authState, child) {
              return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                                    initialValue:
                                        authState.currentUser.username,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Name is  required';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) =>
                                        _authData['name'] = value!,
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Type Your First Name',
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            FlatButton(
                              child: Text(
                                _actionLoading ? 'Loading...' : 'Update',
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
                          ],
                        ),
                      )));
            }),
    );
  }
}
