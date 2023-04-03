import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  DetailPresensiView({Key? key}) : super(key: key);
  final Map<String, dynamic> data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DETAIL PRESENSI'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "${DateFormat.yMMMMEEEEd().format(DateTime.parse(data['date']))}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Masuk",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    "Pukul : ${DateFormat.jms().format(DateTime.parse(data['masuk']!['date']))}"),
                SizedBox(
                  height: 5,
                ),
                Text(
                    "Posisi : ${data['masuk']!['lat']} , ${data['masuk']!['long']}"),
                SizedBox(
                  height: 5,
                ),
                Text("Status : ${data['masuk']!['status']}"),
                SizedBox(
                  height: 5,
                ),
                Text(
                    "Distance : ${data['masuk']!['distance'].toString().split(".").first} meter"),
                SizedBox(
                  height: 5,
                ),
                Text("Address : ${data['masuk']!['address']}"),
                SizedBox(
                  height: 20,
                ),

                // Keluar

                Text(
                  "Keluar",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(data['keluar']?['date'] == null
                    ? "Pukul : -"
                    : "Pukul : ${DateFormat.jms().format(DateTime.parse(data['keluar']!['date']))}"),
                SizedBox(
                  height: 5,
                ),
                Text(data['keluar']?['lat'] == null &&
                        data['keluar']?['long'] == null
                    ? "Posisi : -"
                    : "Posisi : ${data['keluar']!['lat']} , ${data['keluar']!['long']}"),
                SizedBox(
                  height: 5,
                ),
                Text(data['keluar']?['status'] == null
                    ? "Status : -"
                    : "Status : ${data['keluar']!['status']}"),
                SizedBox(
                  height: 5,
                ),
                Text(data['keluar']?['distance'] == null
                    ? "Distance : - "
                    : "Distance : ${data['keluar']!['distance'].toString().split(".").first} meter"),
                SizedBox(
                  height: 5,
                ),
                Text(data['keluar']?['address'] == null
                    ? "Address : -"
                    : "Address : ${data['keluar']!['address']}"),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }
}
