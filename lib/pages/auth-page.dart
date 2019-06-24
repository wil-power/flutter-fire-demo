//enum AuthType { logIn, signUp }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth/services/auth-service.dart';

class AuthPage extends StatefulWidget {
  final AuthService authService = AuthService();

  AuthPage({Key key}) : super(key: key);
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isSignIn = true;

  var _email;
  var _password;

  final _formKey = GlobalKey<FormState>();

  var _showPass = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Auth'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                      prefixIcon: Icon(Icons.mail),
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'email cannot be empty' : null,
                    onSaved: (value) => _email = value,
                    onEditingComplete: () {
                      if (_formKey.currentState.validate())
                        _formKey.currentState.save();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 1,
                    obscureText: !_showPass,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPass ? Icons.visibility_off : Icons.visibility,
//                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPass = !_showPass;
                          });
                        },
                      ),
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'provide password' : null,
                    onSaved: (value) => _password = value,
                    onEditingComplete: () {
                      if (_formKey.currentState.validate())
                        _formKey.currentState.save();
                    },
                  ),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text('Sign out'),
                      onPressed: () async {
                        await widget.authService.signOut();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Signed out'),
                        ));
                      },
                    ),
                    OutlineButton(
                      child: isSignIn ? Text('Sign Up') : Text('Log In'),
                      onPressed: () {
                        _formKey.currentState.reset();
                        setState(() {
                          isSignIn = !isSignIn;
                        });
                      },
                    ),
                    RaisedButton(
                      elevation: 8.0,
                      child: isSignIn ? Text('Log In') : Text('Sing up'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          if (isSignIn) {
                            // Todo sign in code
                            signIn(context);
                          } else {
                            // Todo sign up code
                            signUp(context);
                          }
                        } else {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('There are errors in your form'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void signIn(context) {
    widget.authService.signIn(_email, _password).then((value) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('signed in with id $value'),
        ),
      );
    });
  }

  void signUp(context) {
    widget.authService.signUp(_email, _password).then((value) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('signed up with id $value'),
        ),
      );
    });
  }
}
