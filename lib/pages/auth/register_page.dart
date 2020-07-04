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


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final Storage _localStorage = html.window.localStorage;

  String username = "";
  String email = "";
  String password = "";
  String confirm = "";

  Widget registerWidget = new Container();

  _RegisterPageState() {
    registerWidget = new Container(
      width: double.infinity,
      child: new RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: new Text("CREATE ACCOUNT", style: TextStyle(fontSize: 20),),
        textColor: Colors.white,
        color: mainColor,
        onPressed: register
      ),
    );
  }

  Future<void> register() async {
    fb.auth().setPersistence("local");
    if (username == "" || email == "") {
      html.window.alert("Please make sure that all fields are filled out!");
    }
    else if (username.length > 16) {
      html.window.alert("Username must be less than 16 characters!");
    }
    else if (password != confirm) {
      html.window.alert("Passwords do not match!");
    }
    else {
      try {
        setState(() {
          registerWidget = new Container(
            child: new HeartbeatProgressIndicator(
              child: new Image.asset("images/bktv-logo.png", height: 20,),
            ),
          );
        });
        await fb.auth().createUserWithEmailAndPassword(email, password).then((value) {
          _localStorage["userID"] = value.user.uid;
          fb.database().ref("users").child(value.user.uid).set({
            "username": username,
            "email": email,
            "profileUrl": DEFAULT_PROFILE
          });
        });
        router.navigateTo(context, "/", replace: true, transition: TransitionType.fadeIn);
      } catch (error) {
        print(error);
        html.window.alert(error.message);
      }
    }
    setState(() {
      registerWidget = new Container(
        width: double.infinity,
        child: new RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: new Text("CREATE ACCOUNT", style: TextStyle(fontSize: 20),),
          textColor: Colors.white,
          color: mainColor,
          onPressed: register
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
                new Text("Register", style: TextStyle(fontSize: 40, fontFamily: "Sifonn", color: mainColor), textAlign: TextAlign.center,),
                new Padding(padding: EdgeInsets.all(16.0),),
                new Text("Create your BKTV account below!", textAlign: TextAlign.center, style: TextStyle(color: currTextColor, fontSize: 20),),
                new Theme(
                  data: new ThemeData(
                    fontFamily: "DIN Condensed",
                    primaryColor: mainColor,
                    hintColor: currDividerColor,
                  ),
                  child: new TextField(
                    decoration: InputDecoration(
                        icon: new Icon(Icons.person),
                        labelText: "Username",
                        hintText: "Enter your username"
                    ),
                    style: TextStyle(color: currTextColor, fontSize: 20),
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    onChanged: (value) {
                      setState(() {
                        username = value;
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
                new Theme(
                  data: new ThemeData(
                    fontFamily: "DIN Condensed",
                    primaryColor: mainColor,
                    hintColor: currDividerColor,
                  ),
                  child: new TextField(
                    decoration: InputDecoration(
                        icon: new Icon(Icons.lock),
                        labelText: "Confirm Password",
                        hintText: "Confirm your password"
                    ),
                    style: TextStyle(color: currTextColor, fontSize: 20),
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        confirm = value;
                      });
                    },
                  ),
                ),
                new Padding(padding: EdgeInsets.all(16.0)),
                registerWidget
              ],
            ),
          ),
        ),
      ),
    );
  }
}
