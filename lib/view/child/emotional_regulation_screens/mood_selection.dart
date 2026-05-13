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
  int selectedIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [
              childSecondaryColor.withOpacity(0.3),
              childBgColor,
              Colors.white,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppbar(
                title: tr(AppText.mood),
                route: '/child_dashboard',
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                    ),
                    itemCount: mood.length,
                    itemBuilder: (context, index) {
                      final moodItem = mood[index];
                      final isSelected = selectedIndex == index;
                      
                      return GestureDetector(
                        onTapDown: (_) {
                          setState(() {
                            selectedIndex = index;
                          });
                          _animationController.forward();
                        },
                        onTapUp: (_) {
                          _animationController.reverse();
                        },
                        onTap: () async {
                          await FirebaseManager.setCurrentMood(
                            name: moodItem['name'],
                            emoji: moodItem['emoji'],
                          );
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MoodDetailScreen(
                                  emoji: moodItem['emoji']!,
                                  moodName: moodItem['name']!,
                                ),
                              ),
                            );
                          }
                        },
                        child: AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: childPrimaryColor.withOpacity(0.3),
                                            blurRadius: 15,
                                            offset: const Offset(0, 8),
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.15),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      moodItem['emoji']!,
                                      style: TextStyle(
                                        fontSize: isSelected ? 70 : 60,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      moodItem['name']!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? childPrimaryColor
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}