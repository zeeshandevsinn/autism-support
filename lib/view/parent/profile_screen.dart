import 'dart:io';

import 'package:autism_support/components/custom_buttons.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/custom_textfield.dart';
import '../../components/custom_text.dart';
import '../../utils/colors.dart';
import '../../utils/spaces.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? image;

  get picker => null;

  Future getImages() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: parentBgColor,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            Text(
              tr(AppText.yourProfile)
              // "Your Profile"
              ,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: Image.file(image!).image,
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                          onPressed: () async {
                            getImages();
                          },
                          icon: const Icon(Icons.add_circle_rounded,
                              color: parentPrimaryColor, size: 19))),
                ],
              ),
            ),
            vSpace,
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: CustomText(
                  text: tr(AppText.name)
                  // "Name"
                  ,
                  fontsize: 16),
            ),
            v2Space,
            CustomTextfield(
              hinttext: tr(AppText.enterChildName)
              //  'Enter child Name'
              ,
              controller: TextEditingController(),
            ),
            vertical3Space,
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: CustomText(
                  text: tr(AppText.email)
                  //  "Email"
                  ,
                  fontsize: 16),
            ),
            v2Space,
            CustomTextfield(
              hinttext: tr(AppText.email)
              // 'Email'
              ,
              prefixIcon: const Icon(
                Icons.mail_outline_rounded,
                color: parentPrimaryColor,
              ),
              controller: TextEditingController(),
            ),
            vertical3Space,
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: CustomText(
                  text: tr(AppText.phoneNo)
                  //  "Phone No"
                  ,
                  fontsize: 16),
            ),
            v2Space,
            CustomTextfield(
              hinttext: tr(AppText.phoneNo)
              // 'Phone No'
              ,
              prefixIcon: const Icon(
                Icons.call_rounded,
                color: parentPrimaryColor,
              ),
              controller: TextEditingController(),
            ),
            vertical3Space,
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add_circle_rounded,
                      color: parentPrimaryColor,
                    )),
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: parentPrimaryColor,
                    ),
                    child: CustomText2(
                      text: tr(AppText.childrens)
                      //  "Childrens"
                      ,
                      fontsize: 13,
                      color: whiteColor,
                    ))
              ],
            ),
            v4Space,
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton2(
                    text: tr(AppText.cancel)
                    // 'Cancel'
                    ,
                    color: whiteColor,
                  ),
                  const SizedBox(width: 7),
                  CustomButton2(
                    text: tr(AppText.save)
                    // 'Save'
                    ,
                    color: whiteColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
