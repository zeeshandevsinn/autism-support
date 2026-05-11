import 'package:cloud_firestore/cloud_firestore.dart';

var db = FirebaseFirestore.instance;

// final userID = FirebaseAuth.instance.currentUser?.uid;
class UserSession {
  // static final UserSession _instance = UserSession._internal();
  static String? userID;

  static void updateUser(String? id) {
    userID = id;
  }

  static getUID() {
    return userID;
  }
}

const ParentCollection = "parent";
const childCollection = "child";
const drill = "exercise";
const familyCollection = 'family_member';
