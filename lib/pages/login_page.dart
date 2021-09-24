import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iot_api/pages/devices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPreferences {
  static SharedPreferences? _sharedPreferences;
  static Future init() async =>
      _sharedPreferences = await SharedPreferences.getInstance();
  static Future setToken(String key) async =>
      await _sharedPreferences!.setString("tokenKey", key);
  static getToken() => _sharedPreferences!.getString("tokenKey");
}

final _formKey = GlobalKey<FormState>();
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

var token;
var formError;
var loginResponse;
bool _passwordVisible = false;

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    token = LoginPreferences.getToken() ?? "token";
    if (token != "token") {
      Future(() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DevicesPage(token: token.toString())));
      });
    } else {}
  }

  Future login() async {
    var formData = {
      "email": _emailController.text,
      "password": _passwordController.text
    };
    final response = await http.post(
      Uri.parse("http://ems.lande.com.tr/api/userlogin"),
      body: jsonEncode(formData),
      headers: {
        "Content-type": "application/json; charset=UTF-8",
      },
    );

    if (response.statusCode == 200) {
      loginResponse = jsonDecode(response.body);
      if (loginResponse["error"] != null) {
        formError = loginResponse["error"];
      }
      if (loginResponse["app_token"] != null) {
        token = loginResponse["app_token"];

        LoginPreferences.setToken(token);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DevicesPage(token: token.toString())));
      }
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hoşgeldiniz"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 100),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Lütfen bir email giriniz.";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        InputDecoration(prefixIcon: Icon(Icons.account_circle)),
                  ),
                  SizedBox(height: 50),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Lütfen bir şifre giriniz.";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key_rounded),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          }),
                    ),
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      child: Text("Giriş yap")),
                ],
              ),
            ),
          ),
        ));
  }
}
