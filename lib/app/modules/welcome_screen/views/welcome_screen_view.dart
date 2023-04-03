import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:laporin/app/routes/app_pages.dart';

import '../controllers/welcome_screen_controller.dart';

class WelcomeScreenView extends GetView<WelcomeScreenController> {
  const WelcomeScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    /* --- ini UNTUK RESPONSIVE IMAGE --- */
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /* --- ini IMAGE --- */
            Image(
              image: const AssetImage("assets/images/security.png"),
              height: height * 0.6,
            ),
            Column(
              /* --- ini TITLE --- */
              children: const [
                Text(
                  "Laporin!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29.0),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Report an Accident",
                  style: TextStyle(fontSize: 17, letterSpacing: 2),
                ),
              ],
            ),
            Row(
              children: [
                /* --- ini LOGIN BUTTON --- */
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(Routes.LOGIN);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15.0)),
                      child: const Text("LOG IN")),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
