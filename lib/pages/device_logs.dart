import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iot_api/models/log_model.dart';

class DeviceLogsPage extends StatefulWidget {
  DeviceLogsPage({Key? key, required this.token, required this.deviceId})
      : super(key: key);
  var token;
  var deviceId;
  @override
  _DeviceLogsPageState createState() => _DeviceLogsPageState();
}

class _DeviceLogsPageState extends State<DeviceLogsPage> {
  var decodedJson;
  var deviceLogsList;
  var deviceResult;
  var sym = "";
  late Future futureDeviceLogs;
  Future fetchDeviceLogs() async {
    var _body = {
      "app_token": widget.token.toString(),
      "userid": 1,
      "limit": 1,
      "cihaz_no": [100000291]
    };
    var _headers = {
      "Content-type": "application/json; charset=UTF-8",
    };
    final response = await http.post(
      Uri.parse("http://ems.lande.com.tr/api/userdevicesloglist"),
      body: jsonEncode(_body),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      decodedJson = jsonDecode(response.body);
      deviceLogsList = decodedJson[widget.deviceId.toString()]["cihaz_tur"];
    } else {}
  }

  void initState() {
    super.initState();

    futureDeviceLogs = fetchDeviceLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cihaz Sensör Bilgileri"),
      ),
      body: FutureBuilder(
        future: futureDeviceLogs,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: deviceLogsList.length,
              itemBuilder: (BuildContext context, int index) {
                if (deviceLogsList[index]["symbol"] != null) {
                  sym = deviceLogsList[index]["symbol"].toString();
                }

                return ListTile(
                  onTap: () {},
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sensors_rounded),
                    ],
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(deviceLogsList[index]["title"].toString()),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: "input: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: deviceLogsList[index]["input"].toString(),
                          )
                        ])),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: "T: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: deviceLogsList[index]["t"].toString(),
                          )
                        ])),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: "Min: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: deviceLogsList[index]["min"].toString() + sym,
                          )
                        ])),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: "Max: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: deviceLogsList[index]["max"].toString() + sym,
                          )
                        ])),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Snapshot Error: " + snapshot.error.toString()));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
