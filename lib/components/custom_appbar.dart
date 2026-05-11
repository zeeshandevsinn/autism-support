import 'package:autism_support/utils/colors.dart';
import 'package:flutter/material.dart';
import 'custom_button.dart';

class CustomAppbar extends StatelessWidget {
  final String? title;
  final Widget? trailing;
  final Color? color;
  final String? route;
  final double? textSize;

  const CustomAppbar(
      {super.key,
      this.title,
      this.trailing,
      this.color,
      this.route,
      this.textSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            if (route != null) {
              Navigator.pushNamed(context, route!);
            }
          },
          child: CustomButton(
              color: primaryColor, icon: Icons.arrow_back_ios_new_rounded),
        ),
        Center(
          child: Title(
              color: Colors.black,
              child: Text(
                title ?? "",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: textSize ?? 35),
              )),
        ),
        trailing ??
            Container(
              width: 40,
            )
      ],
    );
  }
}
