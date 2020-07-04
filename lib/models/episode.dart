import 'package:bk1031_tv/models/comment.dart';
import 'package:firebase/firebase.dart';

class Episode {
  String episodeID = "";
  String desc = "";
  String year = "";
  List<Comment> comments = new List();

  Episode.plain();

  Episode.fromSnapshot(DataSnapshot snapshot) {
    episodeID = snapshot.key;
    desc = snapshot.val()["desc"];
    year = snapshot.val()["year"].toString();
    Map<dynamic,dynamic> map = snapshot.val()["comments"];
  }

  Episode.fromMap(String key, Map<dynamic, dynamic> map) {
    episodeID = key;
    desc = map["desc"];
    year = map["year"].toString();
  }

}