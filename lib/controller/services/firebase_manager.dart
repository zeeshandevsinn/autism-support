import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:autism_support/controller/services/base.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/exercise_data.dart';
import '../../utils/toast/toast.dart';

class FirebaseManager {
  static RegisterWithEmailFirebase(context, email, password) async {
    FocusScope.of(context).unfocus();

    try {
      // debugger();
      var data = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      ToastUtil.showSuccessToast(AppText.successsfullyRegistered);
      return data;
    } catch (e) {
      ToastUtil.showErrorToast(AppText.somethingWentWrong + "$e");
      // setState(() {
      //   isLoading = false;
      // });
      print(AppText.firebaseError + " $e");
      return null;
    }
  }

  static SignInWithEmailFirebase(context, {email, password}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (e) {
      ToastUtil.showErrorToast(AppText.unableToLogInCredentials);
      return null;
    }
  }

  static signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      print("User signed out");

      Navigator.pushNamedAndRemoveUntil(context, '/signin', (_) => false);
    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppText.errorSigningOut + ' $e')),
      );
    }
  }

  static saveParentDB({required name, required email}) async {
    try {
      await db.collection(ParentCollection).doc(UserSession.getUID()).set({
        "name": name,
        "email": email,
        "primaryColor": primaryColor.toString(),
        "secondayColor": secondaryColor.toString()
      });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static addChildDB({
    required name,
    required age,
    required File image,
  }) async {
    try {
      var fileImage = await getStringImage(image);
      await db.collection(childCollection).doc(UserSession.getUID()).set({
        "name": name,
        "age": age,
        "image": fileImage,
        "current_mood": {
          "name": "Happy",
          "emoji": "😊",
        }
      });

      // debugger();
      for (var index in excerciseData) {
        String type = index['type'];
        int obtained = 0;
        int total = index['data'].length;
        var cardImage = index['card_image'];

        print(type.runtimeType);
        await drillMarks(
            drillType: type,
            obtained: obtained,
            total: total,
            image: cardImage);
      }
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static getStringImage(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  static addFamilyMemberDB(
      {required name, required relation, required File image}) async {
    try {
      var fileImage = await getStringImage(image);
      await db
          .collection(ParentCollection)
          .doc(UserSession.getUID())
          .collection(familyCollection)
          .add({
        "name": name,
        "relation": relation,
        "image": fileImage,
      });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static deleteFamilyMember(String familyMemberID) async {
    try {
      await FirebaseFirestore.instance
          .collection(ParentCollection)
          .doc(UserSession.getUID())
          .collection(familyCollection)
          .doc(familyMemberID)
          .delete();
      print("Family member deleted");
    } catch (e) {
      print("Error deleting family member: $e");
    }
  }

  static drillMarks(
      {required drillType,
      required obtained,
      required total,
      required image}) async {
    try {
      // var fileImage = await getStringImage(image);
      final marks = db
          .collection(childCollection)
          .doc(UserSession.getUID())
          .collection('marks')
          .doc(drillType);

      await marks.set({'obtained': obtained, 'total': total, 'image': image});

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static udpateObtainedMarks({
    required drillType,
    required obtained,
  }) async {
    try {
      final marks = db
          .collection(childCollection)
          .doc(UserSession.getUID())
          .collection('marks')
          .doc(drillType);

      await marks.update({
        'obtained': obtained,
      });
      print('success!!!');

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static getObtainedMarks({required type}) async {
    try {
      var data = await db
          .collection(childCollection)
          .doc(UserSession.getUID())
          .collection('marks')
          .doc(type)
          .get();
      if (data.exists) {
        var obtained = data.data()?['obtained'];
        print('Obtained Marks: $obtained');
        return obtained;
      }
    } catch (e) {
      print('Error fetching obtained marks: $e');
    }
  }

  static setCurrentMood({required name, required emoji}) async {
    try {
      await db.collection(childCollection).doc(UserSession.getUID()).update({
        "current_mood": {
          "name": name,
          "emoji": emoji,
        }
      });
      print('Mood Successfully Updated!');
    } catch (e) {
      print('Error updating mood: $e');
    }
  }
}
