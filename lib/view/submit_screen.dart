import 'package:autism_support/components/custom_buttons.dart';
// ignore_for_file: unused_local_variable, unused_field

import 'package:autism_support/components/custom_text.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/spaces.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:pinput/pinput.dart';

class SubmitScreen extends StatelessWidget {
  final defaultPinTheme = PinTheme(
    width: 70,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  SubmitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: commonBgColor,
        body: Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 22),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
              hSpace,
              CustomText2(
                text: tr(AppText.verifyYourEmailAddress)
                // 'Verify your email address'
                ,
                FontWeight: FontWeight.bold,
                fontsize: 17,
                color: blackColor,
              )
            ],
          ),
          vertical3Space,
          vertical3Space,
          CustomText2(
            text: tr(AppText.weSentYouADigitCodeToVerify)
            // 'We sent you a 4 digit code to verify'
            ,
            FontWeight: FontWeight.normal,
            fontsize: 15,
            color: lightBlackColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText2(
                text: tr(AppText.youremailAddress)
                //  'your email address '
                ,
                FontWeight: FontWeight.normal,
                fontsize: 15,
                color: lightBlackColor,
              ),
              CustomText2(
                text: tr(AppText.desxgmailcom)
                //  '(desx@gmail.com)'
                ,
                FontWeight: FontWeight.bold,
                fontsize: 15,
                color: blackColor,
              ),
            ],
          ),
          CustomText2(
            text: tr(AppText.enterInTheFieldBelow)
            // 'Enter in the field below.'
            ,
            FontWeight: FontWeight.normal,
            fontsize: 15,
            color: lightBlackColor,
          ),
          vertical3Space,
          vertical3Space,
          Pinput(
            length: 4,
            defaultPinTheme: PinTheme(
              width: 57,
              height: 70,
              textStyle: TextStyle(
                  fontSize: 20, color: blackColor, fontWeight: FontWeight.w600),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          vertical3Space,
          vertical3Space,
          vertical3Space,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText2(
                text: tr(AppText.didNotGettheCode)
                //  'Did not get the code? '
                ,
                FontWeight: FontWeight.normal,
                fontsize: 15,
                color: lightBlackColor,
              ),
              CustomText2(
                text: tr(AppText.resend)
                // 'Resend'
                ,
                FontWeight: FontWeight.bold,
                fontsize: 15,
                color: blackColor,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText2(
                text: tr(AppText.expiresIn)
                //  'Expires in '
                ,
                FontWeight: FontWeight.normal,
                fontsize: 15,
                color: lightBlackColor,
              ),
              const CustomText2(
                text: '01:00',
                FontWeight: FontWeight.bold,
                fontsize: 15,
                color:parentPrimaryColor,
              ),
            ],
          ),
          const Spacer(),
          CustomButtons(
            text: tr(AppText.submit)
            // 'Submit'
            ,
          ),
          v4Space
        ],
      ),
    ));
  }
}