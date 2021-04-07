import 'package:bk1031_tv/utils/config.dart';
import 'package:bk1031_tv/utils/theme.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeFooter extends StatefulWidget {
  @override
  _HomeFooterState createState() => _HomeFooterState();
}

class _HomeFooterState extends State<HomeFooter> {

  void dmcaAlert() {
    showDialog(context: context, builder: (context) => AlertDialog(
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      backgroundColor: currCardColor,
      title: new Text(
        "DMCA NOTICE",
        style: TextStyle(fontSize: 35, fontFamily: "Sifonn", color: mainColor),
      ),
      content: Container(
        child: Text("""BKTV respects the intellectual property rights of all content creators, whether their work is affiliated with our site or not.

If you have reason to suspect that your intellectual property rights have been infringed in any way that connects to our site, we recommend that you contact us using the contact form. We take all violations of the Digital Millennium Copyright Act of 1998 extremely seriously. In order to ensure your complaint remains legitimate under the DCMA, please ensure your copyright complaint contains all of the following information:

1. A signature, electronic or physical, of an individual who has been authorized to represent you, the copyright holder;
2. Clear identification of the copyrighted item(s) in question, as well as identification of the work(s) infringing on the copyright holder’s intellectual property rights;
3. Contact information for you, the copyright holder, that BKTV can use to contact you, including your full name, telephone number, physical address and e-mail address;
4. A written letter stating that you, the copyright holder, “in good faith believes that the use of the material in the manner complained of is not authorized by the copyright owner, its agent or the law”;
5. A written letter stating that all of the information provided in the statement above is wholly accurate, and reaffirming that the writer of said letter has been legally authorized, under penalty of perjury, to represent you, the copyright holder.

Do not take anything outlined in this document as formal legal advice. For further information on the details required to lodge a formal DMCA notification, please refer to 17 U.S.C. 512(c)(3).

If you want to report DMCA abuse, please contact us at bharat1031@gmail.com""", style: TextStyle(color: currTextColor, fontSize: 20)),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: currCardColor,
      height: 100,
      padding: EdgeInsets.all(16),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          new Container(
              height: 100,
              child: new Image.asset(
                "images/bktv-logo.png",
                fit: BoxFit.fitHeight,
              )
          ),
          new Row(
            children: [
              new FlatButton(
                child: new Text("v${appVersion.toString()}", style: TextStyle(color: currTextColor, fontSize: 20)),
                onPressed: () {
                },
              ),
              new FlatButton(
                child: new Text("ABOUT", style: TextStyle(color: currTextColor, fontSize: 20),),
                onPressed: () {
                  router.navigateTo(context, "/about", transition: TransitionType.fadeIn);
                },
              ),
              new FlatButton(
                child: new Text("DMCA", style: TextStyle(color: currTextColor, fontSize: 20),),
                onPressed: () {
                  dmcaAlert();
                },
              ),
              new FlatButton(
                child: new Text("STATUS", style: TextStyle(color: currTextColor, fontSize: 20),),
                onPressed: () {
                  launch("https://status.bk1031.dev");
                },
              ),
              new FlatButton(
                child: new Text("COPYRIGHT © 2021 BHARAT KATHI", style: TextStyle(color: currTextColor, fontSize: 20),),
                onPressed: () {
                  launch("https://github.com/BK1031/BKTV-web");
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
