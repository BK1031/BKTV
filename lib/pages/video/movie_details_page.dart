import 'dart:html';
import 'dart:html' as html;
import 'package:bk1031_tv/models/user.dart';
import 'package:bk1031_tv/models/video.dart';
import 'package:bk1031_tv/navbars/home_navbar.dart';
import 'package:bk1031_tv/utils/config.dart';
import 'package:bk1031_tv/utils/theme.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

class MovieDetailsPage extends StatefulWidget {
  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {

  final Storage _localStorage = html.window.localStorage;

  Video video = new Video.plain();
  User currUser = User.plain();

  @override
  void initState() {
    super.initState();
    if (html.window.location.toString().contains("?id=")) {
      fb.database().ref("videos").child(html.window.location.toString().split("?id=")[1]).once("value").then((value) {
        setState(() {
          video = new Video.fromSnapshot(value.snapshot);
        });
      });
    }
    else {
      router.navigateTo(context, "/movies", transition: TransitionType.fadeIn);
    }
    if (_localStorage.containsKey("userID")) {
      fb.database().ref("users").child(_localStorage["userID"]).once("value").then((value) {
        setState(() {
          currUser = User.fromSnapshot(value.snapshot);
          print(currUser);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 800) {
      return new Scaffold(
        backgroundColor: currBackgroundColor,
        body: new Column(
          children: <Widget>[
            new HomeNavbar(),
            new Expanded(
              child: new SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(16),
                      width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                      child: Center(
                        child: new Card(
                          color: currCardColor,
                          elevation: 16,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          child: Container(
                            width: 600,
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                new Padding(padding: EdgeInsets.all(4)),
                                new Text(
                                  "BKTV",
                                  style: TextStyle(fontSize: 60, fontFamily: "Sifonn", color: mainColor),
                                ),
                                new Padding(padding: EdgeInsets.all(4)),
                                new Text(
                                  "Open Source, No Ads, Always Free ",
                                  style: TextStyle(fontSize: 20, color: currTextColor),
                                ),
                                new Padding(padding: EdgeInsets.all(8)),
                                new Theme(
                                  data: new ThemeData(
                                    fontFamily: "DIN Condensed",
                                    primaryColor: mainColor,
                                    hintColor: currDividerColor,
                                  ),
                                  child: new TextField(
                                    decoration: InputDecoration(
                                        labelText: "Search",
                                        hintText: "Search for a movie or show",
                                        border: OutlineInputBorder()
                                    ),
                                    style: TextStyle(color: currTextColor, fontSize: 20),
                                    autocorrect: false,
                                    onChanged: (value) {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.all(16),
                      width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                      child: new Text(
                        video.name,
                        style: TextStyle(fontFamily: "Sifonn", fontSize: 35, color: mainColor),
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                      child: Wrap(
                        children: [
                          new Card(
                            color: mainColor,
                            elevation: 16,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            child: new Container(
                              padding: EdgeInsets.only(left: 8, top: 4, bottom: 2, right: 8),
                              child: new Text(video.type, style: TextStyle(fontSize: 25, color: Colors.white),),
                            ),
                          ),
                          new Card(
                            color: currBackgroundColor,
                            elevation: 0,
                            child: new Container(
                              padding: EdgeInsets.only(left: 8, top: 4, bottom: 2, right: 8),
                              child: new Text(video.year, style: TextStyle(fontSize: 30, color: currDividerColor),),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.all(16),
                      width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                      child: new Text(
                        video.desc,
                        style: TextStyle(fontSize: 20, color: currTextColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    else {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Home", style: TextStyle(fontWeight: FontWeight.bold),),
          elevation: 0.0,
          backgroundColor: mainColor,
        ),
        backgroundColor: currBackgroundColor,
        body: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
            ],
          ),
        ),
      );
    }
  }
}
