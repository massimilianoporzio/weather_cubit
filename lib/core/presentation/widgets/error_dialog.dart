import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void errorDialog(BuildContext context, {String errorMsg = ''}) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(errorMsg),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  } else {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMsg),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
