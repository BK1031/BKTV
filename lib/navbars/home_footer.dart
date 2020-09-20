import 'package:bk1031_tv/utils/theme.dart';
import 'package:flutter/material.dart';

class HomeFooter extends StatefulWidget {
  @override
  _HomeFooterState createState() => _HomeFooterState();
}

class _HomeFooterState extends State<HomeFooter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: currCardColor,
      height: 100,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Column(
            children: [
              new FlatButton(
                child: new Text(""),
              )
            ],
          ),
          new Column(
            children: [
              new Text("hi")
            ],
          ),
          new Column(
            children: [
              new Text("hi")
            ],
          )
        ],
      ),
    );
  }
}
