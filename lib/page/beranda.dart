import 'dart:convert';

import 'package:caleg/page/berita.dart';
import 'package:caleg/page/relawan.dart';
import 'package:caleg/page/relawan_daftar.dart';
import 'package:caleg/page/scan.dart';
import 'package:caleg/page/suara.dart';
import 'package:caleg/page/tps.dart';
import 'package:caleg/service/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  int idUser = 0;
  int? idAkses;
  String? tingkat;
  int? idPartai;

  String key = getKey();

  Future<void> getAkses() async {
    var result = await http
        .get(Uri.parse("${ApiStatus.baseUrl}/api/get-user-detil?key=$key"));

    if (result.statusCode == 200) {
      var data = await json.decode(result.body);

      if (mounted) {
        setState(() {
          idUser = data['id'] ?? 0;
          idAkses = data['id_akses'] ?? 0;
          tingkat = data['tingkat'] ?? "";
          idPartai = data['id_partai'] ?? 0;

          hapusLoader();
        });
      }
    } else {
      hapusLoader();
      errorPesan("Terjadi kegagalan koneksi, silahkan ulangi kembali.");
    }
  }

  @override
  void initState() {
    super.initState();
    getAkses();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /////// CALEG ///////
              if (idAkses == 4) ...[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => ScanPage(idUser));
                    },
                    child: Column(
                      children: const [
                        Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: Colors.black54,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Scan\nKTP',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      if (idPartai == 0 || tingkat == "") {
                        errorPesan(
                            "Silahkan melengkapi data profil terlebih dahulu.");
                      } else {
                        Get.to(() => const RelawanPage());
                      }
                    },
                    child: Column(
                      children: const [
                        Icon(
                          Icons.account_tree,
                          size: 50,
                          color: Colors.black54,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Struktur\nTim Sukses',
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      if (idPartai == 0 || tingkat == "") {
                        errorPesan(
                            "Silahkan melengkapi data profil terlebih dahulu.");
                      } else {
                        Get.to(() => const RelawanDaftarPage());
                      }
                    },
                    child: Column(
                      children: const [
                        Icon(
                          Icons.format_list_numbered,
                          size: 50,
                          color: Colors.black54,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Daftar\nTim Sukses',
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      if (idPartai == 0 || tingkat == "") {
                        errorPesan(
                            "Silahkan melengkapi data profil terlebih dahulu.");
                      } else {
                        Get.to(() => const TpsPage());
                      }
                    },
                    child: Column(
                      children: const [
                        Icon(
                          Icons.real_estate_agent,
                          size: 50,
                          color: Colors.black54,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Daftar\nTPS',
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      if (idPartai == 0 || tingkat == "") {
                        errorPesan(
                            "Silahkan melengkapi data profil terlebih dahulu.");
                      } else {
                        Get.to(() => const BeritaPage());
                      }
                    },
                    child: Column(
                      children: const [
                        Icon(
                          Icons.newspaper,
                          size: 50,
                          color: Colors.black54,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Buat\nBerita',
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      if (idPartai == 0 || tingkat == "") {
                        errorPesan(
                            "Silahkan melengkapi data profil terlebih dahulu.");
                      } else {
                        Get.to(() => const SuaraPage());
                      }
                    },
                    child: Column(
                      children: const [
                        Icon(
                          Icons.list_alt,
                          size: 50,
                          color: Colors.black54,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Daftar\nSuara',
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              /////// KORD. PROPINSI ///////
              /////// KORD. KOTA ///////
              /////// KORD. KECAMATAN ///////
              /////// KORD. DESA ///////
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    if (idPartai == 0 || tingkat == "") {
                      errorPesan(
                          "Silahkan melengkapi data profil terlebih dahulu.");
                    } else {}
                  },
                  child: Column(
                    children: const [
                      Icon(
                        Icons.location_history_rounded,
                        size: 50,
                        color: Colors.black54,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Sebaran\nRelawan',
                        style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    if (idPartai == 0 || tingkat == "") {
                      errorPesan(
                          "Silahkan melengkapi data profil terlebih dahulu.");
                    } else {}
                  },
                  child: Column(
                    children: const [
                      Icon(
                        Icons.map,
                        size: 50,
                        color: Colors.black54,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Sebaran\nSuara',
                        style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                height: 200,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Statistik Pendukung",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 200,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Statistik Relawan",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 200,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Table(
                    columnWidths: const <int, TableColumnWidth>{
                      0: IntrinsicColumnWidth(flex: 100),
                      1: FixedColumnWidth(30),
                      2: IntrinsicColumnWidth(flex: 100),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    children: const <TableRow>[
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(
                              "TOTAL RELAWAN",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(
                              "10",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(
                              "NAMA CALEG",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(
                              "10",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(
                              "HAK AKSES",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(
                              "10",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'RELAWAN TERBARU',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'KEGIATAN',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                height: 200,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Foto Kegiatan 1"),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 200,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Foto Kegiatan 2"),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 200,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Foto Kegiatan 2"),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 200,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Foto Kegiatan 2"),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'RELAWAN PRODUKTIF',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'RELAWAN KURANG PRODUKTIF',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
