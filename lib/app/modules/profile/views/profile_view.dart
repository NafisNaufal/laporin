import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:laporin/app/routes/app_pages.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import '../controllers/profile_controller.dart';
import '../../../controllers/page_index_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);
  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.data() !=null) {
            Map<String, dynamic> user = snapshot.data!.data()!;
            String defaultImage =
                "https://ui-avatars.com/api/?name=${user['name']}";

            SizedBox(
              height: 12,
            );

            return ListView(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.network(
                          user['profile'] != null
                              ? user['profile'] != ""
                                  ? user['profile']
                                  : defaultImage
                              : defaultImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "${user['name'].toUpperCase()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${user['email']}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 30,
                ),
                ListTile(
                  onTap: () =>
                      Get.toNamed(Routes.UPDATE_PROFILE, arguments: user),
                  leading: Icon(Icons.person),
                  title: Text("Update Profile"),
                ),
                ListTile(
                  onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                  leading: Icon(Icons.vpn_key),
                  title: Text("Update Password"),
                ),
                if (user["role"] == "admin")
                  ListTile(
                    onTap: () => Get.toNamed(Routes.ADD_PEGAWAI),
                    leading: Icon(Icons.person_add),
                    title: Text("Add Pegawai"),
                  ),
                ListTile(
                  onTap: () => controller.logOut(),
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("Gagal mendapatkan data user"),
            );
          }
        },
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
