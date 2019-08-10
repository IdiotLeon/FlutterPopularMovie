import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String URL_BASE = "https://api.themoviedb.org";
const String URL_POPULAR_MOVIE = "/3/movie/popular";
// const String API_KEY = "?api_key=${DotEnv().env['API_KEY']}";
const String API_KEY = "?api_key=";
const String URL_IMAGE_BASE = "https://image.tmdb.org/t/p/original/";

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
  List movies = [];

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
      // body: ListView.builder(
      //   itemCount: movies['results'].length,
      //   itemBuilder: (BuildContext context, int position) {
      //     return getRow(position);
      //   },
      // )
      body: GridView.builder(
        itemCount: movies.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          var imageUrl = URL_IMAGE_BASE + movies[index]['poster_path'];
          return new GestureDetector(
            child: new Card(
              elevation: 5.0,
              child: new Container(
                alignment: Alignment.center,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
            ),
            onTap: () {},
          );
        },
      ),
    );
  }

  Widget getRow(int i) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text("Row ${movies[i]["title"]}")),
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text("Row ${movies[i]["overview"]}")),
    ]);
  }

  loadData() async {
    String dataUrl = URL_BASE +
        URL_POPULAR_MOVIE +
        API_KEY +
        DotEnv().env['API_KEY_MOVIE_DB'];
    http.Response response = await http.get(dataUrl);
    setState(() {
      movies = json.decode(response.body)['results'];
    });
  }
}
