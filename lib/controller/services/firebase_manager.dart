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
      ToastUtil.showErrorToast("${AppText.somethingWentWrong}$e");
      print("${AppText.firebaseError} $e");
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
        SnackBar(content: Text('${AppText.errorSigningOut} $e')),
      );
    }
  }

  static saveParentDB({required name, required email}) async {
    try {
      await db.collection(ParentCollection).doc(UserSession.getUID()).set({
        "name": name,
        "email": email,
        "primaryColor": parentPrimaryColor.toString(),
        "secondayColor": parentSecondaryColor.toString()
      });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // FIXED: addChildDB - Now saves under Parent's collection
  static addChildDB({
    required name,
    required age,
    required File image,
  }) async {
    try {
      String? parentId = UserSession.getUID();
      
      if (parentId == null) {
        print("ERROR: Parent UID is null");
        return false;
      }
      
      print("Adding child for parent: $parentId");
      
      var fileImage = await getStringImage(image);
      
      // FIXED: Save child under Parent's collection
      await db
          .collection(ParentCollection)  // ParentCollection
          .doc(parentId)                 // Parent document
          .collection(childCollection)   // child sub-collection
          .add({                          // Add new child document
        "name": name,
        "age": age,
        "image": fileImage,
        "parentId": parentId,
        "createdAt": FieldValue.serverTimestamp(),
        "current_mood": {
          "name": "Happy",
          "emoji": "😊",
        }
      });
      
      print("Child added successfully!");

      // Add exercise data for this child
      for (var index in excerciseData) {
        String type = index['type'];
        int obtained = 0;
        int total = index['data'].length;
        var cardImage = index['card_image'];

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

  // FIXED: drillMarks - Now saves under Parent's child collection
  static drillMarks(
      {required drillType,
      required obtained,
      required total,
      required image}) async {
    try {
      String? parentId = UserSession.getUID();
      
      if (parentId == null) {
        print("ERROR: Parent UID is null");
        return false;
      }
      
      // First, get the child document ID
      var childQuery = await db
          .collection(ParentCollection)
          .doc(parentId)
          .collection(childCollection)
          .limit(1)
          .get();
      
      if (childQuery.docs.isEmpty) {
        print("No child found for parent");
        return false;
      }
      
      String childId = childQuery.docs.first.id;
      
      // Save marks under child's sub-collection
      final marks = db
          .collection(ParentCollection)
          .doc(parentId)
          .collection(childCollection)
          .doc(childId)
          .collection('marks')
          .doc(drillType);

      await marks.set({'obtained': obtained, 'total': total, 'image': image});

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // FIXED: udpateObtainedMarks
  static udpateObtainedMarks({
    required drillType,
    required obtained,
  }) async {
    try {
      String? parentId = UserSession.getUID();
      
      if (parentId == null) {
        print("ERROR: Parent UID is null");
        return false;
      }
      
      // First, get the child document ID
      var childQuery = await db
          .collection(ParentCollection)
          .doc(parentId)
          .collection(childCollection)
          .limit(1)
          .get();
      
      if (childQuery.docs.isEmpty) {
        print("No child found for parent");
        return false;
      }
      
      String childId = childQuery.docs.first.id;
      
      final marks = db
          .collection(ParentCollection)
          .doc(parentId)
          .collection(childCollection)
          .doc(childId)
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

  // FIXED: getObtainedMarks
  static getObtainedMarks({required type}) async {
    try {
      String? parentId = UserSession.getUID();
      
      if (parentId == null) {
        print("ERROR: Parent UID is null");
        return null;
      }
      
      // First, get the child document ID
      var childQuery = await db
          .collection(ParentCollection)
          .doc(parentId)
          .collection(childCollection)
          .limit(1)
          .get();
      
      if (childQuery.docs.isEmpty) {
        print("No child found for parent");
        return null;
      }
      
      String childId = childQuery.docs.first.id;
      
      var data = await db
          .collection(ParentCollection)
          .doc(parentId)
          .collection(childCollection)
          .doc(childId)
          .collection('marks')
          .doc(type)
          .get();
          
      if (data.exists) {
        var obtained = data.data()?['obtained'];
        print('Obtained Marks: $obtained');
        return obtained;
      }
      return null;
    } catch (e) {
      print('Error fetching obtained marks: $e');
      return null;
    }
  }

  static setCurrentMood({required name, required emoji}) async {
    try {
      String? parentId = UserSession.getUID();
      
      if (parentId == null) {
        print("ERROR: Parent UID is null");
        return;
      }
      
      // First, get the child document ID
      var childQuery = await db
          .collection(ParentCollection)
          .doc(parentId)
          .collection(childCollection)
          .limit(1)
          .get();
      
      if (childQuery.docs.isEmpty) {
        print("No child found for parent");
        return;
      }
      
      String childId = childQuery.docs.first.id;
      
      await db
          .collection(ParentCollection)
          .doc(parentId)
          .collection(childCollection)
          .doc(childId)
          .update({
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