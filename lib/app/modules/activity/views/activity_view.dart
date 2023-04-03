import 'package:flutter/material.dart';
import 'package:laporin/app/controllers/page_index_controller.dart';
import 'package:get/get.dart';
import 'package:laporin/app/routes/app_pages.dart';
import '../controllers/activity_controller.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class ActivityView extends GetView<ActivityController> {
  ActivityView({Key? key}) : super(key: key);
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 300, horizontal: 40),
          child: GridView(
            children: [
              InkWell(
                onTap: () => Get.toNamed(Routes.ALL_PRESENSI),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.white,
                        size: 35,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Riwayat Absensi",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),


              InkWell(
                onTap: () => Get.toNamed(Routes.ALL_LAPORAN),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.file_copy_rounded,
                        color: Colors.white,
                        size: 35,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Riwayat Laporan",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 25),
          ),
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.flip,
        initialActiveIndex: pageC.pageIndex.value,
        items: [
          TabItem(icon: Icons.fingerprint, title: 'Presensi'),
          TabItem(icon: Icons.report, title: 'Laporan'),
          TabItem(icon: Icons.home_rounded, title: 'Beranda'),
          TabItem(icon: Icons.history_rounded, title: 'Riwayat'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
