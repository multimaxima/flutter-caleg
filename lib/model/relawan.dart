// To parse this JSON data, do
//
//     final relawanModel = relawanModelFromJson(jsonString);

import 'dart:convert';

RelawanModel relawanModelFromJson(String str) =>
    RelawanModel.fromJson(json.decode(str));

String relawanModelToJson(RelawanModel data) => json.encode(data.toJson());

class RelawanModel {
  RelawanModel({
    this.id,
    this.nama,
    this.hp,
    this.foto,
    this.idAkses,
    this.akses,
    this.propinsiWilayah,
    this.kotaWilayah,
    this.kecamatanWilayah,
    this.desaWilayah,
    this.kordKota,
    this.kordKecamatan,
    this.kordDesa,
    this.kordTps,
    this.relawan,
    this.suara,
  });

  int? id;
  String? nama;
  String? hp;
  String? foto;
  int? idAkses;
  String? akses;
  String? propinsiWilayah;
  String? kotaWilayah;
  String? kecamatanWilayah;
  String? desaWilayah;
  int? kordKota;
  int? kordKecamatan;
  int? kordDesa;
  int? kordTps;
  int? relawan;
  int? suara;

  factory RelawanModel.fromJson(Map<String, dynamic> json) => RelawanModel(
        id: json["id"],
        nama: json["nama"],
        hp: json["hp"],
        foto: json["foto"],
        idAkses: json["id_akses"],
        akses: json["akses"],
        propinsiWilayah: json["propinsi_wilayah"],
        kotaWilayah: json["kota_wilayah"],
        kecamatanWilayah: json["kecamatan_wilayah"],
        desaWilayah: json["desa_wilayah"],
        kordKota: json["kord_kota"],
        kordKecamatan: json["kord_kecamatan"],
        kordDesa: json["kord_desa"],
        kordTps: json["kord_tps"],
        relawan: json["relawan"],
        suara: json["suara"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "hp": hp,
        "foto": foto,
        "id_akses": idAkses,
        "akses": akses,
        "propinsi_wilayah": propinsiWilayah,
        "kota_wilayah": kotaWilayah,
        "kecamatan_wilayah": kecamatanWilayah,
        "desa_wilayah": desaWilayah,
        "kord_kota": kordKota,
        "kord_kecamatan": kordKecamatan,
        "kord_desa": kordDesa,
        "kord_tps": kordTps,
        "relawan": relawan,
        "suara": suara,
      };
}
