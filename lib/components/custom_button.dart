import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final text;
  final ontap, icon, color;
   const CustomButton({super.key, this.text, this.ontap , this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: ontap,
        child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: color,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 3),
                  ),
                ]),
            child: Icon(
              icon,
              color: Colors.white,
            )),
      ),
    );
  }
  }
