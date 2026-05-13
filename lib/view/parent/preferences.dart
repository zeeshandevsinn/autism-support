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
    parentPrimaryColor,
    parentSecondaryColor,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
  ];
  
  final List<Color> _secondaryColors = [
    parentSecondaryColor,
    parentPrimaryColor,
    Colors.purple,
    Colors.cyan,
    Colors.teal,
    Colors.pink,
    Colors.lime,
  ];

  Color? _selectedPrimaryColor;
  Color? _selectedSecondaryColor;
  Color? _savedPrimaryColor;
  Color? _savedSecondaryColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: parentBgColor,
      body: Column(
        children: [
          CustomAppbar(
            title: tr(AppText.preferences),
            route: '/parent_dashboard',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Primary Colors Section
                  Text(
                    tr(AppText.primaryColors),
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: parentPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _primaryColors.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPrimaryColor = color;
                          });
                        },
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: color,
                            border: Border.all(
                              color: _selectedPrimaryColor == color
                                  ? parentPrimaryColor
                                  : Colors.grey.shade300,
                              width: _selectedPrimaryColor == color ? 3 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _selectedPrimaryColor == color
                                ? [
                                    BoxShadow(
                                      color: parentPrimaryColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Secondary Colors Section
                  Text(
                    tr(AppText.secondaryColors),
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: parentPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _secondaryColors.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSecondaryColor = color;
                          });
                        },
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: color,
                            border: Border.all(
                              color: _selectedSecondaryColor == color
                                  ? parentPrimaryColor
                                  : Colors.grey.shade300,
                              width: _selectedSecondaryColor == color ? 3 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _selectedSecondaryColor == color
                                ? [
                                    BoxShadow(
                                      color: parentPrimaryColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Preview Section
                  if (_savedPrimaryColor != null || _savedSecondaryColor != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            parentPrimaryColor.withOpacity(0.05),
                            parentSecondaryColor.withOpacity(0.02),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: parentPrimaryColor.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preview:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: parentPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              if (_savedPrimaryColor != null)
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: _savedPrimaryColor,
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: _savedPrimaryColor!.withOpacity(0.3),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Primary',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (_savedPrimaryColor != null && _savedSecondaryColor != null)
                                const SizedBox(width: 12),
                              if (_savedSecondaryColor != null)
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: _savedSecondaryColor,
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: _savedSecondaryColor!.withOpacity(0.3),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Secondary',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  
                  const Spacer(),
                  
                  // Gradient Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Save Button with Gradient
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              if (_selectedPrimaryColor != null) {
                                _savedPrimaryColor = _selectedPrimaryColor;
                              }
                              if (_selectedSecondaryColor != null) {
                                _savedSecondaryColor = _selectedSecondaryColor;
                              }
                            });
                            
                            if (_selectedPrimaryColor != null || _selectedSecondaryColor != null) {
                              await FirebaseFirestore.instance
                                  .collection(ParentCollection)
                                  .doc(UserSession.getUID())
                                  .update({
                                "parentPrimaryColor": _savedPrimaryColor.toString(),
                                "parentSecondaryColor": _savedSecondaryColor.toString()
                              });

                              ToastUtil.showSuccessToast(
                                tr(AppText.yourColorsHasBeenUpdate)
                              );
                            } else {
                              ToastUtil.showErrorToast('Please select at least one color');
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
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
                              boxShadow: [
                                BoxShadow(
                                  color: parentPrimaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                tr(AppText.save),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Cancel Button with Border
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              // Reset to saved colors
                              if (_savedPrimaryColor != null) {
                                _selectedPrimaryColor = _savedPrimaryColor;
                              } else {
                                _selectedPrimaryColor = null;
                              }
                              if (_savedSecondaryColor != null) {
                                _selectedSecondaryColor = _savedSecondaryColor;
                              } else {
                                _selectedSecondaryColor = null;
                              }
                            });
                            ToastUtil.showErrorToast('Changes cancelled');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: parentPrimaryColor.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                tr(AppText.cancel),
                                style: TextStyle(
                                  color: parentPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}