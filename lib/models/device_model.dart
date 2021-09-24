import 'package:meta/meta.dart';
import 'dart:convert';

DeviceModel deviceModelFromJson(String str) =>
    DeviceModel.fromJson(json.decode(str));

String deviceModelToJson(DeviceModel data) => json.encode(data.toJson());

class DeviceModel {
  DeviceModel({
    required this.token,
    required this.userid,
    required this.cihazNo,
  });

  bool token;
  int userid;
  List<CihazNo> cihazNo;

  factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
        token: json["token"],
        userid: json["userid"],
        cihazNo: List<CihazNo>.from(
            json["cihaz_no"].map((x) => CihazNo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "userid": userid,
        "cihaz_no": List<dynamic>.from(cihazNo.map((x) => x.toJson())),
      };
}

class CihazNo {
  CihazNo({
    required this.cihazNo,
    required this.adSoyad,
    required this.konum,
    required this.sonHaberlesme,
  });

  int cihazNo;
  String adSoyad;
  String konum;
  DateTime sonHaberlesme;

  factory CihazNo.fromJson(Map<String, dynamic> json) => CihazNo(
        cihazNo: json["cihaz_no"],
        adSoyad: json["ad_soyad"],
        konum: json["konum"],
        sonHaberlesme: DateTime.parse(json["son_haberlesme"]),
      );

  Map<String, dynamic> toJson() => {
        "cihaz_no": cihazNo,
        "ad_soyad": adSoyad,
        "konum": konum,
        "son_haberlesme": sonHaberlesme.toIso8601String(),
      };
}
