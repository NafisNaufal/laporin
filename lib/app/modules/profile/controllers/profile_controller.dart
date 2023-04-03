import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laporin/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    yield* FirebaseFirestore.instance.collection("pegawai").doc(uid).snapshots();
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.WELCOME_SCREEN);
  }
}
