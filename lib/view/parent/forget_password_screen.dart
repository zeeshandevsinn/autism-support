import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:autism_support/utils/toast/toast.dart';
import 'package:autism_support/view/parent/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return Scaffold(
       backgroundColor: parentBgColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    icon: const Icon(
                      Icons.cancel,
                      size: 35,
                    ))),
            SizedBox(
              height: s.height * 0.02,
            ),
            Text(
              tr(AppText.forgotYourPassword)
              // "Forgot your Password?"
              ,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: "Roboto",
              ),
            ),
            SizedBox(
              height: s.height * 0.01,
            ),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: tr(AppText
                          .enterYourEmailAddressAndWeWillShareALinkToCreateANewPassword)
                      // "Enter your email address and we will share a link to create a new password."
                      ,
                      style: const TextStyle(
                          color: Color(0xff4B4B4B),
                          fontSize: 20,
                          fontFamily: "Roboto"))
                ])),
            SizedBox(
              height: s.height * 0.06,
            ),
            TextField(
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto"),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xff491b6d), width: 2),
                      borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(8)),
                  hintText: tr(AppText.enterEmailAdress)
                  //  "Enter Email Adress"
                  ,
                  hintStyle: const TextStyle(
                      color: Color(0xff4B4B4B), fontWeight: FontWeight.w400)),
            ),
            SizedBox(
              height: s.height * 0.05,
            ),
            InkWell(
              onTap: () async {
                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: emailController.text);
                  ToastUtil.showSuccessToast(tr(AppText.successfullyDone)
                      // "Successfully Done"
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 25,
                      ),
                      SizedBox(
                        width: s.width * 0.02,
                      ),
                      Text(
                        tr(AppText.send)
                        // "Send"
                        ,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
