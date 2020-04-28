import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
class CountryView extends StatefulWidget {
  var data;
  CountryView(this.data);

  @override
  _CountryViewState createState() => _CountryViewState(this.data);
}

class _CountryViewState extends State<CountryView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetData();
  }

  var data;
  _CountryViewState(this.data);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(data),
        backgroundColor: Colors.green[800],
      ),
      body: map.isEmpty ?
      Center(
        child: SpinKitCubeGrid(
          color: Colors.green[800],
        ),
      ) :
      Column(
        children: <Widget>[

          Card(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: double.infinity,
              child: Center(
                child: Text(
                  "মোট সনাক্ত = ${replaceBangla(map['total_cases'])}",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Card(
                  color: Colors.green[800],
                  child: SizedBox(
                    height:
                    MediaQuery.of(context).size.height * 0.05,
                    child: Center(
                      child: Text(
                        "সুস্থ = ${replaceBangla(map['total_recovered'])}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Card(
                    color: Colors.red[800],
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Center(
                        child: Text(
                          "মৃত = ${replaceBangla(map['total_deaths'])}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          Card(
            color: Colors.blue[800],
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: double.infinity,
              child: Center(
                child: Text(
                  "আক্রান্ত আছেন = ${replaceBangla(map['active_cases'])}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Text("আজকের পরিস্থিতি",style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.10,
            width: double.infinity,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "নতুন আক্রান্ত = ${replaceBangla(map['new_cases']) == "" ? "নেই" : replaceBangla(map['new_cases'])}",
                    style: TextStyle(
                        color: Colors.orange[800], fontSize: 20),
                  ),
                  Text(
                    "নতুন মৃত = ${replaceBangla(map['new_deaths']) == "" ? "নেই" : replaceBangla(map['new_deaths'])}",
                    style: TextStyle(
                        color: Colors.red[800], fontSize: 20),
                  ),
                ],
              ),
            ),
          ),


          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Image.network(
            "https://cdn.clipart.email/15b9622af1bee01bc013ab0165c18849_index-of-images-story-contest_300-488.png",
            height: 150,
            width: 150,
          ),
          Text("বাসায় থাকুন।"),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.10,
          ),
          RaisedButton(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            onPressed: () {
              setState(() {
                map.clear();
              });

              GetData();
            },
            child: Text(
              "রিফ্রেস",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),


          ),

        ],
      ),
    );
  }

  Map map={};


  Future GetData() async {
    var url =
        "https://coronavirus-monitor.p.rapidapi.com/coronavirus/latest_stat_by_country.php?country=$data";
    var response = await http.get(url, headers: {
      "x-rapidapi-host": "coronavirus-monitor.p.rapidapi.com",
      "x-rapidapi-key": "9c25f4adf0msh79701ae94c39c12p160c8bjsn0efea00057a0"
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        map = data['latest_stat_by_country'][0];
      });
    }
  }
  String replaceBangla(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const farsi = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], farsi[i]);
    }

    return input;
  }
}
