import 'package:firebase/firebase.dart';

class Comment {
  String commentID = "";
  String username = "";
  String body = "";
  String date = "";
  String timestamp = "";

  Comment.plain();

  Comment.fromSnapshot(DataSnapshot snapshot) {
    commentID = snapshot.key;
    username = snapshot.val()["username"];
    body = snapshot.val()["body"];
    date = snapshot.val()["date"];
    timestamp = snapshot.val()["timestamp"];
  }
}