import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:autism_support/view/parent/reset_password_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PassworResetSuccesfullyScreen extends StatelessWidget {
  const PassworResetSuccesfullyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Scaffold(
       backgroundColor: parentBgColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ResetPasswordScreen()));
                    },
                    icon: const Icon(
                      Icons.cancel,
                      size: 35,
                    ))),
            SizedBox(
              height: s.height * 0.02,
            ),
            Text(
              tr(AppText.passwordResetSuccessfull)
              // "Password reset successfull"
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
                      text: tr(AppText.youCanNowLoginWithYourNewPassword)
                      // "You can now login with your new password."
                      ,
                      style: const TextStyle(
                          color: Color(0xff4B4B4B),
                          fontSize: 20,
                          fontFamily: "Roboto"))
                ])),
            SizedBox(
              height: s.height * 0.1,
            ),
            InkWell(
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
                        tr(AppText.proceed)
                        // "Proceed"
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
