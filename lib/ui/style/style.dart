import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class AppStyle {
  failedSnakBar(String message) {
    return Get.showSnackbar(GetSnackBar(
      title: "Failed",
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
      message: message,
    ));
  }

  successSnakBar(String message) {
    return Get.showSnackbar(GetSnackBar(
      title: "Success",
      backgroundColor: Colors.blueAccent,
      duration: const Duration(seconds: 2),
      message: message,
    ));
  }

  showAlertDialog(
    BuildContext context, {
    required Function() continueFun,
    required String title,
    required String message,
  }) async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop();
        continueFun();
      },
    );
    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
      },
    );
  }
}
