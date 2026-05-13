import 'package:autism_support/components/custom_appbar.dart';
import 'package:autism_support/controller/services/base.dart';
import 'package:autism_support/controller/services/firebase_manager.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ExerciseDrillScreen extends StatefulWidget {
  final Map<String, dynamic> drillData;
  const ExerciseDrillScreen({super.key, required this.drillData});

  @override
  State<ExerciseDrillScreen> createState() => _ExerciseDrillScreenState();
}

class _ExerciseDrillScreenState extends State<ExerciseDrillScreen> {
  var currentIndex;
  var correctCount;
  var data;

  void goToNextQuestion() {
    print("current $correctCount / $currentIndex");
    if (currentIndex < widget.drillData['data'].length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      submitExercise();
    }
  }

  void submitExercise() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          correctCount: correctCount,
          totalQuestions: widget.drillData['data'].length,
        ),
      ),
    );
  }

  getObtain() async {
    data = await FirebaseManager.getObtainedMarks(type: widget.drillData['type']);
    setState(() {
      currentIndex = data;
      correctCount = currentIndex;

      if (correctCount == widget.drillData['data'].length) {
        submitExercise();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getObtain();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.drillData;
    var height = MediaQuery.of(context).size.height;
    
    return SafeArea(
      child: Scaffold(
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
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(childCollection)
                .doc(UserSession.getUID())
                .collection('marks')
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
                        Icons.warning_amber_rounded,
                        size: 64,
                        color: Colors.orange.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tr(AppText.pleaseConsultWithYourParent),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              if (data == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(childPrimaryColor),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CustomAppbar(
                      route: '/exercise',
                      title: widget.drillData['type'].toString(),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: childPrimaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${currentIndex + 1}/${question['data'].length}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: childPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Question Image Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: childPrimaryColor.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Hero(
                        tag: '${tr(AppText.question)}$currentIndex',
                        child: Material(
                          type: MaterialType.transparency,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: SizedBox(
                              height: height * 0.3,
                              child: Image.asset(
                                "${question['data'][currentIndex]['image']}",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Options Grid
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: question['data'][currentIndex]['data'].length,
                        itemBuilder: (context, index) {
                          final option = question['data'][currentIndex]['data'][index];
                          final isCorrect = index == question['data'][currentIndex]['correct'];

                          return GestureDetector(
                            onTap: () async {
                              if (isCorrect) {
                                setState(() {
                                  correctCount++;
                                });
                                await FirebaseManager.udpateObtainedMarks(
                                  drillType: widget.drillData['type'],
                                  obtained: correctCount,
                                );
                                goToNextQuestion();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(tr(AppText.tryAgain)),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: childPrimaryColor.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Hero(
                                tag: '${tr(AppText.option)}$currentIndex-$index',
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Image.asset(
                                      option['image'],
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.image_not_supported,
                                          size: 40,
                                          color: Colors.grey,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int correctCount;
  final int totalQuestions;

  const ResultScreen({
    super.key, 
    required this.correctCount, 
    required this.totalQuestions
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (correctCount / totalQuestions) * 100;
    String resultText;
    Color resultColor;
    IconData resultIcon;

    if (percentage >= 90) {
      resultText = tr(AppText.excellent);
      resultColor = Colors.green;
      resultIcon = Icons.emoji_events;
    } else if (percentage >= 70) {
      resultText = tr(AppText.greatJob);
      resultColor = Colors.blue;
      resultIcon = Icons.thumb_up;
    } else if (percentage >= 50) {
      resultText = tr(AppText.notBad);
      resultColor = Colors.orange;
      resultIcon = Icons.sentiment_satisfied;
    } else {
      resultText = tr(AppText.tryAgain);
      resultColor = Colors.red;
      resultIcon = Icons.sentiment_dissatisfied;
    }

    return SafeArea(
      child: Scaffold(
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
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Result Card
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: resultColor.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Icon
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: resultColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              resultIcon,
                              size: 80,
                              color: resultColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Result Text
                          Hero(
                            tag: tr(AppText.resultText),
                            child: Text(
                              resultText,
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: resultColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Score
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: childSecondaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Text(
                              "$correctCount / $totalQuestions ${tr(AppText.correct)}",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: childPrimaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Percentage
                          Text(
                            "${tr(AppText.percentage)} ${percentage.toStringAsFixed(2)}%",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Go Back Button
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context, 
                                '/exercise', 
                                (route) => false,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [childPrimaryColor, childSecondaryColor],
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: childPrimaryColor.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                tr(AppText.goBack),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}