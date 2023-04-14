// To parse this JSON data, do
//
//     final partaiModel = partaiModelFromJson(jsonString);

import 'dart:convert';

PartaiModel partaiModelFromJson(String str) =>
    PartaiModel.fromJson(json.decode(str));

String partaiModelToJson(PartaiModel data) => json.encode(data.toJson());

class PartaiModel {
  PartaiModel({
    this.id,
    this.partai,
    this.kode,
    this.urut,
    this.logo,
  });

  int? id;
  String? partai;
  String? kode;
  int? urut;
  String? logo;

  factory PartaiModel.fromJson(Map<String, dynamic> json) => PartaiModel(
        id: json["id"],
        partai: json["partai"],
        kode: json["kode"],
        urut: json["urut"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "partai": partai,
        "kode": kode,
        "urut": urut,
        "logo": logo,
      };
}
