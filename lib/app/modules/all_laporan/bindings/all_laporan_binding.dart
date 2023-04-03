import 'package:get/get.dart';

import '../controllers/all_laporan_controller.dart';

class AllLaporanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllLaporanController>(
      () => AllLaporanController(),
    );
  }
}
