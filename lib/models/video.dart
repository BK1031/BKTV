import 'package:bk1031_tv/models/comment.dart';
import 'package:bk1031_tv/models/episode.dart';
import 'package:firebase/firebase.dart';

class Video {
  String videoID = "";
  String name = "";
  String desc = "";
  String type = "";
  String year = "";
  String cover = "";
  List<Comment> comments = new List();
  List<Episode> episodes = new List();

  Video.plain();

  Video.fromSnapshot(DataSnapshot snapshot) {
    videoID = snapshot.key;
    name = snapshot.val()["name"];
    desc = snapshot.val()["desc"];
    type = snapshot.val()["type"];
    cover = snapshot.val()["cover"];
    if (type == "Movie") {
      year = snapshot.val()["year"].toString();
      if (snapshot.val()["comments"] != null) {
        // Comments exist, add em idiot
        Map<dynamic,dynamic> map = snapshot.val()["comments"];
        for (var key in map.keys) {
          comments.add(new Comment.fromSnapshot(snapshot.val()["comments"][key]));
        }
      }
    }
    else {
      if (snapshot.val()["episodes"] != null) {
        // Episodes exit, add em idiot
        Map<dynamic,dynamic> map = snapshot.val()["episodes"];
        for (var key in map.keys) {
          print(snapshot.val()["episodes"][key]);
          episodes.add(new Episode.fromMap(key, snapshot.val()["episodes"][key]));
        }
      }
    }
  }

}