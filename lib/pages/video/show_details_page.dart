import 'package:bk1031_tv/models/episode.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:html';
import 'dart:html' as html;
import 'package:bk1031_tv/models/user.dart';
import 'package:bk1031_tv/models/video.dart';
import 'package:bk1031_tv/navbars/home_footer.dart';
import 'package:bk1031_tv/navbars/home_navbar.dart';
import 'package:bk1031_tv/utils/config.dart';
import 'package:bk1031_tv/utils/theme.dart';
import 'package:easy_web_view/easy_web_view.dart';
import 'package:fluro/fluro.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/rendering.dart';

class ShowDetailsPage extends StatefulWidget {
  @override
  _ShowDetailsPageState createState() => _ShowDetailsPageState();
}

class _ShowDetailsPageState extends State<ShowDetailsPage> {
  final Storage _localStorage = html.window.localStorage;

  Video video = new Video.plain();
  User currUser = User.plain();

  Episode episode = new Episode.plain();

  String src = 'https://tv.bk1031.dev';
  static ValueKey key = ValueKey('key_0');
  bool open = false;

  List<int> seasons = [];
  int selectedSeason = 1;
  List<Widget> episodeWidgetList = new List();

  @override
  void initState() {
    super.initState();
    if (_localStorage.containsKey("userID")) {
      fb.database().ref("users").child(_localStorage["userID"]).once("value").then((value) {
        setState(() {
          currUser = User.fromSnapshot(value.snapshot);
          print(currUser);
        });
      });
    }
    if (html.window.location.toString().contains("?id=")) {
      fb.database().ref("videos").child(html.window.location.toString().split("?id=")[1].contains("-") ? html.window.location.toString().split("?id=")[1].split("-")[0] : html.window.location.toString().split("?id=")[1]).once("value").then((value) {
        if (value.snapshot != null) {
          setState(() {
            video = new Video.fromSnapshot(value.snapshot);
            src = "https://tv.bk1031.dev/watch?id=${html.window.location.toString().split("?id=")[1]}";
          });
          if (html.window.location.toString().split("?id=")[1].contains("-")) {
            setState(() {
              selectedSeason = int.parse(html.window.location.toString().split("?id=")[1].split("-")[1].split("S")[1].split("E")[0]);
              episode = video.episodes[video.episodes.indexWhere((element) => element.episodeID == html.window.location.toString().split("?id=")[1].split("-")[1])];
            });
          }
          getSeasons();
        }
        else {
          router.navigateTo(context, "/shows", transition: TransitionType.fadeIn);
        }
      });
    }
    else {
      router.navigateTo(context, "/shows", transition: TransitionType.fadeIn);
    }
  }

  Future<void> getSeasons() async {
    print("Getting seasons");
    seasons.clear();
    for (int i = 0; i < video.episodes.length; i++) {
      if (!seasons.contains(int.parse(video.episodes[i].episodeID.split("S")[1].split("E")[0]))) {
        setState(() {
          seasons.add(int.parse(video.episodes[i].episodeID.split("S")[1].split("E")[0]));
        });
      }
    }
    getEpisodes();
  }

  Future<void> getEpisodes() async {
    print("Getting episodes");
    episodeWidgetList.clear();
    for (int i = 0; i < video.episodes.length; i++) {
      if (int.parse(video.episodes[i].episodeID.split("S")[1].split("E")[0]) == selectedSeason) {
        bool watched = false;
        String progress = "";
        print(video.episodes[i].episodeID);
        if (_localStorage.containsKey("userID")) {
          await fb.database().ref("users").child(currUser.userID).child("history").child("${video.videoID}-${video.episodes[i].episodeID}").once("value").then((value) {
            if (value.snapshot.val() != null) {
              if (value.snapshot.val()["watched"] != null) watched = value.snapshot.val()["watched"];
              if (value.snapshot.val()["progress"] != null) progress = value.snapshot.val()["progress"];
            }
            print(watched.toString() + "–" + progress);
          });
        }
        setState(() {
          episodeWidgetList.add(new Container(
            padding: EdgeInsets.only(bottom: 8),
            child: new Card(
              elevation: 16,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                      color: (episode.episodeID == video.episodes[i].episodeID)
                          ? mainColor
                          : Colors.transparent, width: 2)),
              color: currCardColor,
              child: InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: () {
                  router.navigateTo(context,
                      "/shows/details?id=${video.videoID}-${video.episodes[i]
                          .episodeID}", transition: TransitionType.fadeIn);
                },
                child: new Container(
                  padding: EdgeInsets.all(8),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(padding: EdgeInsets.only(
                          left: 16, top: 8, bottom: 8, right: 16),
                          child: new Text(
                            video.episodes[i].episodeID.split("E")[1],
                            style: TextStyle(
                                fontSize: 30, color: currBackgroundColor),)),
                      Container(
                        padding: EdgeInsets.only(top: 8),
                        width: (MediaQuery
                            .of(context)
                            .size
                            .width > 1200) ? 1000 - 363 : MediaQuery
                            .of(context)
                            .size
                            .width - 100 - 363,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            new Text(video.episodes[i].name, style: TextStyle(
                                fontSize: 25,
                                fontFamily: "Sifonn",
                                color: mainColor),),
                            new Padding(padding: EdgeInsets.all(4),),
                            new Text(video.episodes[i].desc, style: TextStyle(
                                fontSize: 20, color: currTextColor),),
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        padding: EdgeInsets.all(16),
                        child: watched != true ? progress != "" ? new ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: new LinearProgressIndicator(
                            minHeight: 25,
                            backgroundColor: Colors.blueAccent.withOpacity(0.4),
                            value: int.parse(progress.split("/")[0]) /
                                int.parse(progress.split("/")[1]),
                          ),
                        ) : new ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: new LinearProgressIndicator(
                            minHeight: 25,
                            backgroundColor: Colors.blueAccent.withOpacity(0.4),
                            value: 0,
                          ),
                        ) : new ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: new LinearProgressIndicator(
                            minHeight: 25,
                            backgroundColor: Colors.blueAccent.withOpacity(0.4),
                            value: 1,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ));
        });
      }
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(8)),
                    Container(
                      width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 16),
                            child: new Container(
                              height: 225,
                              width: 155,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: new CachedNetworkImage(
                                  imageUrl: video.cover,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(4)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              new Container(
                                padding: EdgeInsets.all(16),
                                child: new Text(
                                  video.name,
                                  style: TextStyle(fontFamily: "Sifonn", fontSize: 35, color: mainColor),
                                ),
                              ),
                              new Container(
                                padding: EdgeInsets.only(left: 12, right: 8),
                                child: Wrap(
                                  children: [
                                    new Card(
                                      color: mainColor,
                                      elevation: 16,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                      child: new Container(
                                        padding: EdgeInsets.only(left: 8, top: 4, bottom: 2, right: 8),
                                        child: new Text(video.type, style: TextStyle(fontSize: 20, color: Colors.white),),
                                      ),
                                    ),
                                    new Card(
                                      color: currBackgroundColor,
                                      elevation: 0,
                                      child: new Container(
                                        padding: EdgeInsets.only(left: 8, top: 4, bottom: 2, right: 8),
                                        child: new Text(html.window.location.toString().split("?id=")[1].contains("-") ? episode.episodeID : video.year, style: TextStyle(fontSize: 25, color: currDividerColor),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              new Container(
                                width: (MediaQuery.of(context).size.width > 1200) ? 1000 - 163 : MediaQuery.of(context).size.width - 100 - 163,
                                padding: EdgeInsets.all(16),
                                child: new Text(
                                  video.desc,
                                  style: TextStyle(fontSize: 20, color: currTextColor),
                                ),
                              ),
                              new Container(
                                width: (MediaQuery.of(context).size.width > 1200) ? 1000 - 163 : MediaQuery.of(context).size.width - 100 - 163,
                                height: 50,
                                child: Expanded(
                                  child: new ListView.builder(
                                    itemCount: seasons.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        padding: EdgeInsets.all(4),
                                        child: Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                          elevation: selectedSeason == seasons[index] ? 16 : 0,
                                          color: selectedSeason == seasons[index] ? mainColor : currBackgroundColor,
                                          child: new InkWell(
                                            borderRadius: BorderRadius.circular(8.0),
                                            onTap: () {
                                              setState(() {
                                                selectedSeason = seasons[index];
                                                getEpisodes();
                                              });
                                            },
                                            child: Container(padding: EdgeInsets.only(left: 12, top: 4, bottom: 4, right: 12), child: Text("Season ${seasons[index]}", style: TextStyle(fontSize: 30, color: selectedSeason == seasons[index] ? Colors.white : currDividerColor,),))
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ),
                              new Container(
                                width: (MediaQuery.of(context).size.width > 1200) ? 1000 - 163 : MediaQuery.of(context).size.width - 100 - 163,
                                padding: EdgeInsets.only(top: 8),
                                child: new Column(
                                  children: episodeWidgetList,
                                )
                              ),
                            ],
                          ),
                        ],
                      ),
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
