import 'package:autism_support/components/custom_appbar.dart';
import 'package:autism_support/controller/services/base.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:autism_support/utils/toast/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final List<Color> _primaryColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
  ];
  final List<Color> _secondaryColors = [
    Colors.purple,
    Colors.cyan,
    Colors.teal,
    Colors.pink,
    Colors.lime,
    Colors.black
  ];

  Color? _selectedPrimaryColor;
  Color? _selectedSecondaryColor;
  Color? _savedPrimaryColor;
  Color? _savedSecondaryColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(
            title: tr(AppText.preferences)
            //  "Preferences"
            ,
            route: '/parent_dashboard',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(AppText.primaryColors)
                    // 'Primary Colors:'
                    ,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 10,
                    children: _primaryColors.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPrimaryColor = color;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: color,
                            border: Border.all(
                              color: _selectedPrimaryColor == color
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    tr(AppText.secondaryColors)
                    // 'Secondary Colors:'
                    ,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 10,
                    children: _secondaryColors.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSecondaryColor = color;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: color,
                            border: Border.all(
                              color: _selectedSecondaryColor == color
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  // Display the saved color containers if any color is saved
                  if (_savedPrimaryColor != null ||
                      _savedSecondaryColor != null)
                    Column(
                      children: [
                        if (_savedPrimaryColor != null)
                          Container(
                            padding: const EdgeInsets.all(50.0),
                            color: _savedPrimaryColor,
                          ),
                        const SizedBox(height: 10),
                        if (_savedSecondaryColor != null)
                          Container(
                            padding: const EdgeInsets.all(50.0),
                            color: _savedSecondaryColor,
                          ),
                      ],
                    ),
                  const Spacer(), // Pushes buttons to the bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            if (_selectedPrimaryColor != null) {
                              _savedPrimaryColor = _selectedPrimaryColor;
                            }
                            if (_selectedSecondaryColor != null) {
                              _savedSecondaryColor = _selectedSecondaryColor;
                            }
                          });
                          await FirebaseFirestore.instance
                              .collection(ParentCollection)
                              .doc(UserSession.getUID())
                              .update({
                            "primaryColor": _savedPrimaryColor.toString(),
                            "secondayColor": _savedSecondaryColor.toString()
                          });

                          ToastUtil.showSuccessToast(
                              tr(AppText.yourColorsHasBeenUpdate)
                              // "Your Colors Has been Update"
                              );
                          primaryColor = _savedPrimaryColor!;
                          secondaryColor = _savedSecondaryColor!;
                        },
                        child: Text(tr(AppText.save)
                            // 'Save'
                            ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Cancel the saved color
                            if (_savedPrimaryColor != null) {
                              _savedPrimaryColor = null;
                            }
                            if (_savedSecondaryColor != null) {
                              _savedSecondaryColor = null;
                            }
                            // Clear the selected colors
                            _selectedPrimaryColor = null;
                            _selectedSecondaryColor = null;
                          });
                        },
                        child: Text(tr(AppText.cancel)
                            // 'Cancel'
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
