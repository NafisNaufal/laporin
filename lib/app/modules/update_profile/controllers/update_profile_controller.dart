import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateProfileController extends GetxController {
  var isLoading = false.obs;

  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  final ImagePicker picker = ImagePicker();

  XFile? image;

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    update();
  }

  Future<void> updateProfile(String uid) async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {"name": nameC.text};
        if (image != null) {
          File file = File(image!.path);
          // print(image!.name.split(".").last);

          await FirebaseStorage.instance.ref("$uid/profile.ext").putFile(file);
          String urlImage = await FirebaseStorage.instance
              .ref("$uid/profile.ext")
              .getDownloadURL();

          data.addAll({'profile': urlImage});
        }
        await FirebaseFirestore.instance
            .collection("pegawai")
            .doc(uid)
            .update(data);
        image = null;
        Get.back();
        Get.snackbar("Berhasil", "Update profile berhasil");
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Update profile gagal");
      } finally {
        isLoading.value = false;
      }
    }
  }

  void deleteProfile(String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection("pegawai")
          .doc(uid)
          .update({"profile": FieldValue.delete()});

      Get.back();
      Get.snackbar("Berhasil", "Berhasil menghapus profile picture");
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Tidak dapat menghapus profile photo");
    }
  }
}
