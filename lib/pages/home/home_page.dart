import 'dart:html';
import 'dart:html' as html;
import 'package:bk1031_tv/models/user.dart';
import 'package:bk1031_tv/models/video.dart';
import 'package:bk1031_tv/navbars/home_footer.dart';
import 'package:bk1031_tv/navbars/home_navbar.dart';
import 'package:bk1031_tv/utils/config.dart';
import 'package:bk1031_tv/utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Storage _localStorage = html.window.localStorage;
  User currUser = User.plain();

  List<Widget> newWidgetList = [];
  List<Widget> continueWidgetList = [];

  @override
  void initState() {
    super.initState();
    getNew();
    if (_localStorage.containsKey("userID")) {
      fb.database().ref("users").child(_localStorage["userID"]).once("value").then((value) {
        setState(() {
          currUser = User.fromSnapshot(value.snapshot);
          print(currUser);
        });
        getContinue();
      });
    }
  }

  void getNew() {
    fb.database().ref("new").onChildAdded.listen((event) {
      fb.database().ref("videos").child(event.snapshot.val()).once("value").then((value) {
        setState(() {
          Video video = new Video.fromSnapshot(value.snapshot);
          newWidgetList.add(new Card(
            color: currCardColor,
            elevation: 16,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            child: new Container(
              height: 225,
              width: 155,
              child: new InkWell(
                onTap: () {
                  if (video.type == "Movie") {
                    router.navigateTo(context, "/movies/details?id=${video.videoID}", transition: TransitionType.fadeIn);
                  }
                  else if (video.type == "TV-Show") {
                    router.navigateTo(context, "/shows/details?id=${video.videoID}", transition: TransitionType.fadeIn);
                  }
                },
                borderRadius: BorderRadius.circular(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: new CachedNetworkImage(
                    imageUrl: video.cover,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ));
        });
      });
    });
  }

  void getContinue() {
    fb.database().ref("users").child(currUser.userID).child("continue").onChildAdded.listen((event) {
      fb.database().ref("videos").child(event.snapshot.key.contains("-") ? event.snapshot.key.split("-")[0] : event.snapshot.key).once("value").then((value) {
        Video video = new Video.fromSnapshot(value.snapshot);
        setState(() {
          continueWidgetList.add(new Card(
            elevation: 16,
            color: currCardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            child: new InkWell(
              onTap: () {
                if (video.type == "Movie") {
                  router.navigateTo(context, "/movies/details?id=${event.snapshot.key}", transition: TransitionType.fadeIn);
                }
                else if (video.type == "TV-Show") {
                  router.navigateTo(context, "/shows/details?id=${event.snapshot.key}", transition: TransitionType.fadeIn);
                }
              },
              borderRadius: BorderRadius.circular(8.0),
              child: Stack(
                children: [
                  new Container(
                    height: 225,
                    width: 155,
                    child: new ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: new CachedNetworkImage(
                        imageUrl: video.cover,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  new Container(
                      height: 225,
                      width: 155,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          new Container(
                            height: 35,
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              new Container(color: Colors.white, height: 25, width: 25,),
                              new IconButton(icon: Icon(Icons.play_circle_fill_rounded), color: mainColor, iconSize: 50, onPressed: () {
                                if (video.type == "Movie") {
                                  router.navigateTo(context, "/movies/details?id=${event.snapshot.key}", transition: TransitionType.fadeIn);
                                }
                                else if (video.type == "TV-Show") {
                                  router.navigateTo(context, "/shows/details?id=${event.snapshot.key}", transition: TransitionType.fadeIn);
                                }
                              }),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                new ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: new LinearProgressIndicator(
                                    minHeight: 25,
                                    backgroundColor: Colors.blueAccent.withOpacity(0.4),
                                    value: int.parse(event.snapshot.val()["progress"].toString().split("/")[0]) / int.parse(event.snapshot.val()["progress"].toString().split("/")[1]),
                                  ),
                                ),
                                Container(
                                  height: 25,
                                  child: Center(
                                    child: new Text(
                                      event.snapshot.key.contains("-") ? event.snapshot.key.split("-")[1] : "",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                ],
              ),
            ),
          ));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 800) {
      return new Scaffold(
        backgroundColor: currBackgroundColor,
        floatingActionButton: Visibility(
          visible: currUser.email == "bharat1031@gmail.com",
          child: FloatingActionButton(
            child: Icon(Icons.admin_panel_settings, color: Colors.white,),
            onPressed: () {
              router.navigateTo(context, "/admin", transition: TransitionType.fadeIn);
            },
          ),
        ),
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
                                  "Open Source, No Ads, Always Free",
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
                    new Visibility(
                      visible: _localStorage.containsKey("userID"),
                      child: new Container(
                          padding: EdgeInsets.all(16),
                          width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                          child: new Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            direction: Axis.horizontal,
                            children: continueWidgetList,
                          )
                      ),
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
                    new Container(height: 200,),
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
