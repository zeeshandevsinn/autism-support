import 'package:autism_support/utils/app_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/custom_images.dart';
import '../../components/custom_text.dart';
import '../../components/custom_textfield.dart';
import '../../controller/services/firebase_auth_provider.dart';
import '../../spaces.dart';
import '../../utils/colors.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var form_key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<FirebaseAuthProvider>();
  }

  bool visible = false;
  bool visible1 = false;
  
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
          child: Builder(builder: (context) {
            var pro = context.watch<FirebaseAuthProvider>();
            return pro.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(parentPrimaryColor),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: form_key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back Button
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: parentPrimaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: parentPrimaryColor,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Logo and Title
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
                                    Icons.person_add_alt_rounded,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  tr(AppText.createAnAccount),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: parentPrimaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Please fill the details to continue",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Form Fields Container
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: parentPrimaryColor.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Full Name Field
                                _buildInputField(
                                  label: tr(AppText.name),
                                  hint: tr(AppText.enterYourName),
                                  controller: fullNameController,
                                  icon: Icons.person_outline,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Please enter your name";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                
                                // Email Field
                                _buildInputField(
                                  label: tr(AppText.email),
                                  hint: tr(AppText.email),
                                  controller: emailController,
                                  icon: Icons.mail_outline,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Please enter your email";
                                    }
                                    if (!val.contains('@')) {
                                      return "Please enter a valid email";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                
                                // Password Field
                                _buildPasswordField(
                                  label: tr(AppText.password),
                                  hint: tr(AppText.password),
                                  controller: passwordController,
                                  isVisible: visible1,
                                  onToggle: () {
                                    setState(() {
                                      visible1 = !visible1;
                                    });
                                  },
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Field is Empty";
                                    } else if (passwordController.text.length < 8) {
                                      return tr(AppText.passwordCharacterLengthAtLeast);
                                    } else if (!passwordController.text.contains('!') &&
                                        !passwordController.text.contains('@') &&
                                        !passwordController.text.contains('#') &&
                                        !passwordController.text.contains('\$') &&
                                        !passwordController.text.contains('%') &&
                                        !passwordController.text.contains('^') &&
                                        !passwordController.text.contains('&') &&
                                        !passwordController.text.contains('*') &&
                                        !passwordController.text.contains(')') &&
                                        !passwordController.text.contains('(')) {
                                      return '${tr(AppText.passwrodContainsMust)} {!@#\$%^&*()}';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                
                                // Confirm Password Field
                                _buildPasswordField(
                                  label: tr(AppText.confirmPassword),
                                  hint: tr(AppText.confirmPassword),
                                  controller: confirmPasswordController,
                                  isVisible: visible,
                                  onToggle: () {
                                    setState(() {
                                      visible = !visible;
                                    });
                                  },
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return tr(AppText.fieldIsEmpty);
                                    } else if (passwordController.text != confirmPasswordController.text) {
                                      return tr(AppText.passwordDidNotMatch);
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Sign Up Button
                          _buildGradientButton(
                            text: tr(AppText.sIGNUP),
                            onTap: () async {
                              if (form_key.currentState!.validate()) {
                                await pro.registerWithEmail(
                                  context,
                                  fullNameController.text.trim(),
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );
                              }
                            },
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                tr(AppText.haveAnAccountAlready),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  tr(AppText.logIn),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: parentPrimaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
          }),
        ),
      ),
    );
  }
  
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
              Icon(icon, size: 18, color: parentPrimaryColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: parentPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 16, color: parentTextColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: parentPrimaryColor.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: parentPrimaryColor.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: parentPrimaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: validator,
        ),
      ],
    );
  }
  
  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              const Icon(Icons.lock_outline, size: 18, color: parentPrimaryColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: parentPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          style: TextStyle(fontSize: 16, color: parentTextColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade50,
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                isVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade500,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: parentPrimaryColor.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: parentPrimaryColor.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: parentPrimaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: validator,
        ),
      ],
    );
  }
  
  Widget _buildGradientButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [parentPrimaryColor, parentSecondaryColor],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: parentPrimaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}