import 'package:autism_support/components/custom_appbar.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../controller/services/firebase_manager.dart';
import '../../../utils/colors.dart';
import '../../../utils/mood_data.dart';
import 'selected_mood_screen.dart';

class MoodTrackingScreen extends StatefulWidget {
  const MoodTrackingScreen({super.key});

  @override
  State<MoodTrackingScreen> createState() => _MoodTrackingScreenState();
}

class _MoodTrackingScreenState extends State<MoodTrackingScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = -1; // -1 means none selected
  bool isPressed = false;

  // Animation Controller
  late AnimationController _animationController;

  // List of mood with their respective emojis

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onCardTap(int index) {
    setState(() {
      selectedIndex = index;
    });

    // Trigger the animation if needed
  }

  double _calculateScale() {
    return 1 - _animationController.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppbar(
              title: tr(AppText.mood)
              // "Mood"
              ,
              route: '/child_dashboard',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20), // Adjust this value as needed
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (constraints.maxWidth < 600) {
                    // Mobile view - Use GridView with 2 columns
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 columns on mobile
                        childAspectRatio: 1, // Square shape
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: mood.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            await FirebaseManager.setCurrentMood(
                                name: mood[index]['name'],
                                emoji: mood[index]['emoji']);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MoodDetailScreen(
                                    emoji: mood[index]['emoji']!,
                                    moodName: mood[index]['name']!,
                                  ),
                                ));

                            // logic
                          },
                          onTapDown: (_) => _onCardTap(index),
                          onTapUp: (_) => _animationController.reverse(),
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _calculateScale(),
                                child: child,
                              );
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(55),
                                      ),
                                      color: selectedIndex == index
                                          ? secondaryColor
                                          : secondaryColor,
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        padding: const EdgeInsets.all(16.0),
                                        child: Center(
                                          child: Text(
                                            mood[index]['emoji']!,
                                            style: const TextStyle(
                                              fontSize: 50,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  mood[index]['name']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    // Tablet/Desktop view - Use GridView with 4 columns
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // 4 columns on tablet/desktop
                        childAspectRatio: 1, // Square shape
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: mood.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTapDown: (_) => _onCardTap(index),
                          onTapUp: (_) => _animationController.reverse(),
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _calculateScale(),
                                child: child,
                              );
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      color: selectedIndex == index
                                          ? secondaryColor
                                          : Colors.white,
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        padding: const EdgeInsets.all(16.0),
                                        child: Center(
                                          child: Text(
                                            mood[index]['emoji']!,
                                            style: const TextStyle(
                                              fontSize: 50,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  mood[index]['name']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
