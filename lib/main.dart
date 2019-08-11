import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_popular_movie/models.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'detail.dart';
import 'user_profile.dart';

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
      home: PopularMoviesHomePage(title: "Popular Movies"),
    );
  }
}

class PopularMoviesHomePage extends StatelessWidget {
  final String title;

  PopularMoviesHomePage({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        drawer: Drawer(),
        body: FutureBuilder<List<ResponseMovieResult>>(
            future: fetchMovies(http.Client()),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData
                  ? MoviesList(movies: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            }));
  }
}

class MoviesList extends StatelessWidget {
  final List<ResponseMovieResult> movies;

  MoviesList({Key key, this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Card(
        elevation: 5.0,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Container(
              alignment: Alignment.center,
              child: CachedNetworkImage(
                imageUrl: URL_IMAGE_BASE + movies[index].posterPath,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
                fit: BoxFit.fill,
                fadeInCurve: Curves.easeIn,
              ),
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            );
          },
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      onTap: () {
        print("Hello World");
      },
    );
  }
}

Future<List<ResponseMovieResult>> fetchMovies(http.Client client) async {
  var urlPopularMovies =
      URL_BASE + URL_POPULAR_MOVIE + API_KEY + DotEnv().env['API_KEY_MOVIE_DB'];
  final response = await client.get(urlPopularMovies);
  return parseResponse(response.body);
}

List<ResponseMovieResult> parseResponse(String responseBody) {
  final parsed = Map<String, dynamic>.from(json.decode(responseBody));
  return (new ResponsePopularMovie.fromJson(parsed)).results.toList();
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
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Leon"),
              accountEmail: Text("idiotleon"),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.blue
                        : Colors.white,
                child: Text(
                  "A",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              title: Text("Item 1"),
              trailing: Theme.of(context).platform == TargetPlatform.android
                  ? Icon(Icons.arrow_forward)
                  : Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => UserProfile()));
              },
            ),
          ],
        ),
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
              child: Container(
                alignment: Alignment.center,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                  fit: BoxFit.fill,
                  fadeInCurve: Curves.easeIn,
                ),
                padding: new EdgeInsets.all(10.0),
                constraints: BoxConstraints.expand(),
              ),
              margin: new EdgeInsets.all(5.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
            ),
            onTap: () {
              print(movies[index]['overview']);
            },
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
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    var responsePopularMovie = parsed.map<ResponsePopularMovie>(
        (json) => ResponsePopularMovie.fromJson(json));
    setState(() {
      movies = responsePopularMovie.results;
    });
  }
}
