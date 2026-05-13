import 'dart:convert';
import 'package:autism_support/components/custom_appbar.dart';
import 'package:autism_support/controller/services/base.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FamilyMemberCards extends StatelessWidget {
  const FamilyMemberCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              childSecondaryColor,
              childBgColor,
              Colors.white,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppbar(
                title: tr(AppText.familyMembers),
                route: '/child_dashboard',
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(ParentCollection)
                      .doc(UserSession.getUID())
                      .collection(familyCollection)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(childPrimaryColor),
                        ),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.family_restroom,
                              size: 80,
                              color: childPrimaryColor.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              tr(AppText.noFamilyMembersFound),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              tr(AppText.familyMembers),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    var familyMembers = snapshot.data!.docs;
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.75,
                      ),
                      padding: const EdgeInsets.all(16.0),
                      itemCount: familyMembers.length,
                      itemBuilder: (context, index) {
                        var familyMember = familyMembers[index].data() as Map<String, dynamic>;
                        var name = familyMember['name'] ?? tr(AppText.noName);
                        var relation = familyMember['relation'] ?? tr(AppText.noRelation);
                        var imageUrl = familyMember['image'] ?? '';
                        
                        return _buildFamilyCard(
                          name: name,
                          relation: relation,
                          imageUrl: imageUrl,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyCard({
    required String name,
    required String relation,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: childPrimaryColor.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Optional: Show family member details
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  childSecondaryColor.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: childSecondaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image Section
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      image: imageUrl.isNotEmpty
                          ? DecorationImage(
                              image: MemoryImage(base64Decode(imageUrl)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: imageUrl.isEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  childPrimaryColor.withOpacity(0.1),
                                  childSecondaryColor.withOpacity(0.2),
                                ],
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: childPrimaryColor.withOpacity(0.5),
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
                // Name and Relation Section
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: childPrimaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: childSecondaryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            relation,
                            style: TextStyle(
                              fontSize: 12,
                              color: childPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}