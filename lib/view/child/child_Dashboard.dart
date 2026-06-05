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
      "title": tr(AppText.learning),
      "image": "assets/autism2.jpeg",
    },
    {
      "title": tr(AppText.exercise),
      "image": "assets/autism3.jpeg",
    },
    {
      "title": tr(AppText.emotions),
      "image": "assets/autism4.jpeg",
    },
    {
      "title": tr(AppText.conversation),
      "image": "assets/autism5.jpeg",
    },
    {
      "title": tr(AppText.familyMembers),
      "image": "assets/family.jpeg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                childSecondaryColor,
                childBgColor,
                Colors.white,
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: LayoutBuilder(
              builder: (context, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    StreamBuilder(
                      stream: db
                          .collection(ParentCollection)  // FIXED: Get child from parent collection
                          .doc(UserSession.getUID())
                          .collection(childCollection)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          var childDoc = snapshot.data!.docs.first;
                          var childData = childDoc.data() as Map<String, dynamic>;
                          return CustomAppbar(
                            title: childData['name'] ?? tr(AppText.child),
                            color: childPrimaryColor,
                            route: '/home',
                            trailing: Text(
                              childData['current_mood']?['emoji'] ?? '😊',
                              style: const TextStyle(fontSize: 50),
                            ),
                          );
                        } else {
                          return CustomAppbar(
                            title: tr(AppText.child),
                            route: '/home',
                            color: childPrimaryColor,
                          );
                        }
                      },
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12.0,
                          crossAxisSpacing: 12.0,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: dashboard.length - 1,
                        itemBuilder: (BuildContext context, int index) {
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
                                  dashboard[index]['title'],
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: childPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    // Family Card - Fixed (No video icon)
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/family_members');
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            height: MediaQuery.of(context).size.height * 0.25,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  childPrimaryColor,
                                  childSecondaryColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: childPrimaryColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Background Image
                                  Image.asset(
                                    dashboard[4]['image'],
                                    fit: BoxFit.cover,
                                  ),
                                  // Gradient Overlay
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.6),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Title Overlay
                                  Positioned(
                                    bottom: 16,
                                    left: 16,
                                    right: 16,
                                    child: Text(
                                      dashboard[4]['title'],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}