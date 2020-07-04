import 'dart:html';
import 'dart:html' as html;
import 'package:bk1031_tv/utils/config.dart';
import 'package:bk1031_tv/utils/theme.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

class HomeNavbar extends StatefulWidget {
  @override
  _HomeNavbarState createState() => _HomeNavbarState();
}

class _HomeNavbarState extends State<HomeNavbar> {

  final Storage _localStorage = html.window.localStorage;

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 75.0,
      color: currCardColor,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
//            height: 100,
              width: 300,
//            color: Colors.greenAccent,
              child: new Image.asset(
                "images/bktv-logo.png",
                fit: BoxFit.fitHeight,
              )
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new FlatButton(
                child: new Text("HOME", style: TextStyle(color: currTextColor, fontSize: 20)),
                onPressed: () {
                  router.navigateTo(context, '/', transition: TransitionType.fadeIn);
                },
              ),
              new FlatButton(
                child: new Text("TRENDING", style: TextStyle(color: currTextColor, fontSize: 20)),
                onPressed: () {
                  router.navigateTo(context, '/trending', transition: TransitionType.fadeIn);
                },
              ),
              new FlatButton(
                child: new Text("MOVIES", style: TextStyle(color: currTextColor, fontSize: 20)),
                onPressed: () {
                  router.navigateTo(context, '/movies', transition: TransitionType.fadeIn);
                },
              ),
              new FlatButton(
                child: new Text("TV-SHOWS", style: TextStyle(color: currTextColor, fontSize: 20)),
                onPressed: () {
                  router.navigateTo(context, '/shows', transition: TransitionType.fadeIn);
                },
              ),
              new Padding(padding: EdgeInsets.all(4.0),),
              new Visibility(
                visible: (!_localStorage.containsKey("userID")),
                child: new RaisedButton(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  child: new Text("LOGIN", style: TextStyle(color: currTextColor, fontSize: 20)),
                  textColor: currTextColor,
                  color: mainColor,
                  onPressed: () {
                    router.navigateTo(context, '/login', transition: TransitionType.materialFullScreenDialog);
                  },
                ),
              ),
              new Visibility(
                visible: (_localStorage.containsKey("userID")),
                child: new RaisedButton(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  child: new Text("SIGN OUT", style: TextStyle(fontSize: 20)),
                  textColor: Colors.white,
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      fb.auth().signOut();
                      _localStorage.remove("userID");
                      html.window.location.reload();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
