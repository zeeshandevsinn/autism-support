import 'dart:convert';
import 'package:autism_support/controller/services/firebase_manager.dart';
import 'package:autism_support/controller/services/base.dart';
import 'package:autism_support/home_screen.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/view/parent/add_child_screen.dart';
import 'package:autism_support/view/parent/preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../components/custom_add_alert.dart';
import '../../utils/colors.dart';

class UserDashbarScreen extends StatefulWidget {
  const UserDashbarScreen({super.key});

  @override
  State<UserDashbarScreen> createState() => _UserDashbarScreenState();
}

class _UserDashbarScreenState extends State<UserDashbarScreen> {
  var userID = UserSession.getUID();
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: s.height * 0.015,
                  ),
                  StreamBuilder(
                    stream: db
                        .collection(ParentCollection)
                        .doc(UserSession.userID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text(tr(AppText.somethingWentWrong)
                            // Something went wrong:
                            +
                            ' ${snapshot.error}');
                      }
                      if (snapshot.hasData && snapshot.data != null) {
                        DocumentSnapshot data = snapshot.data!;
                        // debugger();
                        var parentData = data.data();

                        if (parentData == null) {
                          return Text(tr(AppText.nodataavailable)
                              // 'No data available'
                              );
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tr(AppText.hello) + "${data.get('name')} ",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Roboto"),
                            ),
                            GestureDetector(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      CupertinoDialogRoute(
                                          builder: (_) => const HomeScreen(),
                                          context: context));
                                },
                                child: Icon(
                                  CupertinoIcons.home,
                                  color: primaryColor,
                                  size: 30,
                                  fill: 1,
                                )),
                          ],
                        );
                      } else {
                        return Text(tr(AppText.nodataavailable)
                            // 'No data available'
                            );
                      }
                    },
                  ),
                  SizedBox(
                    height: s.height * 0.005,
                  ),
                  StreamBuilder(
                      stream: db
                          .collection(childCollection)
                          .doc(UserSession.getUID())
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          DocumentSnapshot data = snapshot.data!;
                          var userData = data.data();

                          if (userData != null) {
                            return Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 15),
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.get("name"),
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          // Age
                                          tr(AppText.age) +
                                              ": ${data.get("age")}",
                                          style: TextStyle(
                                              color: primaryColor,
                                              // fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: MemoryImage(
                                          base64Decode(data.get("image"))),
                                    )
                                  ],
                                ));
                          } else {
                            return InkWell(
                              onTap: () {
                                addAlert(
                                    context, const AddChildScreen(), 'child');
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      // "Add Child"
                                      tr(AppText.addChild),
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Roboto"),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: secondaryColor,
                                      radius: 40,
                                      child: Center(
                                          child: Icon(
                                        Icons.add,
                                        color: whiteColor,
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }),
                  SizedBox(
                    height: s.height * 0.02,
                  ),
                  StreamBuilder(
                      stream: db
                          .collection(childCollection)
                          .doc(UserSession.getUID())
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          DocumentSnapshot data = snapshot.data!;
                          var userData = data.data();

                          if (userData != null) {
                            return Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 15),
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${data.get('name')} is feeling ${data.get('current_mood')['name']}",
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      data.get('current_mood')['emoji'],
                                      style: const TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ));
                          } else {
                            return InkWell(
                              onTap: () {
                                addAlert(
                                    context, const AddChildScreen(), 'child');
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      // "No Child Data!"
                                      tr(AppText.noChildData),
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Roboto"),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }),
                  SizedBox(
                    height: s.height * 0.02,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoDialogRoute(
                                      builder: (_) => const PreferencesScreen(),
                                      context: context));
                            },
                            child: Container(
                              height: s.height * 0.18,
                              width: s.width * 0.45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                      image: AssetImage(
                                        "assets/cardimage.png",
                                      ),
                                      fit: BoxFit.fill)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, top: 40),
                                child: Text(
                                  // "Preferences"
                                  tr(AppText.preferences),
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Roboto",
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: s.width * 0.03,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/exercise_tracking');
                            },
                            child: Container(
                              height: s.height * 0.18,
                              width: s.width * 0.45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                      image: AssetImage(
                                        "assets/cardimage.png",
                                      ),
                                      fit: BoxFit.fill)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, top: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      // "Exercise"
                                      tr(AppText.exercise),
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Roboto",
                                          fontSize: 20),
                                    ),
                                    Text(
                                      // "Tracking"
                                      tr(AppText.tracking),
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Roboto",
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: s.height * 0.02,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/parent/family_members');
                        },
                        child: Container(
                          height: s.height * 0.18,
                          width: s.width * 0.45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                  image: AssetImage(
                                    "assets/cardimage.png",
                                  ),
                                  fit: BoxFit.fill)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, top: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // "Family"
                                  tr(AppText.family),
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Roboto",
                                      fontSize: 20),
                                ),
                                Text(
                                  tr(AppText.members)
                                  // "Members"
                                  ,
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Roboto",
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await FirebaseManager.signOut(context);
              },
              backgroundColor: primaryColor,
              child: Icon(
                Icons.logout,
                color: secondaryColor,
              )),
        ),
      ),
    );
  }
}
