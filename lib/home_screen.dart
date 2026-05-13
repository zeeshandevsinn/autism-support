import 'package:autism_support/controller/services/base.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:autism_support/utils/toast/toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = -1;
  bool isPressed = false;
  int counter = 5;
  int _hoveredIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  void _showLanguagePopup() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: parentPrimaryColor.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        parentPrimaryColor, // Deep Navy (#0F172A)
                        parentSecondaryColor, // Ocean Blue (#0284C7)
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.language,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          tr(AppText.selectLanguage),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Language Options
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLanguageTile(
                        flag: '🇺🇸',
                        name: tr(AppText.english),
                        locale: 'en',
                        onTap: () {
                          context.setLocale(const Locale('en'));
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildLanguageTile(
                        flag: '🇵🇰',
                        name: tr(AppText.urdu),
                        locale: 'ur',
                        onTap: () {
                          context.setLocale(const Locale('ur'));
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                // Cancel Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        tr(AppText.cancel),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageTile({
    required String flag,
    required String name,
    required String locale,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: parentPrimaryColor, size: 16),
          ],
        ),
      ),
    );
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
              // Custom App Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo or Title
                    Text(
                      'Autism Support',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: parentPrimaryColor,
                        letterSpacing: 1,
                      ),
                    ),
                    // Language Button
                    GestureDetector(
                      onTap: _showLanguagePopup,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: parentPrimaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.language,
                          color: parentPrimaryColor,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Welcome Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Autism Support App',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: parentPrimaryColor,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select your role to continue',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              // Role Selection
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Child Card
                      _buildRoleCard(
                        title: tr(AppText.child),
                        imagePath: 'assets/child.jpeg',
                        onTap: () {
                          Navigator.pushNamed(context, "/child_dashboard");
                        },
                        color: childPrimaryColor,
                        isChild: true,
                      ),
                      const SizedBox(width: 30),
                      // Parent Card
                      _buildRoleCard(
                        title: tr(AppText.parent),
                        imagePath: 'assets/caretaker.jpeg',
                        onTap: () {
                          if (UserSession.getUID() != null) {
                            setState(() {
                              counter--;
                              ToastUtil.showSuccessToast(
                                  '${tr(AppText.click)} $counter ${tr(AppText.timesToEnterParentMode)}');
                            });
                            if (counter == 0) {
                              counter = 5;
                              setState(() {
                                ToastUtil.showSuccessToast(
                                    tr(AppText.youreNowInParentMode));
                              });
                              Navigator.pushNamed(context, "/parent_dashboard");
                            }
                          } else {
                            Navigator.pushNamed(context, "/signin");
                          }
                        },
                        color: parentPrimaryColor,
                        isChild: false,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Footer
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  '© 2024 Autism Support App',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
    required Color color,
    required bool isChild,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 140,
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              color.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color,
                    color.withOpacity(0.7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            // Subtitle for Parent
            if (!isChild)
              Text(
                '${tr(AppText.click)} $counter ${tr(AppText.timesToEnterParentMode)}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
