import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:autism_support/utils/toast/toast.dart';
import 'package:autism_support/view/parent/forget_password_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  var passwordController = TextEditingController();

  var confirmPassworController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Scaffold(
       backgroundColor: parentBgColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgetPasswordScreen()));
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      size: 30,
                    )),
                SizedBox(
                  width: s.width * 0.2,
                ),
                Text(
                    tr(AppText.resetPassword)
                    // "Reset password"
                    ,
                    style:
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: s.height * 0.06,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                  tr(AppText.newPassword)
                  // "New Password"
                  ,
                  style: const TextStyle(
                      color: Color(0xff491b6d),
                      fontSize: 17,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600)),
            ),
            SizedBox(
              height: s.height * 0.02,
            ),
            TextField(
              obscureText: true,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto"),
              controller: passwordController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.visibility_off_outlined)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xff491b6d), width: 2),
                      borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(8)),
                  hintText: tr(AppText.enterPassword)
                  // "Enter Password"
                  ,
                  hintStyle: const TextStyle(
                      color: Color(0xff4B4B4B), fontWeight: FontWeight.w400)),
            ),
            SizedBox(
              height: s.height * 0.05,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                  tr(AppText.confirmNewPassword)
                  // "Confirm New Password"
                  ,
                  style: const TextStyle(
                      color: Color(0xff491b6d),
                      fontSize: 17,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600)),
            ),
            SizedBox(
              height: s.height * 0.02,
            ),
            TextField(
              obscureText: true,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto"),
              controller: confirmPassworController,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.visibility_off_outlined)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xff491b6d), width: 2),
                      borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(8)),
                  hintText: tr(AppText.confirmPassword)
                  // "Confirm Password"
                  ,
                  hintStyle: const TextStyle(color: Color(0xff4B4B4B))),
            ),
            SizedBox(
              height: s.height * 0.12,
            ),
            InkWell(
              onTap: () async {
                try {
                  await FirebaseAuth.instance.confirmPasswordReset(
                      code: "", newPassword: passwordController.text);
                  ToastUtil.showSuccessToast(
                      tr(AppText.successfullyResetPassword)
                      // "Successfully Reset Password"
                      );
                } catch (error) {
                  ToastUtil.showErrorToast(error.toString());
                }
              },
              child: Container(
                height: s.height * 0.07,
                width: s.height,
                decoration: BoxDecoration(
                    color: const Color(0xff491b6d),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: Text(
                  // "Submit"\
                  tr(AppText.submit),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
