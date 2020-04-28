import 'package:corona/tips.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'countryview.dart';
import 'model/data.dart';
import 'model/data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetData();
    GetWorldData();
    GetTotal();
  }

  Widget inbox() {
    return Container(
      child: FloatingActionButton(
        onPressed: null,
        heroTag: "Inbox",
        tooltip: 'Inbox',
        child: Icon(Icons.inbox),
      ),
    );
  }

  Widget image() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          Route route = MaterialPageRoute(builder: (context) => Tips());
          Navigator.push(context, route);
          print("sf");
        },
        heroTag: "Image",
        tooltip: 'Image',
        child: Icon(Icons.image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          centerTitle: true,
          title: Text("করোনা ভাইরাস"),
          bottom: TabBar(indicatorColor: Colors.white, tabs: [
            Tab(
              text: "বাংলাদেশ",
            ),
            Tab(
              text: "বিশ্ব",
            ),
          ]),
        ),

        body: TabBarView(children: [
          map.isEmpty
              ? Center(
                  child: SpinKitCubeGrid(
                    color: Colors.green[800],
                  ),
                )
              : Column(
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
                              height: MediaQuery.of(context).size.height * 0.05,
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
                    Text(
                      "আজকের পরিস্থিতি",
                      style:
                          TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                    ),
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
                                  color: Colors.red[800], fontSize: 20),
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
                      "https://i.pinimg.com/originals/d1/f7/cc/d1f7cc2ae0501ffddb83246dd55b1ad7.png",
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
                    )
                  ],
                ),
          Total.isEmpty
              ? Center(
                  child: SpinKitCubeGrid(
                    color: Colors.green[800],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "মোট সনাক্ত = ${replaceBangla(Total['total_cases'])}",
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
                                    "সুস্থ = ${replaceBangla(Total['total_recovered'])}",
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
                                  "মৃত = ${replaceBangla(Total['total_deaths'])}",
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
                              "আক্রান্ত আছেন = ${CurrentCases()}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "আজকের পরিস্থিতি",
                        style: TextStyle(
                            fontSize: 20, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: double.infinity,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "নতুন আক্রান্ত = ${replaceBangla(Total['new_cases']) == "" ? "নেই" : replaceBangla(Total['new_cases'])}",
                                style: TextStyle(
                                    color: Colors.red[800], fontSize: 20),
                              ),
                              Text(
                                "নতুন মৃত = ${replaceBangla(Total['new_deaths']) == "" ? "নেই" : replaceBangla(Total['new_deaths'])}",
                                style: TextStyle(
                                    color: Colors.red[800], fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextField(
                        cursorColor: Colors.green[800],
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                            hintText: "Search Country"),
                        onChanged: (string) {
                          print(string);
                          _debouncer.run(() {
                            setState(() {
                              IsLoading = true;
                            });

                            setState(() {
                              secondlistSearch = worlddatalist
                                  .where((u) => (u.countryName
                                          .toLowerCase()
                                          .contains(string.toLowerCase()) ||
                                      u.countryName
                                          .toLowerCase()
                                          .contains(string.toLowerCase())))
                                  .toList();
                            });
                            Future.delayed(Duration(milliseconds: 400), () {
                              setState(() {
                                IsLoading = false;
                              });
                            });
                          });
                        },
                      ),
                      IsLoading == false
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.45,
                              width: double.infinity,
                              child: ListView.builder(
                                  itemCount: secondlistSearch.length,
                                  itemBuilder: (context, index) {
                                    return RaisedButton(
                                      elevation: 0.0,
                                      color: Colors.white,
                                      onPressed: () {
                                        Route route = MaterialPageRoute(
                                            builder: (context) => CountryView(
                                                secondlistSearch[index]
                                                    .countryName));
                                        Navigator.push(context, route);
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "${secondlistSearch[index].countryName}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    );
                                  }))
                          : SpinKitPulse(
                              color: Colors.green[800],
                            ),
                    ],
                  ),
                )
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green[800],
          onPressed: () {
            _launchURL("https://www.facebook.com/masumbillahsanjid");
          },
          child: Icon(Icons.flash_on),
        ),
      ),
    );
  }

  _launchURL(turl) async {
    var url = '$turl';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  var IsLoading = false;
  Map map = {};
  Map Total = {};

  Future GetData() async {
    var url =
        "https://coronavirus-monitor.p.rapidapi.com/coronavirus/latest_stat_by_country.php?country=Bangladesh";
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



  Future GetTotal() async {
    var url =
        "https://coronavirus-monitor.p.rapidapi.com/coronavirus/worldstat.php";
    var response = await http.get(url, headers: {
      "x-rapidapi-host": "coronavirus-monitor.p.rapidapi.com",
      "x-rapidapi-key": "9c25f4adf0msh79701ae94c39c12p160c8bjsn0efea00057a0"
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        Total = data;
      });
    }
  }

  List<Data> worlddatalist = List<Data>();
  var secondlistSearch = [];

  Future GetWorldData() async {
    var url =
        "https://coronavirus-monitor.p.rapidapi.com/coronavirus/cases_by_country.php";
    var response = await http.get(url, headers: {
      "x-rapidapi-host": "coronavirus-monitor.p.rapidapi.com",
      "x-rapidapi-key": "9c25f4adf0msh79701ae94c39c12p160c8bjsn0efea00057a0"
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      for (var temp in data['countries_stat']) {
        setState(() {
          worlddatalist.add(Data.fromJson(temp));
        });
      }

      setState(() {
        secondlistSearch = worlddatalist;
      });
    }
  }

  CurrentCases() {
    var data1 = Total['total_cases'];
    var data2 = Total['total_recovered'];
    var data3 = Total['total_deaths'];

    var math1 = data1.replaceAll(RegExp(r'[a-zA-Z(), ]'), '');
    var math2 = data2.replaceAll(RegExp(r'[a-zA-Z(), ]'), '');
    var math3 = data3.replaceAll(RegExp(r'[a-zA-Z(), ]'), '');
    var finalmath = int.parse(math1) - int.parse(math2) - int.parse(math3);
    return replaceBangla(finalmath.toString());
  }

  loadUsers(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Data>((json) => Data.fromJson(json)).toList();
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

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}


