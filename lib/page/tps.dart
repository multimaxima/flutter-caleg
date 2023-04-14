import 'dart:convert';

import 'package:caleg/model/tps.dart';
import 'package:caleg/page/tps_detil.dart';
import 'package:caleg/service/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TpsPage extends StatefulWidget {
  const TpsPage({super.key});

  @override
  State<TpsPage> createState() => _TpsPageState();
}

class _TpsPageState extends State<TpsPage> {
  List<TpsModel> dataList = [];
  String key = getKey();
  String tingkat = '';
  int userId = 0;

  Future getData() async {
    loadingData();
    dataList = [];

    var result =
        await http.get(Uri.parse("${ApiStatus.baseUrl}/api/tps?key=$key"));

    if (result.statusCode == 200) {
      hapusLoader();

      List tps = json.decode(result.body);

      if (mounted) {
        for (var element in tps) {
          setState(() {
            dataList.add(TpsModel.fromJson(element));
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
        toolbarHeight: 100,
        title: Column(
          children: [
            Text(
              "DAFTAR TPS",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 11, 156, 1),
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.filter,
                size: 24.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
            child: GestureDetector(
              onTap: () async {
                await Get.to(() => const TpsDetilPage(0));
                getData();
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
              var result =
                  await Get.to(() => TpsDetilPage(dataList[index].id!));

              if (result != null) {
                setState(() {
                  getData();
                });
              }
            },
            contentPadding: const EdgeInsets.all(5),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TPS NOMOR :  ${dataList[index].nomor}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (dataList[index].alamat != null)
                  Text(
                    dataList[index].alamat.toString().toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (dataList[index].dusun != null)
                        Text(
                          "${dataList[index].dusun.toString().toUpperCase()}, ",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      if (dataList[index].rt != null)
                        Text(
                          "RT. ${dataList[index].rt} RW. ${dataList[index].rw}",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  "DESA/KEL. ${dataList[index].desa.toString().toUpperCase()}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  "KECAMATAN ${dataList[index].kecamatan.toString().toUpperCase()}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  dataList[index].kota.toString().toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  "PROPINSI ${dataList[index].propinsi.toString().toUpperCase()}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
