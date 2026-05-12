import 'dart:io';

import 'package:autism_support/components/custom_buttons.dart';
import 'package:autism_support/components/custom_text.dart';
import 'package:autism_support/components/custom_textfield.dart';
import 'package:autism_support/controller/services/firebase_manager.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:autism_support/utils/spaces.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var usernameController = TextEditingController();
  var ageController = TextEditingController();
  var disabilityController = TextEditingController();

  var passwordController = TextEditingController();

  File? _image;

  Future getImage() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxHeight: 1800, maxWidth: 1800);

    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      _image = imageTemporary;
    });
  }

  var keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: parentBgColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 40.0,
                ),
                child: Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _image != null
                            ? kIsWeb
                                ? NetworkImage(Uri.parse(_image!.path).toString())
                                : Image.file(_image!).image
                            : null,
                        child: _image == null
                            ? const Center(
                                child: Icon(Icons.person_rounded, size: 30))
                            : null,
                      ),
                      Positioned(
                          bottom: -7,
                          right: 0,
                          child: IconButton(
                              onPressed: getImage,
                              icon: Icon(
                                Icons.add_circle_rounded,
                                size: 33,
                                color: parentPrimaryColor
                              )))
                    ],
                  ),
                ),
              ),
              vSpace,
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: CustomText(
                    text: tr(AppText.name)
      
                    //  "Name"
                    ,
                    fontsize: 16.0),
              ),
              v2Space,
              CustomTextfield(
                hinttext: 'Enter Name',
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr(AppText.pleasEnterYourName)
                        //  'Please enter your name'
                        ;
                  }
                  return null;
                },
              ),
              vertical3Space,
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: CustomText(
                    text: tr(AppText.age)
                    // "Age"
                    ,
                    fontsize: 16.0),
              ),
              v2Space,
              CustomTextfield(
                hinttext: tr(AppText.enterAge)
                // 'Enter Age'
                ,
                controller: ageController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr(AppText.pleaseEnterYourAge)
                        // 'Please enter your age'
                        ;
                  }
                  return null;
                },
              ),
              v2Space,
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton2(
                        text: tr(AppText.cancel)
                        // 'Cancel'
                        ,
                        color: whiteColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 7),
                      CustomButton2(
                          text: tr(AppText.save)
                          // 'Save'
                          ,
                          color: whiteColor,
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await FirebaseManager.addChildDB(
                                name: nameController.text.trim(),
                                age: ageController.text.trim(),
                                image: _image!,
                              );
                              Navigator.pop(context);
                            }
                          }),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
