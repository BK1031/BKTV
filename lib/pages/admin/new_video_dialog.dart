import 'dart:html';
import 'dart:html' as html;
import 'package:bk1031_tv/models/episode.dart';
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
import 'package:flutter/services.dart';

class NewVideoDialog extends StatefulWidget {
  @override
  _NewVideoDialogState createState() => _NewVideoDialogState();
}

class _NewVideoDialogState extends State<NewVideoDialog> {

  String type = "Movie";

  Video video = Video.plain();
  Episode episode = Episode.plain();
  String seasonNum = "";
  String episodeNum = "";

  bool newShow = true;
  List<Video> showList = [];
  bool showSelection = false;

  final Storage _localStorage = html.window.localStorage;
  User currUser = User.plain();

  @override
  void initState() {
    super.initState();
    if (_localStorage.containsKey("userID")) {
      fb.database().ref("users").child(_localStorage["userID"]).once("value").then((value) {
        setState(() {
          currUser = User.fromSnapshot(value.snapshot);
          print(currUser);
        });
        if (currUser.email != "bharat1031@gmail.com") {
          router.navigateTo(context, "/", transition: TransitionType.fadeIn, replace: true);
        }
        setState(() {
          video.videoID = fb.database().ref("videos").push().key.toString().replaceAll("-", "").replaceAll("_", "");
        });
      });
    }
    else {
      router.navigateTo(context, "/", transition: TransitionType.fadeIn, replace: true);
    }
  }

  void getShows() {
    showList.clear();
    fb.database().ref("videos").onChildAdded.listen((event) {
      Video video = new Video.fromSnapshot(event.snapshot);
      if (video.type == "TV-Show") {
        setState(() {
          showList.add(video);
          showList.sort((a, b) => a.name.compareTo(b.name));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width * 2/3,
              height: 75,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: new FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      child: new Text("MOVIE", style: TextStyle(color: type == "Movie" ? Colors.white : currTextColor)),
                      color: type == "Movie" ? mainColor : null,
                      onPressed: () {
                        setState(() {
                          video.videoID = fb.database().ref("videos").push().key.toString().replaceAll("-", "").replaceAll("_", "");
                          type = "Movie";
                        });
                      },
                    ),
                  ),
                  new Padding(padding: EdgeInsets.all(8)),
                  Expanded(
                    child: new FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      child: new Text("TV-SHOW", style: TextStyle(color: type == "Show" ? Colors.white : currTextColor)),
                      color: type == "Show" ? mainColor : null,
                      onPressed: () {
                        getShows();
                        setState(() {
                          video.videoID = fb.database().ref("videos").push().key.toString().replaceAll("-", "").replaceAll("_", "");
                          type = "Show";
                        });
                      },
                    ),
                  ),
                ],
              )
          ),
          Container(
            width: MediaQuery.of(context).size.width * 2/3,
            padding: EdgeInsets.all(8),
            child: type == "Movie" ? new Container(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 16),
                        child: Column(
                          children: [
                            new Container(
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
                            Padding(padding: EdgeInsets.all(8)),
                            Row(
                              children: [
                                new SelectableText(
                                  "ID: ${video.videoID}"
                                ),
                                new IconButton(icon: Icon(Icons.content_copy), onPressed: () => Clipboard.setData(new ClipboardData(text: video.videoID)))
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(16)),
                      Container(
                        width: MediaQuery.of(context).size.width * 2/3 - 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            new Container(
                              padding: EdgeInsets.all(8),
                              child: new TextField(
                                decoration: InputDecoration(
                                    labelText: "Name",
                                    hintText: "Enter movie name"
                                ),
                                textCapitalization: TextCapitalization.words,
                                onChanged: (input) {
                                  video.name = input;
                                },
                                style: TextStyle(fontSize: 20, color: currTextColor),
                              ),
                            ),
                            new Container(
                              padding: EdgeInsets.all(8),
                              child: new TextField(
                                decoration: InputDecoration(
                                    labelText: "Year",
                                    hintText: "Enter movie release year"
                                ),
                                onChanged: (input) {
                                  video.year = input;
                                },
                                style: TextStyle(fontSize: 20, color: currTextColor),
                              ),
                            ),
                            new Container(
                              padding: EdgeInsets.all(8),
                              child: new TextField(
                                decoration: InputDecoration(
                                    labelText: "Cover",
                                    hintText: "Enter movie cover art url"
                                ),
                                onChanged: (input) {
                                  setState(() {
                                    video.cover = input;
                                  });
                                },
                                style: TextStyle(fontSize: 20, color: currTextColor),
                              ),
                            ),
                            new Container(
                              padding: EdgeInsets.all(8),
                              child: new TextField(
                                decoration: InputDecoration(
                                    labelText: "Description",
                                    hintText: "Enter movie description"
                                ),
                                maxLines: null,
                                onChanged: (input) {
                                  video.desc = input;
                                },
                                style: TextStyle(fontSize: 20, color: currTextColor),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(4)),
                            new FlatButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                              child: new Text("ADD MOVIE", style: TextStyle(color: Colors.white)),
                              color: mainColor,
                              onPressed: () {
                                if (video.name != "" && video.desc != "" && video.year != "" && video.cover != "") {
                                  fb.database().ref("videos").child(video.videoID).set({
                                    "cover": video.cover,
                                    "desc": video.desc,
                                    "name": video.name,
                                    "type": "Movie",
                                    "year": int.parse(video.year)
                                  });
                                  fb.database().ref("new").push().set(video.videoID);
                                  router.pop(context);
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ) : new Container(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 16),
                        child: Column(
                          children: [
                            new Container(
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
                            Padding(padding: EdgeInsets.all(8)),
                            Row(
                              children: [
                                new SelectableText(
                                    "ID: ${video.videoID}${!newShow ? "-S${seasonNum}E${episodeNum}" : ""}"
                                ),
                                new IconButton(icon: Icon(Icons.content_copy), onPressed: () => Clipboard.setData(new ClipboardData(text: "${video.videoID}${!newShow ? "-S${seasonNum}E${episodeNum}" : ""}")))
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(16)),
                      Container(
                        width: newShow ? MediaQuery.of(context).size.width * 2/3 - 250 : 0,
                        child: Visibility(
                          visible: newShow,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              new Container(
                                padding: EdgeInsets.all(8),
                                child: new TextField(
                                  decoration: InputDecoration(
                                      labelText: "Name",
                                      hintText: "Enter movie name"
                                  ),
                                  textCapitalization: TextCapitalization.words,
                                  onChanged: (input) {
                                    video.name = input;
                                  },
                                  style: TextStyle(fontSize: 20, color: currTextColor),
                                ),
                              ),
                              new Container(
                                padding: EdgeInsets.all(8),
                                child: new TextField(
                                  decoration: InputDecoration(
                                      labelText: "Cover",
                                      hintText: "Enter movie cover art url"
                                  ),
                                  onChanged: (input) {
                                    setState(() {
                                      video.cover = input;
                                    });
                                  },
                                  style: TextStyle(fontSize: 20, color: currTextColor),
                                ),
                              ),
                              new Container(
                                padding: EdgeInsets.all(8),
                                child: new TextField(
                                  decoration: InputDecoration(
                                      labelText: "Description",
                                      hintText: "Enter movie description"
                                  ),
                                  maxLines: null,
                                  onChanged: (input) {
                                    video.desc = input;
                                  },
                                  style: TextStyle(fontSize: 20, color: currTextColor),
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(4)),
                              Row(
                                children: [
                                  new FlatButton(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    child: new Text("ADD SHOW", style: TextStyle(color: Colors.white)),
                                    color: mainColor,
                                    onPressed: () {
                                      if (video.name != "" && video.desc != "" && video.cover != "") {
                                        fb.database().ref("videos").child(video.videoID).set({
                                          "cover": video.cover,
                                          "desc": video.desc,
                                          "name": video.name,
                                          "type": "TV-Show",
                                        });
                                        fb.database().ref("new").push().set(video.videoID);
                                        router.pop(context);
                                      }
                                    },
                                  ),
                                  new FlatButton(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    child: new Text("ADD EPISODE", style: TextStyle(color: mainColor)),
                                    onPressed: () {
                                      setState(() {
                                        video = Video.plain();
                                        episode = Episode.plain();
                                        newShow = false;
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: !newShow ? MediaQuery.of(context).size.width * 2/3 - 250 : 0,
                        child: Visibility(
                          visible: !newShow,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: ListTile(
                                  title: Text(video.name != "" ? video.name : "Select a show", style: TextStyle(fontFamily: "Sifonn", fontSize: 25, color: mainColor),),
                                  onTap: () {
                                    setState(() {
                                      showSelection = !showSelection;
                                    });
                                  },
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 100),
                                height: showSelection ? 300 : 0,
                                child: new ListView(
                                  children: showList.map((e) => ListTile(
                                    title: Text(e.name, style: TextStyle(fontFamily: "Sifonn", fontSize: 20),),
                                    onTap: () {
                                      setState(() {
                                        this.video = e;
                                        showSelection = false;
                                      });
                                    },
                                  )).toList()
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: new Container(
                                      padding: EdgeInsets.all(8),
                                      child: new TextField(
                                        decoration: InputDecoration(
                                            labelText: "Season",
                                            hintText: "Enter episode season"
                                        ),
                                        textCapitalization: TextCapitalization.words,
                                        onChanged: (input) {
                                          setState(() {
                                            seasonNum = input;
                                          });
                                        },
                                        style: TextStyle(fontSize: 20, color: currTextColor),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: new Container(
                                      padding: EdgeInsets.all(8),
                                      child: new TextField(
                                        decoration: InputDecoration(
                                            labelText: "Episode",
                                            hintText: "Enter episode number"
                                        ),
                                        textCapitalization: TextCapitalization.words,
                                        onChanged: (input) {
                                          setState(() {
                                            episodeNum = input;
                                          });
                                        },
                                        style: TextStyle(fontSize: 20, color: currTextColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              new Container(
                                padding: EdgeInsets.all(8),
                                child: new TextField(
                                  decoration: InputDecoration(
                                      labelText: "Name",
                                      hintText: "Enter episode name"
                                  ),
                                  textCapitalization: TextCapitalization.words,
                                  onChanged: (input) {
                                    episode.name = input;
                                  },
                                  style: TextStyle(fontSize: 20, color: currTextColor),
                                ),
                              ),
                              new Container(
                                padding: EdgeInsets.all(8),
                                child: new TextField(
                                  decoration: InputDecoration(
                                      labelText: "Description",
                                      hintText: "Enter movie description"
                                  ),
                                  maxLines: null,
                                  onChanged: (input) {
                                    episode.desc = input;
                                  },
                                  style: TextStyle(fontSize: 20, color: currTextColor),
                                ),
                              ),
                              new Container(
                                padding: EdgeInsets.all(8),
                                child: new TextField(
                                  decoration: InputDecoration(
                                      labelText: "Year",
                                      hintText: "Enter movie release year"
                                  ),
                                  onChanged: (input) {
                                    episode.year = input;
                                  },
                                  style: TextStyle(fontSize: 20, color: currTextColor),
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(4)),
                              Row(
                                children: [
                                  new FlatButton(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    child: new Text("ADD EPISODE", style: TextStyle(color: Colors.white)),
                                    color: mainColor,
                                    onPressed: () {
                                      if (episode.name != "" && episode.desc != "" && episode.year != "" && video.videoID != "") {
                                        fb.database().ref("videos").child(video.videoID).child("episodes").child("S${seasonNum}E${episodeNum}").set({
                                          "year": int.parse(episode.year),
                                          "desc": episode.desc,
                                          "name": episode.name,
                                        });
                                        router.pop(context);
                                      }
                                    },
                                  ),
                                  new FlatButton(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    child: new Text("ADD SHOW", style: TextStyle(color: mainColor)),
                                    onPressed: () {
                                      setState(() {
                                        video = Video.plain();
                                        video.videoID = fb.database().ref("videos").push().key.toString().replaceAll("-", "").replaceAll("_", "");
                                        episode = Episode.plain();
                                        newShow = true;
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}
