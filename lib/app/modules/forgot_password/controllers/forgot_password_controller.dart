import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordController extends GetxController {
  var isLoading = false.obs;

  TextEditingController emailC = TextEditingController();

  void sendEmail() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailC.text);
        Get.snackbar("Berhasil", "Silahkan periksa email anda");
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat mengirim email reset password");
      } finally {
        isLoading.value = false;
      }
    }
  }
}
