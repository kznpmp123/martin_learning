import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:optimize/constants/active_constants.dart';
import 'package:optimize/providers/auth_provider.dart';
import 'package:optimize/widgets/full_screen_preloader.dart';
import 'package:optimize/widgets/message_dialog.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isInit = false;
  bool _isPreloading = false;
  bool _passwordVisible = false;
  bool _actionLoading = false;
  final Map<String, String> _authData = {
    'current_password': '',
    'new_password': '',
    'new_password_confirmation': '',
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
              .changePassword(_authData);
          setState(() {
            _actionLoading = false;
          });
          Fluttertoast.showToast(
            msg: "Success.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        } catch (error) {
          setState(() {
            _actionLoading = false;
          });
          MessageDialog.show(
              context, error.toString(), "Change Password Fails", "Try Again");
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
        title: const Text("   Change Password"),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Text("Current Password"),
                                      TextFormField(
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Current Password is  required';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) =>
                                            _authData['current_password'] =
                                                value!,
                                        obscureText:
                                            !_passwordVisible, //This will obscure text dynamically
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText:
                                              'Type Your Current Password',
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
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Text("New Password"),
                                      TextFormField(
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Password is  required';
                                          } else if (value.length <= 3) {
                                            return 'Password should be more than 3 characters';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) =>
                                            _authData['new_password'] = value!,
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
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Text("Confirm New Password"),
                                      TextFormField(
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Confirm Password is  required';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) => _authData[
                                                'new_password_confirmation'] =
                                            value!,
                                        obscureText:
                                            !_passwordVisible, //This will obscure text dynamically
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText:
                                              'Type Your Confirm Password',
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
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                            const SizedBox(height: 30),
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
