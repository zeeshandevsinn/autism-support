import 'package:autism_support/utils/app_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final dynamic icon;
  final String? hinttext;
  final Widget? prefixIcon;
  final Widget? suffixicon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscureCharacter;
  final FormFieldValidator<String>? validator;
  final bool? enabled;

  const CustomTextfield(
      {super.key,
      this.icon,
      this.hinttext,
      this.prefixIcon,
      this.suffixicon,
      required this.controller,
      this.keyboardType,
      this.isObscureText = false,
      this.obscureCharacter,
      this.validator,
      this.enabled});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator ??
          (val) {
            if (val!.isEmpty) {
              return tr(AppText.fieldIsEmpty);
            }
            return null;
          },
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isObscureText!,
      enabled: enabled,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.purple, width: 1.0),
          borderRadius: BorderRadius.circular(6),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.purple, width: 1.0),
          borderRadius: BorderRadius.circular(6),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.purple, width: 1.0),
          borderRadius: BorderRadius.circular(6),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixicon,
        hintText: hinttext,
        hintStyle:
            const TextStyle(color: Colors.black38, fontWeight: FontWeight.w400),
      ),
    );
  }
}
