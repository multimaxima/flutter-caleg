import 'dart:convert';

import 'package:caleg/model/relawan.dart';
import 'package:caleg/service/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RelawanDaftarPage extends StatefulWidget {
  const RelawanDaftarPage({super.key});

  @override
  State<RelawanDaftarPage> createState() => _RelawanDaftarPageState();
}

class _RelawanDaftarPageState extends State<RelawanDaftarPage> {
  List<RelawanModel> dataList = [];
  String key = getKey();

  Future getData() async {
    loadingData();
    dataList = [];

    var result = await http.get(
        Uri.parse("${ApiStatus.baseUrl}/api/caleg-relawan-daftar?key=$key"));

    if (result.statusCode == 200) {
      hapusLoader();

      List relawan = json.decode(result.body);

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
          "DAFTAR TIM SUKSES",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 11, 156, 1),
        elevation: 2,
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: Colors.black,
        ),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              // Get.to(() => RelawanKabPage(dataList[index].id!));
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
                  dataList[index].nama.toString().toUpperCase(),
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
                Text(
                  dataList[index].akses.toString().toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                if (dataList[index].idAkses == 5)
                  Text(
                    "PROPINSI ${dataList[index].propinsiWilayah}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                if (dataList[index].idAkses == 6) ...[
                  Text(
                    "${dataList[index].propinsiWilayah}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    dataList[index].kotaWilayah.toString().toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
                if (dataList[index].idAkses == 7) ...[
                  Text(
                    "PROPINSI ${dataList[index].propinsiWilayah}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    dataList[index].kotaWilayah.toString().toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "KEC. ${dataList[index].kecamatanWilayah.toString().toUpperCase()}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
                if (dataList[index].idAkses == 8) ...[
                  Text(
                    "PROPINSI ${dataList[index].propinsiWilayah}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    dataList[index].kotaWilayah.toString().toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "KEC. ${dataList[index].kecamatanWilayah.toString().toUpperCase()}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "DESA/KEL. ${dataList[index].desaWilayah.toString().toUpperCase()}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
                Text(
                  "SUARA = ${dataList[index].suara}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                if (dataList[index].idAkses != 4)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          // var result = await Get.to(
                          //   () => RelawanEditPage(dataList[index].id!, userId),
                          // );

                          // if (result != null) {
                          //   setState(() {
                          //     getData();
                          //   });
                          // }
                        },
                        child: Text("EDIT"),
                      ),
                      TextButton(
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
                        child: Text("HAPUS"),
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
