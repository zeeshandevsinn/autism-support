import 'package:autism_support/controller/services/base.dart';
import 'package:autism_support/controller/services/firebase_auth_provider.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:autism_support/view/parent/forget_password_screen.dart';
import 'package:autism_support/view/parent/sign_up_screen.dart';
import 'package:autism_support/view/parent/user_dashbar_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool visibility = false;

  @override
  void initState() {
  
    super.initState();
    context.read<FirebaseAuthProvider>();
  }

  final newKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Scaffold(
       backgroundColor: parentBgColor,
      body: Builder(builder: (context) {
        var pro = context.watch<FirebaseAuthProvider>();
        return pro.isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator.adaptive(),
                    const SizedBox(height: 20),
                    // Add space between the spinner and text
                    Text(
                      tr(AppText.waitingForLoggingUser)
                      // 'Waiting for Logging User...'
                      ,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black, // Set text color
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: newKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/logo.png",
                          height: s.height * 0.1,
                        ),
                        SizedBox(
                          height: s.height * 0.02,
                        ),
                        Text(
                          tr(AppText.welcomeBack)
                          // "Welcome Back"
                          ,
                          style: const TextStyle(
                            color: parentPrimaryColor, 
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            fontFamily: "Roboto",
                          ),
                        ),
                        SizedBox(
                          height: s.height * 0.007,
                        ),
                        Text(
                            tr(AppText.loginToContinue)
                            // "Login to continue"
                            ,
                            style: const TextStyle(
                                color: parentPrimaryColor,
                                fontSize: 17,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w600)),
                        SizedBox(
                          height: s.height * 0.08,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                              tr(AppText.emailAddress)
                              // "Email Address"
                              ,
                              style: const TextStyle(
                                  color: parentPrimaryColor,
                                  fontSize: 17,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(
                          height: s.height * 0.01,
                        ),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return tr(AppText.pleaseEnterAnEmail)
                                  //  'Please enter an email'
                                  ;
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return tr(AppText.pleaseEnterAValidEmailAddress)
                                  // 'Please enter a valid email address'
                                  ;
                            }
                            return null;
                          },
                          style: TextStyle(
                              color: BlackColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto"),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: parentPrimaryColor, width: 2),
                                  borderRadius: BorderRadius.circular(8)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 1),
                                  borderRadius: BorderRadius.circular(8)),
                              hintText: tr(AppText.enterEmailAdress)
                              // "Enter Email Adress"
                              ,
                              hintStyle: const TextStyle(
                                  color: Color(0xff4B4B4B),
                                  fontWeight: FontWeight.w400)),
                        ),
                        SizedBox(
                          height: s.height * 0.04,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                              tr(AppText.password)
                              // "Password"
                              ,
                              style: const TextStyle(
                                  color: parentPrimaryColor,
                                  fontSize: 17,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(
                          height: s.height * 0.01,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: visibility ? false : true,
                          style: TextStyle(
                              color: BlackColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto"),
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      visibility = !visibility;
                                    });
                                  },
                                  icon: Icon(visibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: parentPrimaryColor, width: 2),
                                  borderRadius: BorderRadius.circular(8)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 1),
                                  borderRadius: BorderRadius.circular(8)),
                              hintText: tr(AppText.enterPassword)
                              // "Enter Password"
                              ,
                              hintStyle:
                                  const TextStyle(color: Color(0xff4B4B4B))),
                        ),
                        SizedBox(
                          height: s.height * 0.026,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgetPasswordScreen()));
                          },
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                  // "Forget Password?"
                                  tr(AppText.forgetPassword),
                                  style: const TextStyle(
                                      color: parentPrimaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Roboto"))),
                        ),
                        SizedBox(
                          height: s.height * 0.08,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (newKey.currentState!.validate()) {
                              final data = await pro.LoginWithEmail(
                                  context,
                                  _emailController.text.trim(),
                                  _passwordController.text.trim());

                              print(UserSession.userID);
                              // debugger();
                              if (data != null) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoDialogRoute(
                                        builder: (_) =>
                                            const UserDashbarScreen(),
                                        context: context),
                                    (_) => false);
                              }
                            }
                          },
                          child: Container(
                            height: s.height * 0.07,
                            width: s.height,
                            decoration: BoxDecoration(
                                color: parentPrimaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              // "LOG IN"
                              tr(AppText.lOGIN),
                              style: TextStyle(
                                  color: WhiteColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            )),
                          ),
                        ),
                        SizedBox(
                          height: s.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                tr(AppText.dontHaveAnAccount)
                                // "Don’t have an account?"
                                ,
                                style: const TextStyle(fontSize: 16)),
                            SizedBox(
                              width: s.width * 0.004,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoDialogRoute(
                                        builder: (_) => const SignUpScreen(),
                                        context: context));
                              },
                              child: Text(
                                  tr(AppText.signUpNow)
                                  // "Sign up now"
                                  ,
                                  style: const TextStyle(
                                  color: parentPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                            ),
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
