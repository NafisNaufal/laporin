import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laporin/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';

class PageIndexController extends GetxController {
  var pageIndex = 2.obs;

  void changePage(int i) async {
    print('click index=$i');
    pageIndex.value = i;
    switch (i) {
      case 0:
        Map<String, dynamic> dataResponse = await determinePosition();
        if (dataResponse["error"] != true) {
          Position position = dataResponse["position"];

          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          String address =
              "${placemarks[0].street} , ${placemarks[0].subLocality}, ${placemarks[0].locality}";

          await updatePosition(position, address);

          double distance = Geolocator.distanceBetween(
              -7.409820, 112.744579, position.latitude, position.longitude);

          await presensi(position, address, distance);
        } else {
          Get.snackbar("Terjadi Kesalahan", "${dataResponse['message']}");
        }
        break;
      case 1:
        Get.offAllNamed(Routes.LAPORAN);
        break;
      case 3:
        Get.offAllNamed(Routes.ACTIVITY);
        break;
      case 4:
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(
      Position position, String address, double distance) async {
    String uid = await FirebaseAuth.instance.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> collectionPresence =
        await FirebaseFirestore.instance
            .collection("pegawai")
            .doc(uid)
            .collection("presence");

    QuerySnapshot<Map<String, dynamic>> snapPresence =
        await collectionPresence.get();

    DateTime now = DateTime.now();
    String todayDocID = DateFormat.yMd().format(now).replaceAll("/", "-");

    String status = "Di luar area";

    if (distance <= 200) {
      status = "Di dalam area";
    }

    if (snapPresence.docs.length == 0) {
      await Get.defaultDialog(
          title: "Validasi Presensi",
          middleText:
              "Apakah anda yakin untuk mengisi daftar hadir (MASUK) sekarang?",
          actions: [
            OutlinedButton(onPressed: () => Get.back(), child: Text("CANCEL")),
            ElevatedButton(
                onPressed: () async {
                  await collectionPresence.doc(todayDocID).set({
                    "date": now.toIso8601String(),
                    "masuk": {
                      "date": now.toIso8601String(),
                      "lat": position.latitude,
                      "long": position.longitude,
                      "address": address,
                      "status": status,
                      "distance": distance,
                    },
                  });
                  Get.back();
                  Get.snackbar(
                      "Berhasil", "Anda telah mengisi daftar hadir (MASUK)");
                },
                child: Text("YA"))
          ]);
    } else {
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await collectionPresence.doc(todayDocID).get();

      if (todayDoc.exists == true) {
        Map<String, dynamic>? dataPresenceToday = todayDoc.data();
        if (dataPresenceToday?["keluar"] != null) {
          Get.snackbar("Terjadi Kesalahan",
              "Anda telah mengisi daftar hadir Masuk dan Keluar, tidak dapat presensi kembali", backgroundColor: Colors.white, colorText: Colors.black);
        } else {
          await Get.defaultDialog(
              title: "Validasi Presensi",
              middleText:
                  "Apakah anda yakin untuk mengisi daftar hadir (KELUAR) sekarang?",
              actions: [
                OutlinedButton(
                    onPressed: () => Get.back(), child: Text("TIDAK")),
                ElevatedButton(
                    onPressed: () async {
                      await collectionPresence.doc(todayDocID).update({
                        "date": now.toIso8601String(),
                        "keluar": {
                          "date": now.toIso8601String(),
                          "lat": position.latitude,
                          "long": position.longitude,
                          "address": address,
                          "status": status,
                          "distance": distance,
                        },
                      });
                      Get.back();
                      Get.snackbar("Berhasil",
                          "Anda telah mengisi daftar hadir (KELUAR)",backgroundColor: Colors.white, colorText: Colors.black);
                    },
                    child: Text("YA"))
              ]);
        }
      } else {
        await Get.defaultDialog(
            title: "Validasi Presensi",
            middleText:
                "Apakah anda yakin untuk mengisi daftar hadir (MASUK) sekarang?",
            actions: [
              OutlinedButton(
                  onPressed: () => Get.back(), child: Text("TIDAK")),
              ElevatedButton(
                  onPressed: () async {
                    await collectionPresence.doc(todayDocID).set({
                      "date": now.toIso8601String(),
                      "masuk": {
                        "date": now.toIso8601String(),
                        "lat": position.latitude,
                        "long": position.longitude,
                        "address": address,
                        "status": status,
                        "distance": distance,
                      },
                    });
                    Get.back();
                    Get.snackbar(
                        "Berhasil", "Anda telah mengisi daftar hadir (MASUK)",backgroundColor: Colors.white, colorText: Colors.black);
                  },
                  child: Text("YA"))
            ]);
      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = await FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection("pegawai").doc(uid).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address,
    });
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        return {
          "message": "Gagal mendapatkan posisi, izin menggunakan GPS ditolak",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message":
            "Gagal mendapatkan posisi, device anda menolak perizinan lokasi",
        "error": true,
      };
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return {
      "position": position,
      "message": "Berhasil mendapatkan posisi device",
      "error": false,
    };
  }
}
