import 'dart:html';
import 'dart:html' as html;
import 'package:bk1031_tv/models/user.dart';
import 'package:bk1031_tv/models/video.dart';
import 'package:bk1031_tv/navbars/home_navbar.dart';
import 'package:bk1031_tv/utils/config.dart';
import 'package:bk1031_tv/utils/theme.dart';
import 'package:easy_web_view/easy_web_view.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MovieDetailsPage extends StatefulWidget {
  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {

  final Storage _localStorage = html.window.localStorage;

  Video video = new Video.plain();
  User currUser = User.plain();

  String src = 'https://tv.bk1031.dev';
  String src2 = 'https://flutter.dev';
  String src3 = 'http://www.youtube.com/embed/IyFZznAk69U';
  static ValueKey key = ValueKey('key_0');
  static ValueKey key2 = ValueKey('key_1');
  static ValueKey key3 = ValueKey('key_2');
  bool open = false;

@override
  void initState() {
    super.initState();
    if (html.window.location.toString().contains("?id=")) {
      fb.database().ref("videos").child(html.window.location.toString().split("?id=")[1]).once("value").then((value) {
        if (value.snapshot != null) {
          setState(() {
            video = new Video.fromSnapshot(value.snapshot);
            src = "https://tv.bk1031.dev/watch?id=${video.videoID}";
          });
        }
        else {
          router.navigateTo(context, "/movies", transition: TransitionType.fadeIn);
        }
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
                    new Padding(padding: EdgeInsets.all(16)),
                    new ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: new Container(
                        width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                        height: ((MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100) / 2,
                        color: Colors.black,
                        child: Stack(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: EasyWebView(
                                        src: src,
                                        onLoaded: () {
                                          print('$key: Loaded: $src');
                                        },
                                        key: key
                                      // width: 100,
                                      // height: 100,
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: EasyWebView(
                                      onLoaded: () {
                                        print('$key2: Loaded: $src2');
                                      },
                                      src: src2,
                                      key: key2
                                    // width: 100,
                                    // height: 100,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(8)),
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
