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

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {

  final Storage _localStorage = html.window.localStorage;
  User currUser = User.plain();

  List<Widget> widgetList = new List();

  @override
  void initState() {
    super.initState();
    getMovies();
  }

  void getMovies() {
    fb.database().ref("videos").onChildAdded.listen((event) {
      setState(() {
        Video video = new Video.fromSnapshot(event.snapshot);
        if (video.type == "Movie") {
          widgetList.add(new Card(
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
        }
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
                        "Movies",
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
                          children: widgetList,
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
