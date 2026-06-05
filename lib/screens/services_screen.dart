import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'viedo_slider_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<String> names = [
    tr(AppText.headBanging),
    tr(AppText.kickingAndHitting),
    tr(AppText.atThePlayground),
    tr(AppText.greetingPeople),
    tr(AppText.startingConversation),
    tr(AppText.myFamily),
    tr(AppText.takingCareOfMyHouse),
    tr(AppText.washingMyHands),
    tr(AppText.personalSpace),
    tr(AppText.understandingSadness),
    tr(AppText.positiveQuotes),
    tr(AppText.undersatndingFrustation),
    tr(AppText.whenIGetFrusstrated),
  ];

  final List<IconData> icons = [
    Icons.warning_amber_rounded,
    Icons.sports_kabaddi,
    Icons.park,
    Icons.people_outline,
    Icons.chat_bubble_outline,
    Icons.family_restroom,
    Icons.home_work,
    Icons.cleaning_services,
    Icons.space_dashboard,
    // Icons.sentiment_very_sad,
    Icons.format_quote,
    Icons.sentiment_dissatisfied,
    Icons.bolt,
  ];

  final List<Color> cardColors = [
    const Color(0xFFEF4444),
    const Color(0xFFF59E0B),
    const Color(0xFF10B981),
    const Color(0xFF3B82F6),
    const Color(0xFF6366F1),
    const Color(0xFFEC4899),
    const Color(0xFF14B8A6),
    const Color(0xFF8B5CF6),
    const Color(0xFF06B6D4),
    const Color(0xFFF97316),
    const Color(0xFF84CC16),
    const Color(0xFFD946EF),
    const Color(0xFFF43F5E),
  ];

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

  void _onButtonTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    if (names[index] == tr(AppText.headBanging)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VideoSliderScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              commonBgColor,
              Colors.white,
              parentSecondaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar with Back Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: parentPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: parentPrimaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "Services",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: parentPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Header Section
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [parentPrimaryColor, parentSecondaryColor],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: parentPrimaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.medical_services,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Support Services",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Services Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      int crossAxisCount = constraints.maxWidth < 600 ? 2 : 3;
                      
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.85,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        itemCount: names.length,
                        itemBuilder: (BuildContext context, int index) {
                          final isSelected = selectedIndex == index;
                          final color = cardColors[index % cardColors.length];
                          
                          return GestureDetector(
                            onTap: () => _onButtonTap(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [color, color.withOpacity(0.7)],
                                      )
                                    : const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Colors.white, Colors.white],
                                      ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected
                                        ? color.withOpacity(0.4)
                                        : Colors.grey.withOpacity(0.1),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                border: Border.all(
                                  color: isSelected
                                      ? color
                                      : parentSecondaryColor.withOpacity(0.2),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon Container
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white.withOpacity(0.2)
                                          : color.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      icons[index],
                                      size: 40,
                                      color: isSelected ? Colors.white : color,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Title
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      names[index],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.white : parentTextColor,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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