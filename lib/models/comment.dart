import 'package:bk1031_tv/models/user.dart';
import 'package:firebase/firebase.dart' as fb;

class Comment {
  String commentID = "";
  User user = User();
  String body = "";
  String date = "";
  String timestamp = "";

  Comment.plain();

  Comment.fromSnapshot(fb.DataSnapshot snapshot) {
    commentID = snapshot.key;
    user.userID = snapshot.val()["userID"];
    body = snapshot.val()["body"];
    date = snapshot.val()["date"];
    timestamp = snapshot.val()["timestamp"];
  }
}