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
      child: Scaffold(
        backgroundColor: parentBgColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: s.height * 0.02),

                // Header Section
                StreamBuilder(
                  stream: db
                      .collection(ParentCollection)
                      .doc(UserSession.userID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text(
                          '${tr(AppText.somethingWentWrong)} ${snapshot.error}');
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      final DocumentSnapshot<Object?> data = snapshot.data!;
                      var parentData = data.data();
                      if (parentData == null) {
                        return Text(tr(AppText.nodataavailable));
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${tr(AppText.hello)} ${data.get('name')} ",
                              style: TextStyle(
                                color: parentPrimaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                CupertinoDialogRoute(
                                  builder: (_) => const HomeScreen(),
                                  context: context,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: parentPrimaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                CupertinoIcons.home,
                                color: parentPrimaryColor,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Text(tr(AppText.nodataavailable));
                    }
                  },
                ),

                SizedBox(height: s.height * 0.02),

                // Child Profile Section
                StreamBuilder(
                  stream: db
                      .collection(childCollection)
                      .doc(UserSession.getUID())
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      final DocumentSnapshot<Object?> data = snapshot.data!;
                      var userData = data.data();
                      if (userData != null) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: parentPrimaryColor.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.get("name"),
                                      style: const TextStyle(
                                        color: parentPrimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${tr(AppText.age)}: ${data.get("age")}",
                                      style: TextStyle(
                                        color: parentTextColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: MemoryImage(
                                  base64Decode(data.get("image")),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return _buildAddChildCard(context);
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),

                SizedBox(height: s.height * 0.02),

                // Current Mood Section
                StreamBuilder(
                  stream: db
                      .collection(childCollection)
                      .doc(UserSession.getUID())
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      final DocumentSnapshot<Object?> data = snapshot.data!;
                      var userData = data.data();
                      if (userData != null) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: parentSecondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: parentSecondaryColor.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "${data.get('name')} ${tr(AppText.todayIAmFeeling)} ${data.get('current_mood')['name']}",
                                  style: const TextStyle(
                                    color: parentTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  data.get('current_mood')['emoji'],
                                  style: const TextStyle(fontSize: 32),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return _buildNoChildDataCard(context);
                      }
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),

                SizedBox(height: s.height * 0.03),

                // Menu Cards Section
                // Menu Cards Section - All cards same size
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _buildMenuCard(
                            title: tr(AppText.preferences),
                            icon: Icons.settings,
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoDialogRoute(
                                  builder: (_) => const PreferencesScreen(),
                                  context: context,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMenuCard(
                            title: tr(AppText.exercise),
                            subtitle: tr(AppText.tracking),
                            icon: Icons.fitness_center,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/exercise_tracking');
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: _buildMenuCard(
                        title: tr(AppText.family),
                        subtitle: tr(AppText.members),
                        icon: Icons.family_restroom,
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/parent/family_members');
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: s.height * 0.03),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await FirebaseManager.signOut(context);
          },
          backgroundColor: parentPrimaryColor,
          child: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Helper method for Add Child Card
  Widget _buildAddChildCard(BuildContext context) {
  return InkWell(
    onTap: () {
      addAlert(context, const AddChildScreen(), 'child');
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: parentPrimaryColor,
          width: 2,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: parentPrimaryColor.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      parentPrimaryColor,
                      parentSecondaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.child_care,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                tr(AppText.addChild),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: parentPrimaryColor,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: parentPrimaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              color: parentPrimaryColor,
              size: 18,
            ),
          ),
        ],
      ),
    ),
  );
}

  // Helper method for No Child Data Card
 Widget _buildNoChildDataCard(BuildContext context) {
  return InkWell(
    onTap: () {
      addAlert(context, const AddChildScreen(), 'child');
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            parentPrimaryColor,
            parentSecondaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: parentPrimaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.child_care,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tr(AppText.noChildData),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
    ),
  );
}

  // Helper method for Menu Cards
  // Helper method for Menu Cards with Gradient - Fixed Size
  Widget _buildMenuCard({
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 140, // Fixed height for all cards
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              parentPrimaryColor, // Deep Navy
              parentSecondaryColor, // Ocean Blue
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: parentPrimaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              // maxLines: 1,
              // overflow: TextOverflow.ellipsis,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
