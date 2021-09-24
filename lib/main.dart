import 'package:flutter/material.dart';
import 'package:iot_api/pages/devices.dart';
import 'package:iot_api/pages/login_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LoginPreferences.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: LoginPage(),
    );
  }
}
