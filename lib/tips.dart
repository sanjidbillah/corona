import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
class Tips extends StatefulWidget {
  @override
  _TipsState createState() => _TipsState();
}

class _TipsState extends State<Tips> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }

  Future GetData() async {
    var url =
        "https://raw.githubusercontent.com/sanjidbillah/code-json-generator/master/code.json";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
     print(data);
    }
  }
}
