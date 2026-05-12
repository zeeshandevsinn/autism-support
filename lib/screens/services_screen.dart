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
  int selectedIndex = -1; // -1 means none selected
  bool isPressed = false;

  // Animation Controller
  late AnimationController _animationController;

  // List of names
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

  void _onButtonTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    if (names[index] == tr(AppText.headBanging)
        // 'Head banging'
        ) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VideoSliderScreen()),
      );
    }

    // Trigger the animation
  }

  double _calculateScale() {
    return 1 - _animationController.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: commonBgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(4, 4),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.cyan),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white)),
                ),
              ),
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // Define a breakpoint for switching between ListView and GridView
                if (constraints.maxWidth < 600) {
                  // Mobile view - Use ListView
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: names.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTapDown: (_) => _onButtonTap(index),
                            onTapUp: (_) {
                              _animationController.reverse();
                            },
                            child: AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _calculateScale(),
                                  child: child,
                                );
                              },
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selectedIndex == index
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: const Offset(4, 4),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: selectedIndex == index
                                        ? Colors.blueAccent
                                        : Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'images/caretaker.jpeg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            names[index],
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Tablet/Desktop view - Use GridView
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: names.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTapDown: (_) => _onButtonTap(index),
                            onTapUp: (_) {
                              _animationController.reverse();
                            },
                            child: AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _calculateScale(),
                                  child: child,
                                );
                              },
                              child: Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selectedIndex == index
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: const Offset(4, 4),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: selectedIndex == index
                                        ? Colors.blueAccent
                                        : Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'images/caretaker.jpeg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            names[index],
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
