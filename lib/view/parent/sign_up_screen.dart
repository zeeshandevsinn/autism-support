import 'package:autism_support/utils/app_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/custom_images.dart';
import '../../components/custom_text.dart';
import '../../components/custom_textfield.dart';
import '../../controller/services/firebase_auth_provider.dart';
import '../../spaces.dart';
import '../../utils/colors.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var form_key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<FirebaseAuthProvider>();
  }

  bool visible = false;
  bool visible1 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        var pro = context.watch<FirebaseAuthProvider>();
        return pro.isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: form_key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomImages(height: 160.0, width: 160.0),
                        Align(
                            alignment: Alignment.topCenter,
                            child: CustomText(
                              text: tr(AppText.createAnAccount)
                              //  "Create An Account"
                              ,
                              fontsize: 18.0,
                            )),
                        vSpace,
                        Padding(
                          padding: EdgeInsets.only(left: 2),
                          child: CustomText(
                              text: tr(AppText.name)
                              // "Name"
                              ,
                              fontsize: 16.0),
                        ),
                        veSpace,
                        CustomTextfield(
                          controller: fullNameController,
                          hinttext: tr(AppText.enterYourName)
                          // 'Enter your Name'
                          ,
                        ),
                        vertical3Space,
                        Padding(
                          padding: EdgeInsets.only(left: 2),
                          child: CustomText(
                              text: tr(AppText.email)
                              // "Email"
                              ,
                              fontsize: 16.0),
                        ),
                        veSpace,
                        CustomTextfield(
                          controller: emailController,
                          hinttext: tr(AppText.email)
                          // 'Email'
                          ,
                          prefixIcon: Icon(
                            Icons.mail_outline_rounded,
                            color: primaryColor,
                          ),
                        ),
                        vertical3Space,
                        Padding(
                          padding: EdgeInsets.only(left: 2),
                          child: CustomText(
                              text: tr(AppText.password)
                              // "Password"
                              ,
                              fontsize: 16.0),
                        ),
                        veSpace,
                        CustomTextfield(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Field is Empty";
                            } else if (passwordController.text.length < 8) {
                              return tr(AppText.passwordCharacterLengthAtLeast)
                                  //  'Password Character length at least 8'
                                  ;
                            } else if (!passwordController.text.contains('!') &&
                                !passwordController.text.contains('@') &&
                                !passwordController.text.contains('#') &&
                                !passwordController.text.contains('\$') &&
                                !passwordController.text.contains('%') &&
                                !passwordController.text.contains('^') &&
                                !passwordController.text.contains('&') &&
                                !passwordController.text.contains('*') &&
                                !passwordController.text.contains(')') &&
                                !passwordController.text.contains('(')) {
                              return tr(AppText.passwrodContainsMust)
                                  //  Passwrod contains must
                                  +
                                  '{!@#\$%^&*()}';
                            }
                            return null;
                          },
                          controller: passwordController,
                          obscureCharacter: "*",
                          isObscureText: visible1 ? false : true,
                          keyboardType: TextInputType.text,
                          hinttext: tr(AppText.confirmPassword)
                          //  'Confirm Password'
                          ,
                          suffixicon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  visible1 = !visible1;
                                });
                              },
                              child: visible1
                                  ? const Icon(Icons.visibility_rounded,
                                      color: Colors.black45)
                                  : const Icon(Icons.visibility_off,
                                      color: Colors.black45)),
                        ),
                        vertical3Space,
                        Padding(
                          padding: EdgeInsets.only(left: 2),
                          child: CustomText(
                              text: tr(AppText.confirmPassword)
                              // "Confirm Password"
                              ,
                              fontsize: 16.0),
                        ),
                        veSpace,
                        CustomTextfield(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return tr(AppText.fieldIsEmpty)
                                  // "Field is Empty"
                                  ;
                            } else if (passwordController.text !=
                                confirmPasswordController.text) {
                              return tr(AppText.passwordDidNotMatch)
                                  // 'Password did not match'

                                  ;
                            }
                            return null;
                          },
                          obscureCharacter: "*",
                          isObscureText: visible ? false : true,
                          keyboardType: TextInputType.text,
                          hinttext: tr(AppText.confirmPassword)
                          // 'Confirm Password'
                          ,
                          suffixicon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  visible = !visible;
                                });
                              },
                              child: visible
                                  ? const Icon(Icons.visibility_rounded,
                                      color: Colors.black45)
                                  : const Icon(Icons.visibility_off,
                                      color: Colors.black45)),
                          controller: confirmPasswordController,
                        ),
                        vSpace,
                        InkWell(
                          onTap: () async {
                            if (form_key.currentState!.validate()) {
                              await pro.registerWithEmail(
                                  context,
                                  fullNameController.text.trim(),
                                  emailController.text.trim(),
                                  passwordController.text.trim());
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.07,
                            width: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                                color: PurpleColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              // "SIGN UP"
                              tr(AppText.sIGNUP),
                              style: TextStyle(
                                  color: WhiteColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            )),
                          ),
                        ),
                        vSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText2(
                                text: tr(AppText.haveAnAccountAlready)
                                //  'Have an account already?  '
                                ,
                                color: blackColor,
                                fontsize: 13.0),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const LoginScreen()));
                              },
                              child: CustomText2(
                                  text:
                                      //  'Log in'
                                      tr(AppText.logIn),
                                  color: primaryColor,
                                  fontsize: 13.0),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
      }),
    );
  }
}
