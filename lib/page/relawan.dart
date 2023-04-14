import 'dart:convert';

import 'package:caleg/model/relawan.dart';
import 'package:caleg/page/relawan_edit.dart';
import 'package:caleg/page/relawan_kab.dart';
import 'package:caleg/page/relawan_kec.dart';
import 'package:caleg/page/relawan_kel.dart';
import 'package:caleg/service/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RelawanPage extends StatefulWidget {
  const RelawanPage({super.key});

  @override
  State<RelawanPage> createState() => _RelawanPageState();
}

class _RelawanPageState extends State<RelawanPage> {
  List<RelawanModel> dataList = [];
  String key = getKey();
  String tingkat = '';
  int userId = 0;

  Future getData() async {
    loadingData();
    dataList = [];

    var result = await http
        .get(Uri.parse("${ApiStatus.baseUrl}/api/caleg-relawan?key=$key"));

    if (result.statusCode == 200) {
      hapusLoader();

      setState(() {
        tingkat = json.decode(result.body)['tingkat'];
        userId = json.decode(result.body)['id_atasan'];
      });

      List relawan = json.decode(result.body)['data'];

      if (mounted) {
        for (var element in relawan) {
          setState(() {
            dataList.add(RelawanModel.fromJson(element));
          });
        }
      }

      return dataList;
    } else {
      var data = json.decode(result.body);
      hapusLoader();
      errorPesan(data['message']);
      Get.back();
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "STRUKTUR TIM SUKSES",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 11, 156, 1),
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
            child: GestureDetector(
              onTap: () async {
                var result = await Get.to(() => RelawanEditPage(0, userId));

                if (result != null) {
                  setState(() {
                    getData();
                  });
                }
              },
              child: const Icon(
                Icons.add,
                size: 24.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: Colors.black,
        ),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () async {
              if (tingkat == 'NASIONAL') {
                await Get.to(() => RelawanKabPage(dataList[index].id!));
                getData();
              }

              if (tingkat == 'PROPINSI') {
                await Get.to(() => RelawanKecPage(dataList[index].id!));
                getData();
              }

              if (tingkat == 'KABUPATEN/KOTA') {
                await Get.to(() => RelawanKelPage(dataList[index].id!));
                getData();
              }
            },
            contentPadding: const EdgeInsets.all(5),
            leading: dataList[index].foto != null
                ? SizedBox(
                    width: 50,
                    child: Image.memory(
                      base64.decode(
                          dataList[index].foto.toString().split(',').last),
                      fit: BoxFit.contain,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const Text('Loading foto...');
                      },
                    ),
                  )
                : SizedBox(
                    width: 50,
                    child: Image.asset(
                      'assets/images/noimage.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${dataList[index].nama}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "HP. 0${dataList[index].hp?.substring(2)}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                if (dataList[index].idAkses == 5)
                  Text(
                    "${dataList[index].propinsiWilayah}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                if (dataList[index].idAkses == 6)
                  Text(
                    dataList[index].kotaWilayah.toString().toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                if (dataList[index].idAkses == 7)
                  Text(
                    "KEC. ${dataList[index].kecamatanWilayah.toString().toUpperCase()}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                if (dataList[index].idAkses == 8)
                  Text(
                    dataList[index].desaWilayah.toString().toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                const SizedBox(height: 5),
                Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: IntrinsicColumnWidth(flex: 120),
                    1: FixedColumnWidth(10),
                    2: IntrinsicColumnWidth(flex: 100),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.top,
                  children: <TableRow>[
                    if (dataList[index].idAkses == 5) ...[
                      TableRow(
                        children: [
                          const TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text("Kord. Kota/Kab",
                                  style: TextStyle(fontSize: 12))),
                          const TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(":", style: TextStyle(fontSize: 12)),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(
                              "${dataList[index].kordKota.toString()} Orang",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text("Kord. Kecamatan",
                                  style: TextStyle(fontSize: 12))),
                          const TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(":", style: TextStyle(fontSize: 12)),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(
                              "${dataList[index].kordKecamatan.toString()} Orang",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text("Kord. Desa/Kel.",
                                  style: TextStyle(fontSize: 12))),
                          const TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(":", style: TextStyle(fontSize: 12)),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(
                              "${dataList[index].kordDesa.toString()} Orang",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (dataList[index].idAkses == 6) ...[
                      TableRow(
                        children: [
                          const TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text("Kord. Kecamatan",
                                  style: TextStyle(fontSize: 12))),
                          const TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(":", style: TextStyle(fontSize: 12)),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(
                              "${dataList[index].kordKecamatan.toString()} Orang",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text("Kord. Desa/Kel.",
                                  style: TextStyle(fontSize: 12))),
                          const TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(":", style: TextStyle(fontSize: 12)),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(
                              "${dataList[index].kordDesa.toString()} Orang",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (dataList[index].idAkses == 7)
                      TableRow(
                        children: [
                          const TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text("Kord. Desa/Kel.",
                                  style: TextStyle(fontSize: 12))),
                          const TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(":", style: TextStyle(fontSize: 12)),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(
                              "${dataList[index].kordDesa.toString()} Orang",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    TableRow(
                      children: [
                        const TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text("Kord. TPS",
                                style: TextStyle(fontSize: 12))),
                        const TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Text(":", style: TextStyle(fontSize: 12)),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Text(
                            "${dataList[index].kordTps.toString()} Orang",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text("Relawan",
                                style: TextStyle(fontSize: 12))),
                        const TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Text(":", style: TextStyle(fontSize: 12)),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Text(
                            "${dataList[index].relawan.toString()} Orang",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Text(
                            "Total Suara",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Text(
                            ":",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Text(
                            "${dataList[index].suara} Orang",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        var result = await Get.to(
                          () => RelawanEditPage(dataList[index].id!, userId),
                        );

                        if (result != null) {
                          setState(() {
                            getData();
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.dialog(
                          AlertDialog(
                            content: Text("Hapus ${dataList[index].nama} ?"),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Get.back();

                                  var result = await http.delete(Uri.parse(
                                      "${ApiStatus.baseUrl}/api/caleg-relawan-hapus?key=$key&id=${dataList[index].id}"));

                                  if (result.statusCode == 200) {
                                    pesanData('Data berhasil dihapus');
                                    getData();
                                  } else {
                                    var data = json.decode(result.body);
                                    hapusLoader();
                                    errorPesan(data['message']);
                                    Get.back();
                                  }
                                },
                                child: const Text(
                                  "YA",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text("BATAL"),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
