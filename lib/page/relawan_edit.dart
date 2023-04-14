import 'dart:convert';
import 'dart:io';

import 'package:caleg/model/akses.dart';
import 'package:caleg/model/nokab.dart';
import 'package:caleg/model/nokec.dart';
import 'package:caleg/model/nokel.dart';
import 'package:caleg/model/noprop.dart';
import 'package:caleg/service/service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class RelawanEditPage extends StatefulWidget {
  final int id;
  final int idParent;
  const RelawanEditPage(this.id, this.idParent, {super.key});

  @override
  State<RelawanEditPage> createState() => _RelawanEditPageState();
}

class _RelawanEditPageState extends State<RelawanEditPage> {
  late int id;
  late int idParent;

  String key = getKey();
  String baseKey = getBaseKey();
  String userUid = getUid();
  String userHp = getHp();
  final _formKey = GlobalKey<FormState>();
  bool submitted = false;

  int idAkses = 0;
  String tingkat = "";
  String noPropWilayah = "";
  String noKabWilayah = "";
  String noKecWilayah = "";
  String noKelWilayah = "";

  final ImagePicker _picker = ImagePicker();
  File? foto;
  File? ktp;

  final _idParent = TextEditingController();
  final _id = TextEditingController();
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
  final _kodepos = TextEditingController();
  final _kelamin = TextEditingController();
  final _jenisKelamin = TextEditingController();
  final _tempLahir = TextEditingController();
  final _tglLahir = TextEditingController();
  final _tglLahir1 = TextEditingController();
  final _hp = TextEditingController();
  final _nik = TextEditingController();
  final _idAkses = TextEditingController();
  final _akses = TextEditingController();
  final _email = TextEditingController();
  final _foto = TextEditingController();
  final _ktp = TextEditingController();
  final _noPropWilayah = TextEditingController();
  final _noKabWilayah = TextEditingController();
  final _noKecWilayah = TextEditingController();
  final _noKelWilayah = TextEditingController();
  final _dusunWilayah = TextEditingController();
  final _rwWilayah = TextEditingController();
  final _rtWilayah = TextEditingController();
  final _propinsiWilayah = TextEditingController();
  final _kotaWilayah = TextEditingController();
  final _kecamatanWilayah = TextEditingController();
  final _desaWilayah = TextEditingController();

  Future<void> getData(int id, int idParent) async {
    loadingData();

    var result = await http.get(Uri.parse(
        "${ApiStatus.baseUrl}/api/caleg-relawan-detil?key=$key&id=$id&id_parent=$idParent"));

    if (result.statusCode == 200) {
      hapusLoader();

      var parent = json.decode(result.body)['parent'];

      setState(() {
        idAkses = parent['id_akses'];
        tingkat = parent['tingkat'];
        noPropWilayah = parent['no_prop_wilayah'] ?? "";
        noKabWilayah = parent['no_kab_wilayah'] ?? "";
        noKecWilayah = parent['no_kec_wilayah'] ?? "";
        noKelWilayah = parent['no_kel_wilayah'] ?? "";
      });

      if (id > 0) {
        var data = json.decode(result.body)['data'];

        setState(() {
          _idParent.text = idParent.toString();
          _id.text = data['id'].toString();
          _nama.text = data['nama'] ?? "";
          _alamat.text = data['alamat'] ?? "";
          _dusun.text = data['dusun'] ?? "";
          _rt.text = data['rt'] ?? "";
          _rw.text = data['rw'] ?? "";
          _noProp.text = data['no_prop'] ?? "";
          _noKab.text = data['no_kab'] ?? "";
          _noKec.text = data['no_kec'] ?? "";
          _noKel.text = data['no_kel'] ?? "";
          _propinsi.text = data['propinsi'] ?? "";
          _kota.text = data['kota'] ?? "";
          _kecamatan.text = data['kecamatan'] ?? "";
          _desa.text = data['desa'] ?? "";
          _kodepos.text = data['kodepos'] ?? "";
          _kelamin.text = data['kelamin'].toString();
          _jenisKelamin.text = data["kelamin"] == 1
              ? 'LAKI-LAKI'
              : data["kelamin"] == 2
                  ? 'PEREMPUAN'
                  : '';
          _tempLahir.text = data['temp_lahir'] ?? '';
          _tglLahir.text = data['tgl_lahir'] ?? '';
          _tglLahir1.text = _tglLahir.text != ""
              ? DateFormat("d MMMM yyyy", "id")
                  .format(DateTime.parse(_tglLahir.text))
              : DateFormat("d MMMM yyyy", "id").format(DateTime.now());
          _hp.text = data['hp'] ?? "";
          _nik.text = data['nik'] ?? "";
          _idAkses.text = data['id_akses'].toString();
          _akses.text = data['akses'] ?? "";
          _email.text = data['email'] ?? "";
          _foto.text = data['foto'] ?? "";
          _ktp.text = data['ktp'] ?? "";
          _noPropWilayah.text = data['no_prop_wilayah'] ?? "";
          _noKabWilayah.text = data['no_kab_wilayah'] ?? "";
          _noKecWilayah.text = data['no_kec_wilayah'] ?? "";
          _noKelWilayah.text = data['no_kel_wilayah'] ?? "";
          _dusunWilayah.text = data['dusun_wilayah'] ?? "";
          _rwWilayah.text = data['rw_wilayah'] ?? "";
          _rtWilayah.text = data['rt_wilayah'] ?? "";
          _propinsiWilayah.text = data['propinsi_wilayah'] ?? "";
          _kotaWilayah.text = data['kota_wilayah'] ?? "";
          _kecamatanWilayah.text = data['kecamatan_wilayah'] ?? "";
          _desaWilayah.text = data['desa_wilayah'] ?? "";
        });
      }
    } else {
      hapusLoader();
      errorData();
    }
  }

  Future getImage(ImageSource source, String jenis) async {
    loadingData();

    final pickedFile = await _picker.pickImage(
      maxWidth: 800,
      maxHeight: 800,
      source: source,
    );

    if (pickedFile == null) {
      hapusLoader();
      return;
    } else {
      hapusLoader();
      setState(() {
        if (pickedFile != null) {
          final file = File(pickedFile.path);
          final bytes = file.readAsBytesSync();

          if (jenis == 'Foto') {
            _foto.text = base64Encode(bytes);
            foto = file;
          }

          if (jenis == 'KTP') {
            _ktp.text = base64Encode(bytes);
            ktp = file;
          }
        } else {
          errorPesan("Tidak ada file dipilih");
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    id = widget.id;
    idParent = widget.idParent;
    initializeDateFormatting();

    getData(id, idParent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 11, 156, 1),
        title: Text(
          id == 0
              ? "TAMBAH ANGGOTA"
              : "EDIT ${_nama.text.toString().toUpperCase()}",
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
            child: GestureDetector(
              onTap: () {
                simpanData();
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
            foto != null
                ? Center(
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.file(
                          foto!,
                          width: 150,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : _foto.text != ""
                    ? Center(
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image.memory(
                              base64.decode(_foto.text.split(',').last),
                              width: 150,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return const Text('Loading foto...');
                              },
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image.asset(
                              'assets/images/noimage.jpg',
                              width: 150,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 125,
                        color: Colors.white,
                        child: ListView(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text("Foto Dari Kamera"),
                              onTap: () {
                                Navigator.of(context).pop();
                                getImage(ImageSource.camera, 'Foto');
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.image),
                              title: const Text("Ambil File Dari Gallery"),
                              onTap: () {
                                Navigator.of(context).pop();
                                getImage(ImageSource.gallery, 'Foto');
                              },
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.upload),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  elevation: 5,
                ),
                label: const Text("UNGGAH FOTO"),
              ),
            ),
            Visibility(
              visible: false,
              maintainState: true,
              child: TextFormField(
                controller: _foto,
              ),
            ),
            const SizedBox(height: 10),

            //CALEG
            if (idAkses == 4) ...[
              if (tingkat == 'NASIONAL') ...[
                const Text(
                  "  HAK AKSES",
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
                const Text("  KORDINATOR PROPINSI"),
                const SizedBox(height: 5),
                DropdownSearch<PropModel>(
                  asyncItems: (String filter) async {
                    var response = await http.get(Uri.parse(
                        "${ApiStatus.baseUrl}/api/propinsi?key=$key"));

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
                        item.nama.toString().toUpperCase(),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    fit: FlexFit.loose,
                  ),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "AREA PROPINSI",
                      labelStyle: TextStyle(fontSize: 14),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _noPropWilayah.text = value?.noProp ?? "";
                      _propinsiWilayah.text =
                          value?.nama.toString().toUpperCase() ?? "";

                      _idAkses.text = '5';
                    });
                  },
                  selectedItem: PropModel(
                    noProp: _noPropWilayah.text,
                    nama: _propinsiWilayah.text,
                  ),
                  dropdownBuilder: (context, selectedItem) => Text(
                    selectedItem?.nama ?? "",
                    style: const TextStyle(fontSize: 14),
                  ),
                  validator: (value) {
                    if (value?.noProp == "") {
                      return 'Area Propinsi wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
              ],
              if (tingkat == 'PROPINSI') ...[
                const Text(
                  "  HAK AKSES",
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
                const Text("  KORDINATOR KABUPATEN/KOTA"),
                const SizedBox(height: 5),
                DropdownSearch<KabModel>(
                  asyncItems: (String filter) async {
                    var response = await http.get(Uri.parse(
                        "${ApiStatus.baseUrl}/api/kota?key=$key&no_prop=$noPropWilayah"));

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
                      labelText: "AREA KABUPATEN/KOTA",
                      labelStyle: TextStyle(fontSize: 14),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _noKabWilayah.text = value?.noKab ?? "";
                      _kotaWilayah.text = value?.nama ?? "";

                      _idAkses.text = '6';
                      _noPropWilayah.text = noPropWilayah;
                    });
                  },
                  selectedItem: KabModel(
                    noKab: _noKabWilayah.text,
                    nama: _kotaWilayah.text,
                  ),
                  dropdownBuilder: (context, selectedItem) => Text(
                    selectedItem?.nama ?? "",
                    style: const TextStyle(fontSize: 14),
                  ),
                  validator: (value) {
                    if (value?.noKab == "") {
                      return 'Area Kabupaten/Kota wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
              ],
              if (tingkat == 'KABUPATEN/KOTA') ...[
                const Text(
                  "  HAK AKSES",
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
                const Text("  KORDINATOR KECAMATAN"),
                const SizedBox(height: 5),
                DropdownSearch<KecModel>(
                  asyncItems: (String filter) async {
                    var response = await http.get(Uri.parse(
                        "${ApiStatus.baseUrl}/api/kecamatan?key=$key&no_prop=$noPropWilayah&no_kab=$noKabWilayah"));

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
                        item.nama.toString().toUpperCase(),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    fit: FlexFit.loose,
                  ),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "AREA KECAMATAN",
                      labelStyle: TextStyle(fontSize: 14),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _noKecWilayah.text = value?.noKec ?? "";
                      _kecamatanWilayah.text =
                          value?.nama.toString().toUpperCase() ?? "";

                      _idAkses.text = '7';
                      _noPropWilayah.text = noPropWilayah;
                      _noKabWilayah.text = noKabWilayah;
                    });
                  },
                  selectedItem: KecModel(
                    noKec: _noKecWilayah.text,
                    nama: _kecamatanWilayah.text,
                  ),
                  dropdownBuilder: (context, selectedItem) => Text(
                    selectedItem?.nama ?? "",
                    style: const TextStyle(fontSize: 14),
                  ),
                  validator: (value) {
                    if (value?.noKec == "") {
                      return 'Area Kecamatan wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
              ]
            ],
            if (idAkses == 5) ...[
              const Text(
                "  HAK AKSES",
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
              const Text("  KORDINATOR KABUPATEN/KOTA"),
              const SizedBox(height: 5),
              DropdownSearch<KabModel>(
                asyncItems: (String filter) async {
                  var response = await http.get(Uri.parse(
                      "${ApiStatus.baseUrl}/api/kota?key=$key&no_prop=$noPropWilayah"));

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
                    labelText: "AREA KABUPATEN/KOTA",
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _noKabWilayah.text = value?.noKab ?? "";
                    _kotaWilayah.text = value?.nama ?? "";

                    _idAkses.text = '6';
                    _noPropWilayah.text = noPropWilayah;
                  });
                },
                selectedItem: KabModel(
                  noKab: _noKabWilayah.text,
                  nama: _kotaWilayah.text,
                ),
                dropdownBuilder: (context, selectedItem) => Text(
                  selectedItem?.nama ?? "",
                  style: const TextStyle(fontSize: 14),
                ),
                validator: (value) {
                  if (value?.noKab == "") {
                    return 'Area Kabupaten/Kota wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
            ],
            if (idAkses == 6) ...[
              const Text(
                "  HAK AKSES",
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
              const Text("  KORDINATOR KECAMATAN"),
              const SizedBox(height: 5),
              DropdownSearch<KecModel>(
                asyncItems: (String filter) async {
                  var response = await http.get(Uri.parse(
                      "${ApiStatus.baseUrl}/api/kecamatan?key=$key&no_prop=$noPropWilayah&no_kab=$noKabWilayah"));

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
                      item.nama.toString().toUpperCase(),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  fit: FlexFit.loose,
                ),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "AREA KECAMATAN",
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _noKecWilayah.text = value?.noKec ?? "";
                    _kecamatanWilayah.text =
                        value?.nama.toString().toUpperCase() ?? "";

                    _idAkses.text = '7';
                    _noPropWilayah.text = noPropWilayah;
                    _noKabWilayah.text = noKabWilayah;
                  });
                },
                selectedItem: KecModel(
                  noKec: _noKecWilayah.text,
                  nama: _kecamatanWilayah.text,
                ),
                dropdownBuilder: (context, selectedItem) => Text(
                  selectedItem?.nama ?? "",
                  style: const TextStyle(fontSize: 14),
                ),
                validator: (value) {
                  if (value?.noKec == "") {
                    return 'Area Kecamatan wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
            ],
            if (idAkses == 7) ...[
              const Text(
                "  HAK AKSES",
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
              const Text("  KORDINATOR DESA/KELURAHAN"),
              const SizedBox(height: 5),
              DropdownSearch<KelModel>(
                asyncItems: (String filter) async {
                  var response = await http.get(Uri.parse(
                      "${ApiStatus.baseUrl}/api/desa?key=$key&no_prop=$noPropWilayah&no_kab=$noKabWilayah&no_kec=$noKecWilayah"));
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
                    labelText: "AREA DESA/KELURAHAN",
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _noKelWilayah.text = value?.noKel ?? "";
                    _desaWilayah.text = value?.nama?.toUpperCase() ?? "";

                    _idAkses.text = '8';
                    _noPropWilayah.text = noPropWilayah;
                    _noKabWilayah.text = noKabWilayah;
                    _noKecWilayah.text = noKecWilayah;
                  });
                },
                selectedItem: KelModel(
                  noKel: _noKelWilayah.text,
                  nama: _desaWilayah.text,
                ),
                dropdownBuilder: (context, selectedItem) => Text(
                  selectedItem?.nama ?? "",
                  style: const TextStyle(fontSize: 14),
                ),
                validator: (value) {
                  if (value?.noKel == "") {
                    return 'Area Desa/Kelurahan wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
            ],
            if (idAkses == 8) ...[
              DropdownSearch<AksesModel>(
                asyncItems: (String filter) async {
                  var response = await http.get(Uri.parse(
                      "${ApiStatus.baseUrl}/api/tim-akses?key=$key&id_akses=$idAkses"));

                  if (response.statusCode != 200) {
                    errorData();
                    return [];
                  } else {
                    List akses = json.decode(response.body);
                    List<AksesModel> aksesList = [];

                    for (var element in akses) {
                      aksesList.add(AksesModel.fromJson(element));
                    }

                    return aksesList;
                  }
                },
                popupProps: PopupProps.menu(
                  itemBuilder: (context, item, isSelected) => ListTile(
                    title: Text(
                      '${item.akses?.toUpperCase()}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  fit: FlexFit.loose,
                ),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "HAK AKSES",
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _idAkses.text = value?.id.toString() ?? "";
                    _akses.text = value?.akses ?? "";

                    if (tingkat == 'PROPINSI') {
                      _noPropWilayah.text = noPropWilayah;
                    }

                    if (tingkat == 'KABUPATEN/KOTA') {
                      _noPropWilayah.text = noPropWilayah;
                      _noKabWilayah.text = noKabWilayah;
                    }
                  });
                },
                selectedItem: AksesModel(
                  id: int.tryParse(_idAkses.text),
                  akses: _akses.text,
                ),
                dropdownBuilder: (context, selectedItem) => Text(
                  selectedItem?.akses?.toUpperCase() ?? "",
                  style: const TextStyle(fontSize: 14),
                ),
                validator: (value) {
                  if (value?.id == null) {
                    return 'Hak akses wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
            ],
            TextFormField(
              controller: _nama,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "NAMA LENGKAP",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
              ),
              validator: (value) {
                if (value == "") {
                  return 'Nama wajib diisi';
                }
                return null;
              },
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
                  const SizedBox(width: 5),
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
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _kodepos,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "KODEPOS",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            const SizedBox(height: 5),
            DropdownSearch<Map<String, dynamic>>(
              items: const [
                {"id": 1, "kelamin": "LAKI-LAKI"},
                {"id": 2, "kelamin": "PEREMPUAN"},
              ],
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "JENIS KELAMIN",
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _kelamin.text = value?["id"].toString() as String;
                  _jenisKelamin.text = value?["kelamin"] ?? "";
                });
              },
              selectedItem: {
                "id": _kelamin.text,
                "kelamin": _jenisKelamin.text
              },
              popupProps: PopupProps.menu(
                itemBuilder: (context, item, isSelected) => ListTile(
                  title: Text(
                    item["kelamin"],
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                fit: FlexFit.loose,
              ),
              dropdownBuilder: (context, selectedItem) => Text(
                selectedItem?["kelamin"] ?? "",
                style: const TextStyle(fontSize: 14),
              ),
              validator: (value) {
                if (value?["id"] == "") {
                  return 'Jenis kelamin wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _tempLahir,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "TEMPAT LAHIR",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "TANGGAL LAHIR",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
                suffixIcon: Icon(Icons.calendar_month),
              ),
              controller: _tglLahir1,
              autocorrect: false,
              readOnly: true,
              style: const TextStyle(fontSize: 14),
              onTap: () async {
                DateTime? newDateLahir = await showDatePicker(
                  context: context,
                  initialDate: _tglLahir.text != ""
                      ? DateTime.parse(_tglLahir.text)
                      : DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );

                if (newDateLahir != null) {
                  setState(() {
                    _tglLahir.text =
                        DateFormat("yyyy-MM-dd").format(newDateLahir);
                    _tglLahir1.text =
                        DateFormat("d MMMM yyyy", "id").format(newDateLahir);
                  });
                }
              },
            ),
            Visibility(
              visible: false,
              maintainState: true,
              child: TextFormField(
                controller: _tglLahir,
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "ALAMAT EMAIL",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _hp,
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "NOMOR HANDPHONE",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
                prefix: Text("08"),
              ),
              validator: (value) {
                if (value == "") {
                  return 'Nomor HP wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _nik,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "NOMOR INDUK KEPENDUDUKAN (NIK)",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "KARTU TANDA PENDUDUK",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            ktp != null
                ? Center(
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.file(
                          ktp!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : _ktp.text != ""
                    ? Center(
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image.memory(
                              base64.decode(_ktp.text.split(',').last),
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return const Text('Loading foto...');
                              },
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image.asset(
                              'assets/images/ktp.jpg',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
            const SizedBox(height: 5),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  elevation: 5,
                ),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 125,
                        color: Colors.white,
                        child: ListView(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text("Foto Dari Kamera"),
                              onTap: () {
                                Navigator.of(context).pop();
                                getImage(ImageSource.camera, 'KTP');
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.image),
                              title: const Text("Ambil File Dari Gallery"),
                              onTap: () {
                                Navigator.of(context).pop();
                                getImage(ImageSource.gallery, 'KTP');
                              },
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.upload),
                label: const Text("UNGGAH KTP"),
              ),
            ),
            Visibility(
              visible: false,
              maintainState: true,
              child: TextFormField(
                controller: _ktp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> simpanData() async {
    if (_formKey.currentState!.validate() && submitted == false) {
      submitted = true;
      loadingData();

      if (id > 0) {
        var request = await http.post(
          Uri.parse("${ApiStatus.baseUrl}/api/caleg-relawan-edit"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "key": baseKey,
            "uidKey": userUid,
            "hpKey": userHp,
            "id": _id.text,
            "nama": _nama.text,
            "alamat": _alamat.text,
            "dusun": _dusun.text,
            "rt": _rt.text,
            "rw": _rw.text,
            "no_prop": _noProp.text,
            "no_kab": _noKab.text,
            "no_kec": _noKec.text,
            "no_kel": _noKel.text,
            "kodepos": _kodepos.text,
            "kelamin": _kelamin.text,
            "temp_lahir": _tempLahir.text,
            "tgl_lahir": _tglLahir.text,
            "hp": _hp.text,
            "nik": _nik.text,
            "email": _email.text,
            "no_prop_wilayah": _noPropWilayah.text,
            "no_kab_wilayah": _noKabWilayah.text,
            "no_kec_wilayah": _noKecWilayah.text,
            "no_kel_wilayah": _noKelWilayah.text,
            "dusun_wilayah": _dusunWilayah.text,
            "rw_wilayah": _rwWilayah.text,
            "rt_wilayah": _rtWilayah.text,
          }),
        );

        if (request.statusCode == 200) {
          submitted = false;
          hapusLoader();
          pesanData('Profil berhasil disimpan');
          Get.back(result: 1);
        } else {
          var data = await json.decode(request.body);
          submitted = false;
          hapusLoader();
          errorPesan(data['message']);
        }
      } else {
        var request = await http.post(
          Uri.parse("${ApiStatus.baseUrl}/api/caleg-relawan-baru"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "key": baseKey,
            "uidKey": userUid,
            "hpKey": userHp,
            "parent": idParent.toString(),
            "id_akses": _idAkses.text,
            "nama": _nama.text,
            "alamat": _alamat.text,
            "dusun": _dusun.text,
            "rt": _rt.text,
            "rw": _rw.text,
            "no_prop": _noProp.text,
            "no_kab": _noKab.text,
            "no_kec": _noKec.text,
            "no_kel": _noKel.text,
            "kodepos": _kodepos.text,
            "kelamin": _kelamin.text,
            "temp_lahir": _tempLahir.text,
            "tgl_lahir": _tglLahir.text,
            "hp": "628${_hp.text}",
            "nik": _nik.text,
            "foto": _foto.text,
            "ktp": _ktp.text,
            "email": _email.text,
            "no_prop_wilayah": _noPropWilayah.text,
            "no_kab_wilayah": _noKabWilayah.text,
            "no_kec_wilayah": _noKecWilayah.text,
            "no_kel_wilayah": _noKelWilayah.text,
            "dusun_wilayah": _dusunWilayah.text,
            "rw_wilayah": _rwWilayah.text,
            "rt_wilayah": _rtWilayah.text,
          }),
        );

        print(request);

        if (request.statusCode == 200) {
          var data = await json.decode(request.body);
          submitted = false;
          hapusLoader();
          pesanData(data['message']);
          Get.back(result: 1);
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
  }
}
