import 'dart:io';
import '../controllers/laporan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Laporan extends StatefulWidget {
  const Laporan({Key? key}) : super(key: key);

  @override
  State<Laporan> createState() => LaporanState();
}

class LaporanState extends State<Laporan> {
  // Image Picker
  File? _image;
  final picker = ImagePicker();

  TextEditingController dateC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController noTeleponC = TextEditingController();
  TextEditingController lokasiC = TextEditingController();
  TextEditingController deskripsiC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Get Gallery
  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Get.snackbar("Terjadi Kesalahan", "Tidak ada gambar yang dipilih");
      }
    });
  }

  // Get Camera
  Future getImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Get.snackbar("Terjadi Kesalahan", "Tidak ada gambar yang dipilih");
      }
    });
  }

  // State Date
  @override
  void initState() {
    super.initState();
    dateC.text = "";
  }

  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      getImageCamera();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.camera_alt_rounded),
                      title: Text("Kamera"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getImageGallery();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.photo_library_rounded),
                      title: Text("Galeri"),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Get.offAllNamed(Routes.HOME);
          },
        ),
        title: const Text('Laporan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  dialog(context);
                },
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.width * 1,
                    child: _image != null
                        ? ClipRRect(
                            child: Image.file(
                              _image!.absolute,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.black45,
                            ),
                          ),
                  ),
                ),
              ),
              Form(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      namapelapor(),
                      const SizedBox(
                        height: 15,
                      ),
                      _teleponpelapor(),
                      const SizedBox(
                        height: 15,
                      ),
                      _lokasikejaidan(),
                      const SizedBox(
                        height: 15,
                      ),
                      _tanggalkejadian(),
                      const SizedBox(
                        height: 15,
                      ),
                      _deskripsilaporan(),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.send_rounded),
                    label: Text(
                      "Submit",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () async {
                      await submitLaporan();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      fixedSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget namapelapor() {
    return TextField(
      controller: nameC,
      autocorrect: false,
      decoration: const InputDecoration(
        labelText: "Nama Pelapor",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _teleponpelapor() {
    return TextField(
      controller: noTeleponC,
      keyboardType: TextInputType.number,
      autocorrect: false,
      decoration: const InputDecoration(
        labelText: "No.Telp Pelapor",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _lokasikejaidan() {
    return TextField(
      controller: lokasiC,
      maxLines: 2,
      autocorrect: false,
      decoration: const InputDecoration(
        labelText: "Lokasi Kejadian",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _tanggalkejadian() {
    return TextField(
        controller: dateC,
        autocorrect: false,
        decoration: const InputDecoration(
          suffixIcon: Icon(Icons.calendar_month_rounded),
          labelText: "Tanggal Kejadian",
          border: OutlineInputBorder(),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            print(pickedDate);
            setState(() {
              dateC.text = DateFormat('MMMM-dd-yyyy').format(pickedDate);
            });
          }
        });
  }

  Widget _deskripsilaporan() {
    return TextField(
      controller: deskripsiC,
      maxLines: 7,
      autocorrect: false,
      decoration: const InputDecoration(
        labelText: "Deskripsi Laporan",
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> submitLaporan() async {
    if (nameC.text.isNotEmpty &&
        noTeleponC.text.isNotEmpty &&
        lokasiC.text.isNotEmpty &&
        deskripsiC.text.isNotEmpty &&
        dateC.text.isNotEmpty) {
      String uid = auth.currentUser!.uid;

      CollectionReference<Map<String, dynamic>> collectionLaporan =
          db.collection("pegawai").doc(uid).collection("laporan");
      DateTime now = DateTime.now();
      String todayDocID = DateFormat.yMd().format(now).replaceAll("/", "-");

      QuerySnapshot<Map<String, dynamic>> snapLaporan =
          await collectionLaporan.get();

      await Get.defaultDialog(
          title: "Validasi Laporan",
          middleText: "Apakah anda yakin ?",
          actions: [
            OutlinedButton(onPressed: () => Get.back(), child: Text("CANCEL")),
            ElevatedButton(
                onPressed: () async {
                  await collectionLaporan.doc(todayDocID).update({
                    now.toIso8601String(): {
                      "tanggal melapor": now.toIso8601String(),
                      "nama": nameC.text,
                      "no. telepon": noTeleponC.text,
                      "lokasi": lokasiC.text,
                      "tanggal": dateC.text,
                      "deskripsi": deskripsiC.text
                    }
                  });

                  Get.offAllNamed(Routes.HOME);
                  Get.snackbar("Berhasil", "Anda telah mengisi laporan");
                },
                child: Text("YA"))
          ]);
    } else {
      Get.snackbar("Terjadi Kesalahan", "Silahkan isi semua form");
    }
  }
}
