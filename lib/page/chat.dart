import 'dart:convert';

import 'package:caleg/model/relawan.dart';
import 'package:caleg/page/chat_detil.dart';
import 'package:caleg/service/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<RelawanModel> dataList = [];
  String key = getKey();
  String tingkat = "";

  Future getData() async {
    loadingData();

    dataList = [];

    var result =
        await http.get(Uri.parse("${ApiStatus.baseUrl}/api/chat?key=$key"));

    if (result.statusCode == 200) {
      hapusLoader();

      setState(() {
        tingkat = json.decode(result.body)['tingkat'];
      });

      if (mounted) {
        List relawan = json.decode(result.body)['data'];

        for (var element in relawan) {
          setState(() {
            dataList.add(RelawanModel.fromJson(element));
          });
        }

        return dataList;
      }
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white10,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
          ],
        ),
      ),
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: Colors.black,
        ),
        padding: const EdgeInsets.all(10),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Get.to(() => ChatDetilPage(dataList[index].id!));
            },
            contentPadding: const EdgeInsets.all(5),
            leading: dataList[index].foto != null
                ? SizedBox(
                    width: 35,
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
                    width: 35,
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
                  dataList[index].akses ?? "",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                if (dataList[index].idAkses == 5)
                  Text(
                    dataList[index].propinsiWilayah ?? "",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                if (dataList[index].idAkses == 6)
                  Text(
                    dataList[index].kotaWilayah ?? "",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                if (dataList[index].idAkses == 7)
                  Text(
                    "KECAMATAN ${dataList[index].kecamatanWilayah.toString().toUpperCase()}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                if (dataList[index].idAkses == 8) ...[
                  Text(
                    "${dataList[index].desaWilayah.toString().toUpperCase()}, KEC. ${dataList[index].kecamatanWilayah.toString().toUpperCase()}",
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}
