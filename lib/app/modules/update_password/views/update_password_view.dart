import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPDATE PASSWORD'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.currentPasswordC,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Password Lama",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
           TextField(
            controller: controller.newPasswordC,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Password Baru",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
           TextField(
            controller: controller.confirmPasswordC,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Konfirmasi Password Baru",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.updatePassword();
                }
              },
              child: Text(controller.isLoading.isFalse ? "UBAH PASSWORD" : "LOADING..."),
            ),
          )
        ],
      ),
    );
  }
}
