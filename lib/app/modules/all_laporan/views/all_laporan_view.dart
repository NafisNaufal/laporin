import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/all_laporan_controller.dart';

class AllLaporanView extends GetView<AllLaporanController> {
  const AllLaporanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AllLaporanView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AllLaporanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
