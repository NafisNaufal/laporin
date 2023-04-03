import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laporin/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPasswordC = TextEditingController();

  var passwordVisible = true.obs;

  void passwordToggle() {
    passwordVisible.toggle();
  }

  void newPassword() async {
    if (newPasswordC.text.isNotEmpty) {
      if (newPasswordC.text != "password") {
        try {
          String email = FirebaseAuth.instance.currentUser!.email!;

          await FirebaseAuth.instance.currentUser!
              .updatePassword(newPasswordC.text);
          await FirebaseAuth.instance.signOut();

          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: newPasswordC.text,
          );

          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar("Terjadi Kesalahan", "Password terlalu lemah");
          }
        } catch (e) {
          Get.snackbar("terjadi Kesalahan",
              "Tidak dapat mengganti passord. Hubungi admin");
        }
      } else {
        Get.snackbar("Terjadi Kesalahan", "Password harus diubah");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Password baru wajib diisi");
    }
  }
}
