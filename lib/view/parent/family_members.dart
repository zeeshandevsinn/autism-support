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
            title: tr(AppText.familyMembers)
            //  'Family Members'
            ,
            route: '/parent_dashboard',
          ),
          const SizedBox(
            height: 20,
          ),

// Spacer(),
          StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection(ParentCollection)
                  .doc(UserSession.getUID())
                  .collection(familyCollection)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator()); // Loading state
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text('${tr(AppText.somethingWentWrong)}${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(tr(AppText.noFamilyMembersFound)
                          // 'No family members found.'
                          ));
                }

                // Extract the documents

                var documents = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var data = documents[index].data() as Map<String, dynamic>;

                    var userId = documents[index].id;
                    var name = data["name"];
                    var relation = data["relation"];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 0.1),
                      ),
                      child: ListTile(
                        title: Text("$name"),
                        subtitle: Text('$relation'),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              MemoryImage(base64Decode(data['image'])),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Show a confirmation dialog before deleting
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(tr(AppText.deleteFamilyMember)
                                      // 'Delete Family Member'
                                      ),
                                  content:
                                      Text('${tr(AppText.areYouSureYouWantToDelete)}$name?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Cancel deletion
                                        Navigator.pop(context);
                                      },
                                      child: Text(tr(AppText.cancel)
                                          // 'Cancel'
                                          ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // Proceed with deletion
                                        await FirebaseManager
                                            .deleteFamilyMember(userId);
                                        Navigator.pop(
                                            context); // Close the dialog
                                      },
                                      child: Text(tr(AppText.delete)
                                          // 'Delete'
                                          ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addAlert(context, const AddFamilyScreen(), tr(AppText.familymember)
              // 'family member'
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
