import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'package:bk1031_tv/utils/config.dart';
import 'package:bk1031_tv/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

import 'package:progress_indicators/progress_indicators.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final Storage _localStorage = html.window.localStorage;

  String email = "";
  String password = "";

  Widget loginWidget = new Container();

  _LoginPageState() {
    loginWidget = new Container(
      width: double.infinity,
      child: new RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: new Text("LOGIN", style: TextStyle(fontSize: 20),),
          textColor: Colors.white,
          color: mainColor,
          onPressed: login
      ),
    );
  }

  Future<void> login() async {
    if (email == "" || password == "") {

    }
    else {
      try {
        setState(() {
          loginWidget = new Container(
            child: new HeartbeatProgressIndicator(
              child: new Image.asset("images/bktv-logo.png", height: 20,),
            ),
          );
        });
        await fb.auth().signInWithEmailAndPassword(email, password).then((value) {
          _localStorage["userID"] = value.user.uid;
        });
        router.navigateTo(context, "/", replace: true, transition: TransitionType.fadeIn);
      } catch (error) {
        print(error);
        html.window.alert(error.message);
      }
    }
    setState(() {
      loginWidget = new Container(
        width: double.infinity,
        child: new RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            child: new Text("LOGIN", style: TextStyle(fontSize: 20),),
            textColor: Colors.white,
            color: mainColor,
            onPressed: login
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: currBackgroundColor,
      body: new Center(
        child: new Card(
          color: currCardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 6.0,
          child: new Container(
            padding: EdgeInsets.all(32.0),
            width: (MediaQuery.of(context).size.width > 500) ? 500.0 : MediaQuery.of(context).size.width - 25,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text("Login", style: TextStyle(fontSize: 40, fontFamily: "Sifonn", color: mainColor), textAlign: TextAlign.center,),
                new Padding(padding: EdgeInsets.all(16.0),),
                new Text("Login to your BKTV account below!", textAlign: TextAlign.center, style: TextStyle(color: currTextColor, fontSize: 20),),
                new Theme(
                  data: new ThemeData(
                    fontFamily: "DIN Condensed",
                    primaryColor: mainColor,
                    hintColor: currDividerColor,
                  ),
                  child: new TextField(
                    decoration: InputDecoration(
                        icon: new Icon(Icons.email),
                        labelText: "Email",
                        hintText: "Enter your email"
                    ),
                    style: TextStyle(color: currTextColor, fontSize: 20),
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                ),
                new Theme(
                  data: new ThemeData(
                    fontFamily: "DIN Condensed",
                    primaryColor: mainColor,
                    hintColor: currDividerColor,
                  ),
                  child: new TextField(
                    decoration: InputDecoration(
                        icon: new Icon(Icons.lock),
                        labelText: "Password",
                        hintText: "Enter your password"
                    ),
                    style: TextStyle(color: currTextColor, fontSize: 20),
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                ),
                new Padding(padding: EdgeInsets.all(16.0)),
                loginWidget,
                new Padding(padding: EdgeInsets.all(8.0)),
                new FlatButton(
                  child: new Text("Don't have an account?", style: TextStyle(fontSize: 17),),
                  textColor: mainColor,
                  onPressed: () {
                    router.navigateTo(context, "/register", transition: TransitionType.fadeIn);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
