import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  var isLoading = false.obs;

  TextEditingController currentPasswordC = TextEditingController();
  TextEditingController newPasswordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();

  void updatePassword() async {
    if (currentPasswordC.text.isNotEmpty &&
        newPasswordC.text.isNotEmpty &&
        confirmPasswordC.text.isNotEmpty) {
      if (newPasswordC.text == confirmPasswordC.text) {
        isLoading.value = true;
        try {
          String emailUser = FirebaseAuth.instance.currentUser!.email!;

          await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailUser, password: currentPasswordC.text);

          await FirebaseAuth.instance.currentUser! .updatePassword(newPasswordC.text);

          Get.back();

          Get.snackbar("Berhasil", "Berhasil update password");
        } on FirebaseAuthException catch (e) {
          if (e.code == "wrong-password") {
            Get.snackbar("Terjadi Kesalahan", "Current password salah");
          } else {
            Get.snackbar("Terjadi Kesalahan", "${e.code.toLowerCase()}");
          }
        } catch (e) {
          Get.snackbar("Terjadi Kesalahan", "Tidak dapat update password");
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar("Terjadi Kesalahan", "Confrim password tidak cocok");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Semua input harus diisi");
    }
  }
}
