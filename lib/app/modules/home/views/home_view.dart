import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laporin/app/controllers/page_index_controller.dart';
import 'package:laporin/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beranda"),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.data() !=null) {
            Map<String, dynamic> user = snapshot.data!.data()!;
            String defaultImage =
                "https://ui-avatars.com/api/?name=${user['name']}";

            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 75,
                        height: 75,
                        color: Colors.grey[200],
                        child: Image.network(
                          user['profile'] != null
                              ? user['profile'] != ""
                                  ? user['profile']
                                  : defaultImage
                              : defaultImage,
                          fit: BoxFit.cover,
                        ),
                        // child: Image.network(src),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          "${user['name']}",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            fontFamily: "SF Pro",
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.lightBlue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${user['job']}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Text(
                        "${user['nip']}",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 200,
                        child: Text(
                          user["address"] != null
                              ? "${user['address']}"
                              : "Belum ada lokasi",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200],
                  ),
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: controller.streamTodayPresence(),
                      builder: (context, snapshotToday) {
                        if (snapshotToday.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        Map<String, dynamic>? dataToday =
                            snapshotToday.data?.data();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text("Masuk"),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  dataToday?['masuk'] == null
                                      ? "-"
                                      : "${DateFormat.jms().format(DateTime.parse(dataToday?['masuk']['date']))}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 2,
                              height: 20,
                              color: Colors.black12,
                            ),
                            Column(
                              children: [
                                Text(
                                  "Keluar",
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  dataToday?['keluar'] == null
                                      ? "-"
                                      : "${DateFormat.jms().format(DateTime.parse(dataToday?['keluar']['date']))}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Colors.grey[300],
                  thickness: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "5 Hari Terakhir",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () => Get.toNamed(Routes.ALL_PRESENSI),

                      child: Text(
                        "Lihat Selengkapnya",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: controller.streamLastPresence(),
                    builder: (context, snapshotPresence) {
                      if (snapshotPresence.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshotPresence.data?.docs.length == 0 ||
                          snapshotPresence.data == null) {
                        return SizedBox(
                          height: 150,
                          child: Center(
                            child: Text("Belum ada history presensi"),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshotPresence.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data =
                              snapshotPresence.data!.docs[index].data();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[200],
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    Routes.DETAIL_PRESENSI,
                                    arguments: data,
                                  );
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Masuk",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(data['masuk']?['date'] == null
                                          ? "-"
                                          : "${DateFormat.jms().format(DateTime.parse(data['masuk']!['date']))}"),
                                      SizedBox(
                                        height: 10,
                                      ),
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
                                          ? "-"
                                          : "${DateFormat.jms().format(DateTime.parse(data['keluar']!['date']))}"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ],
            );
          } else {
            return Center(
              child: Text("Tidak dapat memuat data user"),
            );
          }
        },
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.flip,
        initialActiveIndex: 2,
        items: [
          TabItem(icon: Icons.fingerprint_rounded, title: 'Presensi'),
          TabItem(icon: Icons.report_rounded, title: 'Laporan'),
          TabItem(icon: Icons.home_rounded, title: 'Beranda'),
          TabItem(icon: Icons.history_rounded, title: 'Riwayat'),
          TabItem(icon: Icons.person_rounded, title: 'Profile'),
        ],
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
