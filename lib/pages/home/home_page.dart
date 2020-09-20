import 'dart:html';
import 'dart:html' as html;
import 'package:bk1031_tv/models/user.dart';
import 'package:bk1031_tv/models/video.dart';
import 'package:bk1031_tv/navbars/home_footer.dart';
import 'package:bk1031_tv/navbars/home_navbar.dart';
import 'package:bk1031_tv/utils/config.dart';
import 'package:bk1031_tv/utils/theme.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Storage _localStorage = html.window.localStorage;
  List<Video> videoList = new List();
  User currUser = User.plain();

  List<Widget> newWidgetList = new List();

  @override
  void initState() {
    super.initState();
    fb.database().ref("new").onChildAdded.listen((event) {
      fb.database().ref("videos").child(event.snapshot.val()).once("value").then((value) {
        setState(() {
          Video video = new Video.fromSnapshot(value.snapshot);
          videoList.add(video);
          newWidgetList.add(new InkWell(
            onTap: () {
              if (video.type == "Movie") {
                router.navigateTo(context, "/movies/details?id=${video.videoID}", transition: TransitionType.fadeIn);
              }
              else if (video.type == "TV-Show") {
                router.navigateTo(context, "/shows/details?id=${video.videoID}", transition: TransitionType.fadeIn);
              }
            },
            borderRadius: BorderRadius.circular(8.0),
            child: new Card(
              elevation: 16,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              child: new Container(
                height: 225,
                width: 155,
                child: new Image.network(
                  video.cover,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ));
        });
      });
    });
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
                    new Visibility(
                      visible: _localStorage.containsKey("userID"),
                      child: new Container(
                        padding: EdgeInsets.all(16),
                        width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                        child: new Text(
                          "Continue Watching For ${currUser.username}",
                          style: TextStyle(fontFamily: "Sifonn", fontSize: 35, color: mainColor),
                        ),
                      )
                    ),
                    new Container(
                      padding: EdgeInsets.all(16),
                      width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                      child: new Text(
                        "Recently Added",
                        style: TextStyle(fontFamily: "Sifonn", fontSize: 35, color: mainColor),
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.all(16),
                      width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                      child: new Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        direction: Axis.horizontal,
                        children: newWidgetList,
                      )
                    ),
                    new HomeFooter()
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
