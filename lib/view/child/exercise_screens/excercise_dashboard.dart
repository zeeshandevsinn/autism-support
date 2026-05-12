import 'package:autism_support/components/child_card.dart';
import 'package:autism_support/components/custom_appbar.dart';
import 'package:autism_support/controller/services/firebase_manager.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../utils/exercise_data.dart';

class ExerciseDashboard extends StatefulWidget {
  const ExerciseDashboard({super.key});

  @override
  State<ExerciseDashboard> createState() => _ExerciseDashboardState();
}

class _ExerciseDashboardState extends State<ExerciseDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
         backgroundColor: childBgColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Determine the number of columns based on screen width
                int crossAxisCount;
                if (constraints.maxWidth > 1200) {
                  crossAxisCount = 4;
                } else if (constraints.maxWidth > 800) {
                  crossAxisCount = 3;
                } else {
                  crossAxisCount = 2;
                }
                return Column(
                  children: [
                    CustomAppbar(
                      title: tr(AppText.exercise)
                      // "Exercise"
                      ,
                      route: '/child_dashboard',
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 12.0, // Space between rows
                          crossAxisSpacing: 12.0, // Space between columns
                          childAspectRatio:
                              1.0, // Aspect ratio of each grid item
                        ),
                        itemCount: excerciseData.length,
                        itemBuilder: (BuildContext context, index) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ChildCard(
                                    image: AssetImage(
                                        excerciseData[index]['card_image']),
                                    onTap: () async {
                                      var obtainedMarks = await FirebaseManager
                                          .getObtainedMarks(
                                        type: excerciseData[index]['type'],
                                      );
                                      obtainedMarks != null
                                          ? await FirebaseManager.drillMarks(
                                              image: excerciseData[index]
                                                  ['card_image'],
                                              drillType: excerciseData[index]
                                                  ['type'],
                                              obtained: obtainedMarks,
                                              total: excerciseData[index]
                                                      ['data']
                                                  .length)
                                          : await FirebaseManager.drillMarks(
                                              image: excerciseData[index]
                                                  ['card_image'],
                                              drillType: excerciseData[index]
                                                  ['type'],
                                              obtained: 0,
                                              total: excerciseData[index]
                                                      ['data']
                                                  .length);
                                      final Map<String, dynamic> data =
                                          excerciseData[index]
                                              as Map<String, dynamic>;
                                      Navigator.pushNamed(
                                        context,
                                        '/exercise/drill',
                                        arguments: data,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                    height: 8.0), // Space between card and text
                                Text(
                                  "${excerciseData[index]['type']}",
                                  style: const TextStyle(
                                      fontSize: 20), // Adjusted font size
                                  textAlign:
                                      TextAlign.center, // Center align text
                                )
                              ],
                            ),
                          );
                        },
                      ),
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
