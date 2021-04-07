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

class TrendingPage extends StatefulWidget {
  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  final Storage _localStorage = html.window.localStorage;
  User currUser = User.plain();

  List<Widget> widgetList = new List();

  @override
  void initState() {
    super.initState();
    getTrending();
  }

  void getTrending() {
    fb.database().ref("trending").onChildAdded.listen((event) {
      fb.database().ref("videos").child(event.snapshot.val()).once("value").then((value) {
        setState(() {
          Video video = new Video.fromSnapshot(value.snapshot);
          widgetList.add(new Card(
            color: currCardColor,
            elevation: 16,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
              child: new Container(
                height: 225,
                width: 155,
                child: new CachedNetworkImage(
                  imageUrl: video.cover,
                  fit: BoxFit.cover,
                ),
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
        body: new Column(
          children: <Widget>[
            new HomeNavbar(),
            new Expanded(
              child: new SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    new Padding(padding: EdgeInsets.all(16),),
                    new Container(
                      padding: EdgeInsets.all(16),
                      width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                      child: new Text(
                        "Trending",
                        style: TextStyle(fontFamily: "Sifonn", fontSize: 35, color: mainColor),
                      ),
                    ),
                    new Container(
                        padding: EdgeInsets.all(16),
                        child: new Text("Coming soon...", style: TextStyle(color: currTextColor, fontSize: 20),)
                    ),
                    new Container(
                        padding: EdgeInsets.all(16),
                        width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                        child: new Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          direction: Axis.horizontal,
                          children: widgetList,
                        )
                    ),
                    new Container(height: MediaQuery.of(context).size.height / 2,),
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
