import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showbar(String title, subtitle, desc, bool color) {
  Get.snackbar(title, subtitle,
      backgroundColor: color ? Colors.greenAccent : Colors.redAccent,
      snackPosition: SnackPosition.BOTTOM,
      messageText: Text(desc, style: const TextStyle(color: Colors.white)));
}
