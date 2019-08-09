import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String URL_BASE = "https://api.themoviedb.org";
const String URL_POPULAR_MOVIE = "/3/movie/popular";
// const String API_KEY = "?api_key=${DotEnv().env['API_KEY']}";
const String API_KEY = "?api_key=";

void main() async {
  await DotEnv().load('.env');
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainAppPage(),
    );
  }
}

class MainAppPage extends StatefulWidget {
  MainAppPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  Map<String, dynamic> movies = new Map();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Popular Movie"),
        ),
        body: ListView.builder(
          itemCount: movies['results'].length,
          itemBuilder: (BuildContext context, int position) {
            return getRow(position);
          },
        )
        // body: GridView.builder(
        //   itemBuilder: ,
        //   gridDelegate: ,
        // ),
        );
  }

  Widget getRow(int i) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text("Row ${movies['results'][i]["title"]}")),
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text("Row ${movies['results'][i]["overview"]}")),
    ]);
  }

  loadData() async {
    String dataUrl = URL_BASE +
        URL_POPULAR_MOVIE +
        API_KEY +
        DotEnv().env['API_KEY_MOVIE_DB'];
    http.Response response = await http.get(dataUrl);
    setState(() {
      movies = json.decode(response.body);
    });
  }
}
