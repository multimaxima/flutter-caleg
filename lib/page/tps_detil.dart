import 'dart:convert';

import 'package:caleg/model/nokab.dart';
import 'package:caleg/model/nokec.dart';
import 'package:caleg/model/nokel.dart';
import 'package:caleg/model/noprop.dart';
import 'package:caleg/page/map_kordinat.dart';
import 'package:caleg/service/service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class TpsDetilPage extends StatefulWidget {
  final int id;
  const TpsDetilPage(this.id, {super.key});

  @override
  State<TpsDetilPage> createState() => _TpsDetilPageState();
}

class _TpsDetilPageState extends State<TpsDetilPage> {
  late int id;

  String key = getKey();
  String baseKey = getBaseKey();
  String userUid = getUid();
  String userHp = getHp();
  final _formKey = GlobalKey<FormState>();
  bool submitted = false;

  final _id = TextEditingController();
  final _nomor = TextEditingController();
  final _nama = TextEditingController();
  final _alamat = TextEditingController();
  final _dusun = TextEditingController();
  final _rt = TextEditingController();
  final _rw = TextEditingController();
  final _noProp = TextEditingController();
  final _noKab = TextEditingController();
  final _noKec = TextEditingController();
  final _noKel = TextEditingController();
  final _propinsi = TextEditingController();
  final _kota = TextEditingController();
  final _kecamatan = TextEditingController();
  final _desa = TextEditingController();
  final _lat = TextEditingController();
  final _lng = TextEditingController();

  Position? _currentPosition;

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Lokasi Tidak Aktif',
          'Service lokasi tidak aktif. Silahkan mengaktifkan service terlebih dahulu');
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Lokasi Tidak Aktif', 'Izin lokasi tidak aktif');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Lokasi Tidak Aktif',
          'Izin lokasi tidak aktif secara permanen, silahkan akifkan service secara manual');
      return false;
    }
    return true;
  }

  Future<void> getData(int id) async {
    loadingData();
    var result = await http
        .get(Uri.parse("${ApiStatus.baseUrl}/api/tps-detil?key=$key&id=$id"));

    if (result.statusCode == 200) {
      hapusLoader();
      var data = json.decode(result.body);

      setState(() {
        _id.text = data['id'].toString();
        _nomor.text = data['nomor'].toString();
        _nama.text = data['nama'] ?? "";
        _alamat.text = data['alamat'] ?? "";
        _dusun.text = data['dusun'] ?? "";
        _rt.text = data['rt'] ?? "";
        _rw.text = data['rw'] ?? "";
        _noProp.text = data['noProp'] ?? "";
        _noKab.text = data['noKab'] ?? "";
        _noKec.text = data['noKec'] ?? "";
        _noKel.text = data['noKel'] ?? "";
        _propinsi.text = data['propinsi'] ?? "";
        _kota.text = data['kota'] ?? "";
        _kecamatan.text = data['kecamatan'] ?? "";
        _desa.text = data['desa'] ?? "";
        _lat.text = data['lat'] ?? "";
        _lng.text = data['lng'] ?? "";
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
    id = widget.id;

    if (id != 0) {
      getData(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          id == 0 ? "TAMBAH TPS" : "EDIT TPS",
          style: const TextStyle(
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
                if (_formKey.currentState!.validate() && submitted == false) {
                  submitted = true;
                  loadingData();

                  if (id == 0) {
                    var request = await http.post(
                      Uri.parse("${ApiStatus.baseUrl}/api/tps-baru"),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, String>{
                        "key": baseKey,
                        "uidKey": userUid,
                        "hpKey": userHp,
                        "nomor": _nomor.text,
                        "nama": _nama.text,
                        "alamat": _alamat.text,
                        "dusun": _dusun.text,
                        "rt": _rt.text,
                        "rw": _rw.text,
                        "no_prop": _noProp.text,
                        "no_kab": _noKab.text,
                        "no_kec": _noKec.text,
                        "no_kel": _noKel.text,
                        "lat": _lat.text,
                        "lng": _lng.text,
                      }),
                    );

                    if (request.statusCode == 200) {
                      submitted = false;
                      pesanData('TPS berhasil ditambahkan');
                      Get.back(result: "Ok");
                    } else {
                      var data = await json.decode(request.body);
                      submitted = false;
                      hapusLoader();
                      errorPesan(data['message']);
                    }
                  } else {
                    var request = await http.post(
                      Uri.parse("${ApiStatus.baseUrl}/api/tps-edit"),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, String>{
                        "key": baseKey,
                        "uidKey": userUid,
                        "hpKey": userHp,
                        "id": _id.text,
                        "nomor": _nomor.text,
                        "nama": _nama.text,
                        "alamat": _alamat.text,
                        "dusun": _dusun.text,
                        "rt": _rt.text,
                        "rw": _rw.text,
                        "no_prop": _noProp.text,
                        "no_kab": _noKab.text,
                        "no_kec": _noKec.text,
                        "no_kel": _noKel.text,
                        "lat": _lat.text,
                        "lng": _lng.text,
                      }),
                    );

                    if (request.statusCode == 200) {
                      submitted = false;
                      pesanData('TPS berhasil disimpan');
                      Get.back(result: "Ok");
                    } else {
                      var data = await json.decode(request.body);
                      submitted = false;
                      hapusLoader();
                      errorPesan(data['message']);
                    }
                  }
                } else {
                  hapusLoader();
                  errorPesan("DATA BELUM LENGKAP");
                }
              },
              child: const Icon(
                Icons.save,
                size: 24.0,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nomor,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "NOMOR TPS",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
              ),
              validator: (value) {
                if (value == "") {
                  return 'Nomor wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _nama,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "NAMA TPS",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _alamat,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "ALAMAT",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _dusun,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "DUSUN/LINGKUNGAN",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            const SizedBox(height: 5),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rt,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        labelText: "RT",
                        labelStyle: TextStyle(fontSize: 14),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: _rw,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        labelText: "RW",
                        labelStyle: TextStyle(fontSize: 14),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            DropdownSearch<PropModel>(
              asyncItems: (String filter) async {
                var response = await http.get(
                    Uri.parse("${ApiStatus.baseUrl}/api/propinsi?key=$key"));

                if (response.statusCode != 200) {
                  errorData();
                  return [];
                } else {
                  List propinsi = json.decode(response.body);
                  List<PropModel> propinsiList = [];

                  for (var element in propinsi) {
                    propinsiList.add(PropModel.fromJson(element));
                  }

                  return propinsiList;
                }
              },
              popupProps: PopupProps.dialog(
                itemBuilder: (context, item, isSelected) => ListTile(
                  title: Text(
                    '${item.nama}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                fit: FlexFit.loose,
              ),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "PROPINSI",
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _noProp.text = value?.noProp ?? "";
                  _propinsi.text = value?.nama ?? "";

                  _noKab.text = "";
                  _kota.text = "";
                  _noKec.text = "";
                  _kecamatan.text = "";
                  _noKel.text = "";
                  _desa.text = "";
                });
              },
              selectedItem: PropModel(
                noProp: _noProp.text,
                nama: _propinsi.text,
              ),
              dropdownBuilder: (context, selectedItem) => Text(
                selectedItem?.nama ?? "",
                style: const TextStyle(fontSize: 14),
              ),
              validator: (value) {
                if (value?.noProp == "") {
                  return 'Propinsi wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            DropdownSearch<KabModel>(
              asyncItems: (String filter) async {
                var response = await http.get(Uri.parse(
                    "${ApiStatus.baseUrl}/api/kota?key=$key&no_prop=${_noProp.text}"));

                if (response.statusCode != 200) {
                  errorData();
                  return [];
                } else {
                  List kota = json.decode(response.body);
                  List<KabModel> kotaList = [];

                  for (var element in kota) {
                    kotaList.add(KabModel.fromJson(element));
                  }

                  return kotaList;
                }
              },
              popupProps: PopupProps.dialog(
                itemBuilder: (context, item, isSelected) => ListTile(
                  title: Text(
                    '${item.nama}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                fit: FlexFit.loose,
              ),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "KOTA",
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _noKab.text = value?.noKab ?? "";
                  _kota.text = value?.nama ?? "";

                  _noKec.text = "";
                  _kecamatan.text = "";
                  _noKel.text = "";
                  _desa.text = "";
                });
              },
              selectedItem: KabModel(
                noKab: _noKab.text,
                nama: _kota.text,
              ),
              dropdownBuilder: (context, selectedItem) => Text(
                selectedItem?.nama ?? "",
                style: const TextStyle(fontSize: 14),
              ),
              validator: (value) {
                if (value?.noKab == "") {
                  return 'Kota wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            DropdownSearch<KecModel>(
              asyncItems: (String filter) async {
                var response = await http.get(Uri.parse(
                    "${ApiStatus.baseUrl}/api/kecamatan?key=$key&no_prop=${_noProp.text}&no_kab=${_noKab.text}"));

                if (response.statusCode != 200) {
                  errorData();
                  return [];
                } else {
                  List kecamatan = json.decode(response.body);
                  List<KecModel> kecamatanList = [];

                  for (var element in kecamatan) {
                    kecamatanList.add(KecModel.fromJson(element));
                  }

                  return kecamatanList;
                }
              },
              popupProps: PopupProps.dialog(
                itemBuilder: (context, item, isSelected) => ListTile(
                  title: Text(
                    '${item.nama?.toUpperCase()}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                fit: FlexFit.loose,
              ),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "KECAMATAN",
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _noKec.text = value?.noKec ?? "";
                  _kecamatan.text = value?.nama?.toUpperCase() ?? "";

                  _noKel.text = "";
                  _desa.text = "";
                });
              },
              selectedItem: KecModel(
                noKec: _noKec.text,
                nama: _kecamatan.text,
              ),
              dropdownBuilder: (context, selectedItem) => Text(
                selectedItem?.nama ?? "",
                style: const TextStyle(fontSize: 14),
              ),
              validator: (value) {
                if (value?.noKec == "") {
                  return 'Kecamatan wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            DropdownSearch<KelModel>(
              asyncItems: (String filter) async {
                var response = await http.get(Uri.parse(
                    "${ApiStatus.baseUrl}/api/desa?key=$key&no_prop=${_noProp.text}&no_kab=${_noKab.text}&no_kec=${_noKec.text}"));

                if (response.statusCode != 200) {
                  errorData();
                  return [];
                } else {
                  List desa = json.decode(response.body);
                  List<KelModel> desaList = [];

                  for (var element in desa) {
                    desaList.add(KelModel.fromJson(element));
                  }

                  return desaList;
                }
              },
              popupProps: PopupProps.dialog(
                itemBuilder: (context, item, isSelected) => ListTile(
                  title: Text(
                    '${item.nama?.toUpperCase()}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                fit: FlexFit.loose,
              ),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "DESA/KELURAHAN",
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _noKel.text = value?.noKel ?? "";
                  _desa.text = value?.nama?.toUpperCase() ?? "";
                });
              },
              selectedItem: KelModel(
                noKel: _noKel.text,
                nama: _desa.text,
              ),
              dropdownBuilder: (context, selectedItem) => Text(
                selectedItem?.nama ?? "",
                style: const TextStyle(fontSize: 14),
              ),
              validator: (value) {
                if (value?.noKel == "") {
                  return 'Desa/Kelurahan wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _lat,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "GARIS LINTANG",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
              ),
              readOnly: true,
              validator: (value) {
                if (value == "") {
                  return 'Garis Lintang wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _lng,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "GARIS BUJUR",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
              ),
              readOnly: true,
              validator: (value) {
                if (value == "") {
                  return 'Garis Bujur wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            _lat.text == ""
                ? SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      label: const Text('ISI KORDINAT OTOMATIS'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        elevation: 5,
                      ),
                      icon: const Icon(
                        Icons.location_pin,
                        size: 18,
                      ),
                      onPressed: () async {
                        loadingData();
                        await _getCurrentPosition().then(
                          (value) => {
                            _lat.text =
                                _currentPosition?.latitude.toString() ?? "",
                            _lng.text =
                                _currentPosition?.longitude.toString() ?? "",
                          },
                        );
                        hapusLoader();
                      },
                    ),
                  )
                : SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      label: const Text('KOORDINAT TPS'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        elevation: 5,
                      ),
                      icon: const Icon(
                        Icons.location_pin,
                        size: 18,
                      ),
                      onPressed: () async {
                        LatLng kordinat;
                        kordinat = LatLng(
                            double.parse(_lat.text), double.parse(_lng.text));
                        final result =
                            await Get.to(() => MapKordinat(kordinat));

                        setState(() {
                          if (result != null) {
                            _lat.text = result.latitude.toString();
                            _lng.text = result.longitude.toString();
                          }
                        });
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
