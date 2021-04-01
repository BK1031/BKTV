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

class NewVideoPage extends StatefulWidget {
  @override
  _NewVideoPageState createState() => _NewVideoPageState();
}

class _NewVideoPageState extends State<NewVideoPage> {

  bool authorized;

  final Storage _localStorage = html.window.localStorage;
  User currUser = User.plain();

  List<Widget> newWidgetList = [];
  List<Widget> continueWidgetList = [];

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
      });
    }
    else {
      router.navigateTo(context, "/", transition: TransitionType.fadeIn, replace: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (currUser.email != "bharat1031@gmail.com") ? new Scaffold(
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
                                "ERROR",
                                style: TextStyle(fontSize: 60, fontFamily: "Sifonn", color: mainColor),
                              ),
                              new Padding(padding: EdgeInsets.all(4)),
                              new Text(
                                "You are not authorized to access this page!",
                                style: TextStyle(fontSize: 20, color: currTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
    ) : new Scaffold(
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
                    width: (MediaQuery.of(context).size.width > 1200) ? 1000 : MediaQuery.of(context).size.width - 100,
                    child: new Card(
                      elevation: 16,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      color: currCardColor,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8.0),
                        onTap: () {

                        },
                        child: new Container(
                          padding: EdgeInsets.all(8),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(padding: EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
                                  child: new Icon(Icons.add_circle, color: mainColor,)
                              ),
                              Container(
                                  padding: EdgeInsets.only(top: 4,),
                                  child: new Text("New Video", style: TextStyle(fontSize: 20, color: currTextColor),)
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
}
