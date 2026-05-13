import 'dart:io';

import 'package:autism_support/components/custom_buttons.dart';
import 'package:autism_support/components/custom_text.dart';
import 'package:autism_support/components/custom_textfield.dart';
import 'package:autism_support/controller/services/firebase_manager.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:autism_support/utils/spaces.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddFamilyScreen extends StatefulWidget {
  const AddFamilyScreen({super.key});

  @override
  State<AddFamilyScreen> createState() => _AddFamilyScreenState();
}

class _AddFamilyScreenState extends State<AddFamilyScreen> {
  final formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var relationController = TextEditingController();
  File? _image;

  Future getImage() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxHeight: 1800, maxWidth: 1800);

    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      _image = imageTemporary;
    });
  }

  var keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 50,
        vertical: 24,
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            width: isSmallScreen ? screenSize.width - 32 : 600,
            constraints: BoxConstraints(
              maxHeight: screenSize.height * 0.9,
              minHeight: 500,
            ),
            decoration: BoxDecoration(
              color: parentBgColor,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Gradient Header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallScreen ? 20 : 24,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            parentPrimaryColor,
                            parentSecondaryColor,
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          // Profile Image with better design
                          Center(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: isSmallScreen ? 50 : 55,
                                    backgroundImage: _image != null
                                        ? kIsWeb
                                            ? NetworkImage(Uri.parse(_image!.path).toString())
                                            : Image.file(_image!).image
                                        : null,
                                    child: _image == null
                                        ? Icon(
                                            Icons.person_rounded,
                                            size: isSmallScreen ? 40 : 45,
                                            color: Colors.white54,
                                          )
                                        : null,
                                  ),
                                ),
                                Positioned(
                                  bottom: -5,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      onPressed: getImage,
                                      icon: Icon(
                                        Icons.add_circle_rounded,
                                        size: isSmallScreen ? 32 : 35,
                                        color: parentPrimaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            tr(AppText.familymember),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 18 : 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            tr(AppText.yourProfile),
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isSmallScreen ? 11 : 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Form Fields
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name Field
                            _buildInputField(
                              label: tr(AppText.name),
                              hint: tr(AppText.enterName),
                              controller: nameController,
                              icon: Icons.person_outline,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return tr(AppText.pleaseEnterYourName);
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            
                            // Relation Field
                            _buildInputField(
                              label: tr(AppText.relation),
                              hint: tr(AppText.enterRelation),
                              controller: relationController,
                              icon: Icons.family_restroom_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return tr(AppText.pleaseEnterYourRelation);
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 30),
                            
                            // Action Buttons
                            Row(
                              children: [
                                // Cancel Button
                                Expanded(
                                  child: _buildCancelButton(),
                                ),
                                const SizedBox(width: 12),
                                
                                // Save Button
                                Expanded(
                                  child: _buildSaveButton(),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  // Custom Input Field Widget
  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: parentPrimaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: parentPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: parentPrimaryColor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: 16,
              color: parentTextColor,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: parentPrimaryColor.withOpacity(0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: parentPrimaryColor.withOpacity(0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: parentPrimaryColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
  
  // Cancel Button Widget
  Widget _buildCancelButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            tr(AppText.cancel),
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
  
  // Save Button Widget
  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: () async {
        if (formKey.currentState!.validate()) {
          if (_image == null) {
            // Show error if no image selected
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(tr(AppText.yourProfile)),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }
          
          await FirebaseManager.addFamilyMemberDB(
            name: nameController.text.trim(),
            relation: relationController.text.trim(),
            image: _image!,
          );
          Navigator.pop(context);
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
          borderRadius: BorderRadius.circular(16),
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
    );
  }
}