import 'package:autism_support/components/custom_appbar.dart';
import 'package:autism_support/controller/services/base.dart';
import 'package:autism_support/controller/services/firebase_manager.dart';
import 'package:autism_support/utils/app_text.dart';
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
  var correctCount; // Track the score
  var data;

  void goToNextQuestion() {
    print("curre t $correctCount / $currentIndex");
    if (currentIndex < widget.drillData['data'].length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      submitExercise();
    }
  }

  var tab = false;

  void submitExercise() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
            correctCount: correctCount,
            totalQuestions: widget.drillData['data'].length),
      ),
    );
  }

  getObtain() async {
    data =
        await FirebaseManager.getObtainedMarks(type: widget.drillData['type']);
    setState(() {
      currentIndex = data;
      correctCount = currentIndex;

      if (correctCount == widget.drillData['data'].length) {
        submitExercise();
      } else {}
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getObtain();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.drillData;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(childCollection)
                .doc(UserSession.getUID())
                .collection('marks')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                    child: Text(tr(AppText.pleaseConsultWithYourParent)
                        // 'Please consult with your parent!'
                        ));
              }

              return data == null
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Expanded(
                        child: Column(
                          children: [
                            CustomAppbar(
                              route: '/exercise',
                              title: widget.drillData['type'].toString(),
                              trailing: Text(
                                "${currentIndex + 1}/${question['data'].length}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Hero(
                              tag: tr(AppText.question)
                                  // 'question'
                                  +
                                  '$currentIndex',
                              child: Material(
                                type: MaterialType.transparency,
                                child: SizedBox(
                                  height: height * 0.3,
                                  child: Image(
                                      image: AssetImage(
                                    "${question['data'][currentIndex]['image']}",
                                  )),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount:
                                    question['data'][currentIndex].length,
                                itemBuilder: (context, index) {
                                  final option = question['data'][currentIndex]
                                      ['data'][index];
                                  final isCorrect = index ==
                                      question['data'][currentIndex]['correct'];

                                  return GestureDetector(
                                    onTap: () async {
                                      setState(() async {
                                        if (isCorrect) {
                                          correctCount++;
                                          await FirebaseManager
                                              .udpateObtainedMarks(
                                                  drillType:
                                                      widget.drillData['type'],
                                                  obtained: correctCount);
                                          goToNextQuestion();
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(tr(AppText.tryAgain)
                                                  // "Try again!"
                                                  ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    child: Hero(
                                      tag: tr(AppText.option)
                                          //  'option'
                                          +
                                          '$currentIndex-$index',
                                      child: CircleAvatar(
                                        radius: 80,
                                        backgroundColor: Colors.grey[200],
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 100),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: tab == true
                                                    ? Colors.green
                                                    : Colors.transparent,
                                                width: 4),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(30),
                                            child: Image.asset(option['image']),
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
                      ));
            }),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int correctCount;
  final int totalQuestions;

  const ResultScreen(
      {super.key, required this.correctCount, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    double percentage = (correctCount / totalQuestions) * 100;
    String resultText;
    Color resultColor;

    if (percentage >= 90) {
      resultText = tr(AppText.excellent)
          //  "Excellent!"
          ;
      resultColor = Colors.green;
    } else if (percentage >= 70) {
      resultText = tr(AppText.greatJob)
          // "Great Job!"
          ;
      resultColor = Colors.blue;
    } else if (percentage >= 50) {
      resultText = tr(AppText.notBad)
          // "Not Bad!"
          ;
      resultColor = Colors.orange;
    } else {
      resultText = tr(AppText.tryAgain)
          // "Try Again!"
          ;
      resultColor = Colors.red;
    }

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: tr(AppText.resultText)
                //  "resultText"
                ,
                child: Text(
                  resultText,
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: resultColor),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "$correctCount / $totalQuestions" +
                    // " Correct"
                    tr(AppText.correct),
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                tr(AppText.percentage)
                    // "Percentage:"
                    +
                    "${percentage.toStringAsFixed(2)}%",
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/exercise'),
                child: Text(tr(AppText.goBack)
                    // "Go Back"
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
