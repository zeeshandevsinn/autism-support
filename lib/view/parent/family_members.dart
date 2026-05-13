import 'dart:convert';
import 'package:autism_support/components/custom_add_alert.dart';
import 'package:autism_support/components/custom_appbar.dart';
import 'package:autism_support/controller/services/firebase_manager.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:autism_support/view/parent/add_family_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../controller/services/base.dart';

class FamilyMembers extends StatelessWidget {
  const FamilyMembers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: parentBgColor,
      body: Column(
        children: [
          CustomAppbar(
            title: tr(AppText.familyMembers),
            route: '/parent_dashboard',
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection(ParentCollection)
                  .doc(UserSession.getUID())
                  .collection(familyCollection)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(parentPrimaryColor),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${tr(AppText.somethingWentWrong)} ${snapshot.error}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
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
                          color: parentPrimaryColor.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          tr(AppText.noFamilyMembersFound),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tr(AppText.familyMembers),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                var documents = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var data = documents[index].data() as Map<String, dynamic>;
                    var userId = documents[index].id;
                    var name = data["name"];
                    var relation = data["relation"];
                    
                    return _buildFamilyMemberCard(
                      context: context,
                      name: name,
                      relation: relation,
                      image: data['image'],
                      userId: userId,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addAlert(context, const AddFamilyScreen(), tr(AppText.familymember));
        },
        backgroundColor: parentPrimaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        elevation: 4,
      ),
    );
  }
  
  Widget _buildFamilyMemberCard({
    required BuildContext context,
    required String name,
    required String relation,
    required String image,
    required String userId,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: parentPrimaryColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: parentPrimaryColor.withOpacity(0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Optional: View member details
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Profile Image with gradient border
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        parentPrimaryColor,
                        parentSecondaryColor,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: parentPrimaryColor.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: MemoryImage(base64Decode(image)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Name and Relation
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: parentTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: parentSecondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          relation,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: parentSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Delete Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      _showDeleteDialog(context, name, userId);
                    },
                    tooltip: 'Delete member',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _showDeleteDialog(BuildContext context, String name, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Title
                Text(
                  tr(AppText.deleteFamilyMember),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: parentTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                
                // Message
                Text(
                  '${tr(AppText.areYouSureYouWantToDelete)} $name?',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              tr(AppText.cancel),
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await FirebaseManager.deleteFamilyMember(userId);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.red.shade600, Colors.red.shade400],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              tr(AppText.delete),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}