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
      padding: EdgeInsets.all(16),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Column(
            children: [
              new FlatButton(
                child: new Text(""),
                onPressed: () {

                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
