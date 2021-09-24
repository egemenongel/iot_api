// To parse this JSON data, do
//
//     final logModel = logModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Map<String, LogModel> logModelFromJson(String str) => Map.from(json.decode(str))
    .map((k, v) => MapEntry<String, LogModel>(k, LogModel.fromJson(v)));

String logModelToJson(Map<String, LogModel> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class LogModel {
  LogModel({
    required this.cihazNo,
    required this.cihazTur,
  });

  int cihazNo;
  List<CihazTur> cihazTur;

  factory LogModel.fromJson(Map<String, dynamic> json) => LogModel(
        cihazNo: json["cihaz_no"],
        cihazTur: List<CihazTur>.from(
            json["cihaz_tur"].map((x) => CihazTur.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cihaz_no": cihazNo,
        "cihaz_tur": List<dynamic>.from(cihazTur.map((x) => x.toJson())),
      };
}

class CihazTur {
  CihazTur({
    required this.t,
    required this.min,
    required this.max,
    required this.input,
    required this.title,
    required this.symbol,
  });

  int t;
  int min;
  int max;
  String input;
  String title;
  String symbol;

  factory CihazTur.fromJson(Map<String, dynamic> json) => CihazTur(
        t: json["t"],
        min: json["min"],
        max: json["max"],
        input: json["input"],
        title: json["title"],
        symbol: json["symbol"],
      );

  Map<String, dynamic> toJson() => {
        "t": t,
        "min": min,
        "max": max,
        "input": input,
        "title": title,
        "symbol": symbol,
      };
}
