import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MoodDetailScreen extends StatelessWidget {
  final String emoji;
  final String moodName;

  const MoodDetailScreen({
    Key? key,
    required this.emoji,
    required this.moodName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: childBgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //  CustomAppbar(),
          // Larger container for the emoji
          const SizedBox(
            height: 50,
          ),
          Container(
            height: MediaQuery.of(context).size.height *
                0.6, // Increase the height here
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: childSecondaryColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(
                  fontSize: 100,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Text below the emoji
          Text(
            '${tr(AppText.todayIAmFeeling)}$moodName',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          // Container acting as a button
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                  context, '/child_dashboard'); // Return to the previous screen
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              decoration: BoxDecoration(
                color: childSecondaryColor, // Button color
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: Text(
                tr(AppText.ok)
                // 'OK'
                ,
                style: const TextStyle(
                  color: Colors.white, // Text color
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
