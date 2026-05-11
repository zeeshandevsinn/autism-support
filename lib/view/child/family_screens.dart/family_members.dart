import 'dart:convert';
import 'package:autism_support/components/custom_appbar.dart';
import 'package:autism_support/controller/services/base.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FamilyMemberCards extends StatelessWidget {
  const FamilyMemberCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(
            title: tr(AppText.familyMembers)
            // "Family Members"
            ,
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
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(tr(AppText.noFamilyMembersFound)
                          // 'No family members found'
                          ));
                }
                var familyMembers = snapshot.data!.docs;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 3 / 4,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  itemCount: familyMembers.length,
                  itemBuilder: (context, index) {
                    var familyMember =
                        familyMembers[index].data() as Map<String, dynamic>;

                    var name = familyMember['name'] ?? tr(AppText.noName)
                        // 'No Name'
                        ;
                    var relation =
                        familyMember['relation'] ?? tr(AppText.noRelation)
                        // 'No Relation'
                        ;
                    var imageUrl = familyMember['image'] ?? '';

                    return InkWell(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 175,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: imageUrl.isNotEmpty
                                    ? DecorationImage(
                                        image:
                                            MemoryImage(base64Decode(imageUrl)),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    relation,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
