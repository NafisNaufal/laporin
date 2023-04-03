import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPegawaiController extends GetxController {
  var isLoading = false.obs;

  var passwordVisible = true.obs;

  void passwordToggle() {
    passwordVisible.toggle();
  }

  TextEditingController nameC = TextEditingController();
  TextEditingController jobC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordAdminC = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> prosesAddPegawai() async {
    if (passwordAdminC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        String emailAdmin = FirebaseAuth.instance.currentUser!.email!;

        final adminCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passwordAdminC.text,
        );

        final pegawaiCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;

          await db.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "job": jobC.text,
            "email": emailC.text,
            "uid": uid,
            "role": "pegawai",
            "createdAt": DateTime.now().toIso8601String(),
          });

          await pegawaiCredential.user!.sendEmailVerification();

          await FirebaseAuth.instance.signOut();

          final adminCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passwordAdminC.text,
          );

          Get.back(); //tutup dialog
          Get.back(); //kembali ke home
          Get.snackbar("Berhasil", "Berhasil menambahkan pegawai");
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar(
              "Terjadi Kesalahan", "Password yang digunakan terlalu singkat");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Terjadi Kesalahan", "Pegawai sudah terdaftar");
        } else if (e.code == "wrong-password") {
          Get.snackbar(
              "Terjadi Kesalahan", "Admin tidak dapat login. Password salah");
        } else if (e.code == "invalid-email") {
          Get.snackbar("Terjadi Kesalahan", "Masukkan email dengan benar");
        } else {
          Get.snackbar("Terjadi kesalahan", "$e.code");
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "$e.code");
      } finally {
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      Get.snackbar(
          "Terjadi Kesalahan", "Password wajib diisi untuk keperluan validasi");
    }
  }

  Future<void> addPegawai() async {
    if (nameC.text.isNotEmpty && nipC.text.isNotEmpty && emailC.text.isNotEmpty && jobC.text.isNotEmpty) {
      await FirebaseAuth.instance.signOut();
      Get.defaultDialog(
        title: "Validasi Admin",
        content: Column(
          children: [
            const Text("Masukkan password untuk validasi admin"),
            SizedBox(
              height: 15,
            ),
            Obx(
              () => TextField(
                controller: passwordAdminC,
                obscureText: passwordVisible.value,
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      passwordToggle();
                    },
                  ),
                ),
              ),
            )
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              isLoading.value = false;
              Get.back();
            },
            child: Text("CANCEL"),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                isLoading.value = false;
                if (isLoading.isFalse) {
                  await prosesAddPegawai();
                }
              },
              child: Text(isLoading.isFalse ? "ADD PEGAWAI" : "LOADING..."),
            ),
          ),
        ],
      );
    } else {
      Get.snackbar("Terjadi Kesalahan", "NIP, nama, job, dan email harus diisi");
    }
  }
}
