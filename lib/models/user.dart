import 'package:firebase/firebase.dart';

class User {
  String userID = "";
  String username = "";
  String email = "";
  String profileUrl = "";

  User();

  User.fromSnapshot(DataSnapshot snapshot) {
    userID = snapshot.key;
    username = snapshot.val()["username"];
    email = snapshot.val()["email"];
    profileUrl = snapshot.val()["profileUrl"];
  }

  @override
  String toString() {
    return "$username <$email>";
  }

}