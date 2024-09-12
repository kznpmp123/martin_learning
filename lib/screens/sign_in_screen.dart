import 'package:flutter/material.dart';
import 'package:optimize/constants/active_constants.dart';
import 'package:optimize/providers/auth_provider.dart';
import 'package:optimize/widgets/message_dialog.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _passwordVisible = false;
  bool _actionLoading = false;
  final Map<String, String> _authData = {'email': '', 'password': ''};
  final Map<String, String> _initValues = {'email': '', 'password': ''};
  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _actionLoading = true;
        });
        await Provider.of<Auth>(context, listen: false).login(_authData);
        setState(() {
          _actionLoading = false;
        });
        Navigator.of(context).pop();
      } catch (error) {
        setState(() {
          _actionLoading = false;
        });
        MessageDialog.show(
            context, "Login Failed. Please try again", "Login", "Try Again");
      }
    } else {
      return;
    }
  }

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign In",
                style: TextStyle(color: Colors.white, fontSize: 35),
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
                            const   Text(
                                "Email",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                initialValue: _initValues['email'],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Email is  required';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _authData['email'] = value!,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Type your email',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
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
                                  const Text(
                                    "Password",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    onSaved: (value) =>
                                        _authData['password'] = value!,
                                    obscureText:
                                        !_passwordVisible, //This will obscure text dynamically
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,

                                      hintStyle: const TextStyle(
                                        color: Colors.white,
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
                            _actionLoading ? 'Loading..' : 'Let\'s gooo!',
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
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
