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
}
