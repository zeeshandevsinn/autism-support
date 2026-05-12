import 'package:autism_support/controller/services/base.dart';
import 'package:autism_support/controller/services/firebase_manager.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  bool isLoading = false;

  registerWithEmail(context, name, email, password) async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await FirebaseManager.RegisterWithEmailFirebase(
          context, email, password);
      if (data != null) {
        UserSession.updateUser(
            FirebaseAuth.instance.currentUser?.uid.toString());
        await FirebaseManager.saveParentDB(name: name, email: email);
        isLoading = false;
        notifyListeners();
        Navigator.pop(context);
        ToastUtil.showSuccessToast(AppText.successfullySignUpDone);
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ToastUtil.showErrorToast(AppText.herSomeThingWrongTryDifferentEmail);
      ToastUtil.showErrorToast("${AppText.internetIssue} $e");
    }
    isLoading = false;
    notifyListeners();
  }

  LoginWithEmail(context, email, password) async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await FirebaseManager.SignInWithEmailFirebase(context,
          email: email, password: password);
      if (data != null) {
        isLoading = false;
        notifyListeners();
        UserSession.updateUser(data.uid.toString());
        ToastUtil.showSuccessToast(AppText.successfullySignIn);
        return data;
      } else {
        isLoading = false;
        notifyListeners();
        ToastUtil.showErrorToast(AppText.wrongPassword);

        return null;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ToastUtil.showErrorToast(AppText.somethingWentWrongHere);
      ToastUtil.showErrorToast("${AppText.internetIssue} $e");
      return null;
    }
  }
}
