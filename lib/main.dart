import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth/pages/auth-page.dart';
import 'package:flutter_firebase_auth/pages/firestore-page.dart';

void main() => runApp(AuthApp());

class AuthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData _base = ThemeData.dark();
    InputDecorationTheme inputDecor = _base.inputDecorationTheme;
    return MaterialApp(
      title: 'Firebase Demo',
      debugShowCheckedModeBanner: false,
      theme: _base.copyWith(
        buttonTheme: _base.buttonTheme.copyWith(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(0),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: Builder(
        builder: (context) => Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Firebase Demo',
                      style: Theme.of(context).textTheme.display1.copyWith(
                            color: Colors.grey[50],
                          ),
                    ),
                    IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(
                            height: 100,
                          ),
                          RaisedButton(
                            elevation: 8.0,
                            child: Text('Auth'),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AuthPage(),
                                ),
                              );
                            },
                          ),
                          RaisedButton(
                            elevation: 8.0,
                            child: Text('Firestore'),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FireStorePage(),
                                ),
                              );
                            },
                          ),
                          RaisedButton(
                            elevation: 8.0,
                            child: Text('Realtime db'),
                          ),
                          RaisedButton(
                            elevation: 8.0,
                            child: Text('Storage'),
                          ),
                          RaisedButton(
                            elevation: 8.0,
                            child: Text('Analytics'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
