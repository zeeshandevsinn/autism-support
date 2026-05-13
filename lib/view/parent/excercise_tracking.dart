import 'package:autism_support/components/custom_appbar.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
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
      backgroundColor: parentBgColor,
      body: Column(
        children: [
          CustomAppbar(
            title: tr(AppText.excerciseTracking),
            route: '/parent_dashboard',
            textSize: 20.0,
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection(childCollection)
                  .doc(UserSession.getUID())
                  .collection('marks')
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
                          Icons.fitness_center,
                          size: 80,
                          color: parentPrimaryColor.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          tr(AppText.noExcerciseDataFound),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tr(AppText.completeExercisesToSeeProgress),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: excerciseData.length,
                  itemBuilder: (context, index) {
                    var documents = snapshot.data!.docs[index];
                    var obtained = documents['obtained'] ?? 0;
                    var total = documents['total'] ?? 0;
                    var percentage = total > 0 ? (obtained / total) * 100 : 0;
                    
                    return _buildExerciseCard(
                      context: context,
                      title: documents.id,
                      obtained: obtained,
                      total: total,
                      percentage: percentage,
                      exerciseType: excerciseData[index]['type'],
                      onReset: () async {
                        await FirebaseManager.udpateObtainedMarks(
                          drillType: excerciseData[index]['type'],
                          obtained: 0,
                        );
                      },
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
  
  Widget _buildExerciseCard({
    required BuildContext context,
    required String title,
    required int obtained,
    required int total,
    required double percentage,
    required String exerciseType,
    required VoidCallback onReset,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: parentBgColor, 
        
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
            // Optional: View exercise details
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Title and Reset Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  parentPrimaryColor,
                                  parentSecondaryColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getExerciseIcon(exerciseType),
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: parentTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Reset Button
                    GestureDetector(
                      onTap: onReset,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.orange.shade200,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.restore,
                              size: 18,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tr(AppText.reset),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Score Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr(AppText.yourScore),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '$obtained',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: parentPrimaryColor,
                                ),
                              ),
                              TextSpan(
                                text: '/$total',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    // Percentage Circle
                    Container(
                      width: 70,
                      height: 70,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            
                            value: percentage / 100,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getPercentageColor(percentage),
                            ),
                            strokeWidth: 6,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${percentage.toInt()}%',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _getPercentageColor(percentage),
                                ),
                              ),
                              Text(
                                tr(AppText.completed),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tr(AppText.progress),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '${percentage.toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getPercentageColor(percentage),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getPercentageColor(percentage),
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  IconData _getExerciseIcon(String exerciseType) {
    switch (exerciseType.toLowerCase()) {
      case 'matching':
        return Icons.compare_arrows;
      case 'identification':
        return Icons.visibility;
      case 'sorting':
        return Icons.sort;
      default:
        return Icons.fitness_center;
    }
  }
  
  Color _getPercentageColor(double percentage) {
    if (percentage >= 80) {
      return Colors.green;
    } else if (percentage >= 50) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}