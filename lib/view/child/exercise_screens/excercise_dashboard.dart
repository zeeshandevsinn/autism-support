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
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                childSecondaryColor,      // Soft Pink (#FDA4AF)
                childBgColor,             // Very Light Pink-White (#FEF2F2)
                Colors.white,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
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
                        title: tr(AppText.exercise),
                        route: '/child_dashboard',
                      ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 12.0,
                            crossAxisSpacing: 12.0,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: excerciseData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildExerciseCard(index);
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
      ),
    );
  }

  Widget _buildExerciseCard(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: childPrimaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ChildCard(
                image: AssetImage(excerciseData[index]['card_image']),
                onTap: () async {
                  await _handleExerciseTap(index);
                },
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "${excerciseData[index]['type']}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: childPrimaryColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }

  Future<void> _handleExerciseTap(int index) async {
    try {
      var obtainedMarks = await FirebaseManager.getObtainedMarks(
        type: excerciseData[index]['type'],
      );
      
      if (obtainedMarks != null) {
        await FirebaseManager.drillMarks(
          image: excerciseData[index]['card_image'],
          drillType: excerciseData[index]['type'],
          obtained: obtainedMarks,
          total: excerciseData[index]['data'].length,
        );
      } else {
        await FirebaseManager.drillMarks(
          image: excerciseData[index]['card_image'],
          drillType: excerciseData[index]['type'],
          obtained: 0,
          total: excerciseData[index]['data'].length,
        );
      }
      
      final Map<String, dynamic> data = excerciseData[index] as Map<String, dynamic>;
      
      if (mounted) {
        Navigator.pushNamed(
          context,
          '/exercise/drill',
          arguments: data,
        );
      }
    } catch (e) {
      print("Error in exercise tap: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to start exercise. Please try again.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}