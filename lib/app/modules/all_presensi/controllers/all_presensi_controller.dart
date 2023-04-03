import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllPresensiController extends GetxController {
  DateTime? start;
  DateTime end = DateTime.now();

  Future<QuerySnapshot<Map<String, dynamic>>> getAllPresence() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    if (start == null) {
      return await FirebaseFirestore.instance
          .collection("pegawai")
          .doc(uid)
          .collection("presence")
          .where("date", isLessThan: end.toIso8601String())
          .orderBy("date", descending: true)
          .get();
    } else {
      return await FirebaseFirestore.instance
          .collection("pegawai")
          .doc(uid)
          .collection("presence")
          .where("date", isGreaterThan: start!.toIso8601String())
          .where("date", isLessThan: end.add(Duration(days: 1)).toIso8601String())
          .orderBy("date", descending: true)
          .get();
    }
  }

  void pickDate (DateTime pickStart, DateTime pickEnd) {
    start = pickStart;
    end = pickStart;
    update();
    Get.back();
  }
}
