import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:laporin/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    /* --- ini UNTUK RESPONSIVE IMAGE --- */
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* --- ini TITLE --- */
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image(
                      image: const AssetImage("assets/images/security.png"),
                      height: size.height * 0.2,
                    ),
                  ],
                ),
                const Text(
                  "Welcome",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
                ),
                SizedBox(
                  height: 8,
                ),
                const Text("Make it work, make it right, make it fast"),

                /* --- ini FORM ---*/
                Form(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _emailField(),
                        const SizedBox(
                          height: 10,
                        ),
                        _passwordField(),
                        const SizedBox(
                          height: 20.0,
                        ),
                        _loginButton(),
                        const SizedBox(
                          height: 10.0,
                        ),
                        _forgotPassword(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailField() {
    return TextField(
      autocorrect: false,
      controller: controller.emailC,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person_outline_outlined),
        labelText: "Email",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _passwordField() {
    return Obx(
      () => TextField(
        autocorrect: false,
        controller: controller.passwordC,
        obscureText: controller.passwordVisible.value,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outlined),
          labelText: "Password",
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(
              controller.passwordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            onPressed: () {
              controller.passwordToggle();
            },
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => ElevatedButton(
          onPressed: () async {
            if (controller.isLoading.isFalse) {
              await controller.login();
            }
          },
          child: Text(controller.isLoading.isFalse ? "LOG IN" : "LOADING..."),
        ),
      ),
    );
  }

  Widget _forgotPassword() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
        child: Text(
          "Lupa password?",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
