import 'package:autism_support/components/custom_appbar.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/exercise_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../controller/services/base.dart';
import '../../controller/services/firebase_manager.dart';

class ExcerciseTracking extends StatelessWidget {
  const ExcerciseTracking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(
            title: tr(AppText.excerciseTracking)
            //  'Excercise tracking'
            ,
            route: '/parent_dashboard',
            textSize: 20.0,
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection(childCollection)
                  .doc(UserSession.getUID())
                  .collection('marks')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator()); // Loading state
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text(tr(AppText.somethingWentWrong)
                          // 'Something went wrong:'
                          +
                          '${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(tr(AppText.noExcerciseDataFound)
                          // 'No excercise data found.'
                          ));
                }

                // Extract the documents

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: excerciseData.length,
                  itemBuilder: (context, index) {
                    // var name = data["name"];
                    // var relation = data["relation"];
                    var documents = snapshot.data!.docs[index];
                    var image = snapshot.data!.docs[index]['image'];
                    print(image);
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 0.1),
                      ),
                      child: ListTile(
                          title: Text(documents.id),
                          subtitle: Text(
                            "${documents['obtained']}/${documents['total']}",
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          // leading: CircleAvatar(
                          //   radius: 25,
                          //   backgroundImage: MemoryImage(
                          //                         base64Decode(documents['image'])),
                          // ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.restore,
                            ),
                            onPressed: () async {
                              print("hello    ${excerciseData[index]['type']}");
                              await FirebaseManager.udpateObtainedMarks(
                                  drillType: excerciseData[index]['type'],
                                  obtained: 0);
                            },
                          )),
                    );
                  },
                );
              })
        ],
      ),
    );
  }
}
