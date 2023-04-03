import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:laporin/app/routes/app_pages.dart';

class HomeController extends GetxController {
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    yield* FirebaseFirestore.instance.collection("pegawai").doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamLastPresence() async* {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    yield* FirebaseFirestore.instance.collection("pegawai").doc(uid).collection("presence").orderBy("date", descending: true).limitToLast(5).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTodayPresence() async* {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    String todayID = DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");

    yield* FirebaseFirestore.instance.collection("pegawai").doc(uid).collection("presence").doc(todayID).snapshots();
  }
}