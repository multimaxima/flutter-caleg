// To parse this JSON data, do
//
//     final tpsModel = tpsModelFromJson(jsonString);

import 'dart:convert';

TpsModel tpsModelFromJson(String str) => TpsModel.fromJson(json.decode(str));

String tpsModelToJson(TpsModel data) => json.encode(data.toJson());

class TpsModel {
  TpsModel({
    this.id,
    this.nomor,
    this.nama,
    this.alamat,
    this.dusun,
    this.rt,
    this.rw,
    this.noProp,
    this.noKab,
    this.noKec,
    this.noKel,
    this.propinsi,
    this.kota,
    this.kecamatan,
    this.desa,
    this.lat,
    this.lng,
  });

  int? id;
  String? nomor;
  String? nama;
  String? alamat;
  String? dusun;
  String? rt;
  String? rw;
  String? noProp;
  String? noKab;
  String? noKec;
  String? noKel;
  String? propinsi;
  String? kota;
  String? kecamatan;
  String? desa;
  String? lat;
  String? lng;

  factory TpsModel.fromJson(Map<String, dynamic> json) => TpsModel(
        id: json["id"],
        nomor: json["nomor"],
        nama: json["nama"],
        alamat: json["alamat"],
        dusun: json["dusun"],
        rt: json["rt"],
        rw: json["rw"],
        noProp: json["no_prop"],
        noKab: json["no_kab"],
        noKec: json["no_kec"],
        noKel: json["no_kel"],
        propinsi: json["propinsi"],
        kota: json["kota"],
        kecamatan: json["kecamatan"],
        desa: json["desa"],
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nomor": nomor,
        "nama": nama,
        "alamat": alamat,
        "dusun": dusun,
        "rt": rt,
        "rw": rw,
        "no_prop": noProp,
        "no_kab": noKab,
        "no_kec": noKec,
        "no_kel": noKel,
        "propinsi": propinsi,
        "kota": kota,
        "kecamatan": kecamatan,
        "desa": desa,
        "lat": lat,
        "lng": lng,
      };
}
