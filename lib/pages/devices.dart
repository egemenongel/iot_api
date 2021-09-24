import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iot_api/models/device_model.dart';
import 'package:iot_api/pages/device_logs.dart';
import 'package:iot_api/pages/login_page.dart';

class DevicesPage extends StatefulWidget {
  DevicesPage({Key? key, required this.token}) : super(key: key);
  String token;

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  Future fetchDevices() async {
    var _body = {
      "app_token": widget.token.toString(),
      "userid": 1,
      "cihaz_no": [100000291]
    };
    var _headers = {
      "Content-type": "application/json; charset=UTF-8",
    };
    final response = await http.post(
      Uri.parse("http://ems.lande.com.tr/api/userdeviceslist"),
      body: jsonEncode(_body),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      setState(() {
        decodedJson = jsonDecode(response.body);

        deviceList = decodedJson["cihaz_no"];
        deviceResult = deviceModelFromJson(response.body);
      });
    } else {
      print(response.statusCode);
    }
  }

  var deviceResult;
  var deviceId;
  var deviceList;
  var decodedJson;

  late Future futureDevices;

  @override
  void initState() {
    super.initState();
    futureDevices = fetchDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cihaz Listeniz"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
            future: futureDevices,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    Container(
                      height: 250,
                      width: 500,
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemCount: deviceList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var deviceList = deviceResult.cihazNo;

                          return ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DeviceLogsPage(
                                        token: widget.token.toString(),
                                        deviceId: deviceList[index].cihazNo,
                                      )));
                            },
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.devices_sharp),
                              ],
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${deviceList[index].cihazNo}"),
                                Text("${deviceList[index].adSoyad}"),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(TextSpan(children: [
                                    TextSpan(
                                      text: "Konum: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(text: deviceList[index].konum)
                                  ])),
                                  Text.rich(TextSpan(children: [
                                    TextSpan(
                                      text: "Son Haberleşme Tarihi: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                        text: deviceList[index]
                                            .sonHaberlesme
                                            .toString())
                                  ])),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                    child:
                        Text("Snapshot Error: " + snapshot.error.toString()));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          ElevatedButton(
              onPressed: () {
                LoginPreferences.setToken("token");
                Navigator.pop(context);
              },
              child: Text("Çıkış Yap"))
        ],
      ),
    );
  }
}
