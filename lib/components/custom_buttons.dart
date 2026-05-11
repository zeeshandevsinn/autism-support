import 'package:autism_support/utils/colors.dart';
import 'package:autism_support/view/submit_screen.dart';
import 'package:flutter/material.dart';

class CustomButtons extends StatelessWidget {
  final text;
  const CustomButtons({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 9),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SubmitScreen()));
        },
        child: Container(
            height: 49,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: primaryColor),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            )),
      ),
    );
  }
}

class CustomButton2 extends StatelessWidget {
  final text, color, onPressed;
  const CustomButton2({super.key, this.color, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          fixedSize: const Size(95, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: color),
        ));
  }
}
