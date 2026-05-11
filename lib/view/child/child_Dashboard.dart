import 'package:autism_support/components/custom_appbar.dart';
import 'package:autism_support/components/family_card.dart';
import 'package:autism_support/components/parent_card.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../controller/services/base.dart';

class ChildDashboard extends StatefulWidget {
  const ChildDashboard({super.key});

  @override
  State<ChildDashboard> createState() => _ChildDashboardState();
}

class _ChildDashboardState extends State<ChildDashboard> {
  dynamic dashboard = [
    {
      "title": tr(AppText.learning)
      //  "Learning"
      ,
      "image": "assets/autism2.jpeg",
    },
    {
      "title": tr(AppText.exercise)
      //  "Exercise"
      ,
      "image": "assets/autism3.jpeg",
    },
    {
      "title": tr(AppText.emotions)
      //  "Emotions"
      ,
      "image": "assets/autism4.jpeg",
    },
    {
      "title": tr(AppText.conversation)
      // "Conversation"
      ,
      "image": "assets/autism5.jpeg",
    },
    {
      "title": tr(AppText.familyMembers)
      // "Family Members"
      ,
      "image": "assets/family.jpeg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: secondaryColor,
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: LayoutBuilder(
            builder: (context, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StreamBuilder(
                      stream: db
                          .collection(childCollection)
                          .doc(UserSession.getUID())
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          DocumentSnapshot data = snapshot.data!;
                          var userData = data.data();
                          print(userData);
                          if (userData != null) {
                            return CustomAppbar(
                                title: data.get('name'),
                                color: primaryColor,
                                route: '/home',
                                trailing: Text(
                                  data.get('current_mood')['emoji'],
                                  style: const TextStyle(fontSize: 50),
                                ));
                          } else {
                            return CustomAppbar(
                              title: tr(AppText.child)
                              // "Child"
                              ,
                              route: '/home',
                              color: primaryColor,
                            );
                          }
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12.0, // Space between rows
                        crossAxisSpacing: 12.0, // Space between columns
                        childAspectRatio: 0.8, // Aspect ratio of each grid item
                      ),
                      itemCount: dashboard.length - 1,
                      itemBuilder: (BuildContext context, index) {
                        String routeName;
                        switch (index) {
                          case 0:
                            routeName = '/learning';
                            break;
                          case 1:
                            routeName = '/exercise';
                            break;
                          case 2:
                            routeName = '/emotion';
                            break;
                          case 3:
                            routeName = '/conversation';
                            break;

                          default:
                            routeName = '/';
                        }
                        return Column(
                          children: [
                            ParentCard(
                              image: AssetImage(dashboard[index]['image']),
                              onTap: () {
                                Navigator.pushNamed(context, routeName);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "${dashboard[index]['title']}",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: primaryColor,
                                    fontWeight:
                                        FontWeight.bold), // Adjusted font size
                                textAlign:
                                    TextAlign.center, // Center align text
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  Column(
                    children: [
                      FamilyCard(
                        image: AssetImage(dashboard[4]['image']),
                        onTap: () {
                          Navigator.pushNamed(context, '/family_members');
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "${dashboard[4]['title']}",
                          style: TextStyle(
                              fontSize: 30,
                              color: primaryColor,
                              fontWeight:
                                  FontWeight.bold), // Adjusted font size
                          textAlign: TextAlign.center, // Center align text
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
