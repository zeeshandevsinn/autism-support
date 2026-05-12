import 'package:autism_support/components/child_card.dart';
import 'package:autism_support/components/custom_appbar.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';

import '../../../utils/learning_data.dart';

class LearningDashboard extends StatefulWidget {
  const LearningDashboard({super.key});

  @override
  State<LearningDashboard> createState() => _LearningDashboardState();
}

class _LearningDashboardState extends State<LearningDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
         backgroundColor: childBgColor,
        // floatingActionButton: FloatingActionButton(onPressed: (){
        //   log(learningData[1].toString());
        // },),
        // appBar: AppBar(
        //   // leadingWidth: MediaQuery.sizeOf(context).width*0.2,
        //   leading: InkWell(
        //             onTap: () => Navigator.pop(context),
        //             child: const CustomButton(
        //                 color: Colors.cyan,
        //                 icon: Icons.arrow_back_ios_new_rounded),
        //           ),
        //   centerTitle: true,
        //   title: const Text(
        //     'Learnings',
        //     style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
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
                      title: tr(AppText.learning)
                      // "Learning"
                      ,
                      route: "/child_dashboard",
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
                        itemCount: learningData.length,
                        itemBuilder: (BuildContext context, index) {
                          return Column(
                            children: [
                              Expanded(
                                child: ChildCard(
                                  image:
                                      AssetImage(learningData[index]['image']),
                                  onTap: () {
                                    final Map<String, dynamic> action =
                                        learningData[index];
                                    // print(learningData[index]);
                                    Navigator.pushNamed(
                                      context,
                                      '/learning/category',
                                      arguments: action,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                  height: 8.0), // Space between card and text
                              Text(
                                "${learningData[index]["title"]}",
                                style: const TextStyle(
                                    fontSize: 20), // Adjusted font size
                                textAlign:
                                    TextAlign.center, // Center align text
                              )
                            ],
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
