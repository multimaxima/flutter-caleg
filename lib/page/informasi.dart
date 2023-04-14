import 'dart:convert';

import 'package:caleg/service/service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

class InformasiPage extends StatefulWidget {
  const InformasiPage({super.key});

  @override
  State<InformasiPage> createState() => _InformasiPageState();
}

class _InformasiPageState extends State<InformasiPage> {
  String key = getKey();
  String? informasi;

  getData() async {
    loadingData();
    var result = await http
        .get(Uri.parse("${ApiStatus.baseUrl}/api/informasi?key=$key"));

    if (result.statusCode == 200) {
      hapusLoader();
      var data = json.decode(result.body);

      setState(() {
        informasi = data['informasi'] ?? "";
      });
    } else {
      hapusLoader();
      var data = json.decode(result.body);
      errorPesan(data["message"]);
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
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 11, 156, 1),
        title: const Text(
          "INFORMASI",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: informasi != null
            ? Html(
                data: informasi,
              )
            : Container(),
      ),
    );
  }
}
