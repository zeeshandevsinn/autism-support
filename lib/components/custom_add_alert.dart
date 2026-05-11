import 'package:autism_support/utils/app_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future addAlert(BuildContext context, Widget form, title) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return SizedBox(
        height: 600,
        child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            title: Text(tr(AppText.add) + '$title'),
            content: form),
      );
    },
  );
}
