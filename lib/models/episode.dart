import 'package:bk1031_tv/models/comment.dart';
import 'package:firebase/firebase.dart';

class Episode {
  String episodeID = "";
  String name = "";
  String desc = "";
  String year = "";
  List<Comment> comments = new List();

  Episode();

  Episode.fromSnapshot(DataSnapshot snapshot) {
    episodeID = snapshot.key;
    name = snapshot.val()["name"];
    desc = snapshot.val()["desc"];
    year = snapshot.val()["year"].toString();
    Map<dynamic,dynamic> map = snapshot.val()["comments"];
  }

  Episode.fromMap(String key, Map<dynamic, dynamic> map) {
    episodeID = key;
    name = map["name"];
    desc = map["desc"];
    year = map["year"].toString();
  }

}