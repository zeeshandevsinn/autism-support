import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'services_screen.dart';

class CareTaker extends StatefulWidget {
  const CareTaker({super.key});

  @override
  State<CareTaker> createState() => _CareTakerState();
}

class _CareTakerState extends State<CareTaker>
    with SingleTickerProviderStateMixin {
  int selectedIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<String> names = [
    tr(AppText.services),
    tr(AppText.myFlashcards),
    tr(AppText.socialNarratives),
    tr(AppText.spinners),
    tr(AppText.affirmation),
    tr(AppText.positiveQuotes),
  ];

  final List<IconData> icons = [
    Icons.design_services,
    Icons.card_membership,
    Icons.people_outline,
    Icons.autorenew,
    Icons.favorite_border,
    Icons.format_quote,
  ];

  final List<Color> cardColors = [
    const Color(0xFF667EEA),
    const Color(0xFFF093FB),
    const Color(0xFF4FACFE),
    const Color(0xFF43E97B),
    const Color(0xFFFA709A),
    const Color(0xFFFFD700),
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

    if (names[index] == tr(AppText.services)) {
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => const ServicesScreen()),
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
                      "Care Taker",
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
            
            // Header with Icon
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
                      Icons.favorite,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Resources for Caretakers",
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
                        
                        return GestureDetector(
                          onTap: () => _onButtonTap(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isSelected
                                    ? [parentPrimaryColor, parentSecondaryColor]
                                    : [Colors.white, Colors.white],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? parentPrimaryColor.withOpacity(0.3)
                                      : Colors.grey.withOpacity(0.1),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: isSelected
                                    ? parentPrimaryColor
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
                                        : parentPrimaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    icons[index],
                                    size: 40,
                                    color: isSelected ? Colors.white : parentPrimaryColor,
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