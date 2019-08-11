import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_popular_movie/models.dart';
import 'package:flutter_popular_movie/user_profile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'detail.dart';

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
      routes: {
        DetailsPage.routeName: (context) => DetailsPage(),
        UserProfilePage.routeName: (context) => UserProfilePage(),
      },
    );
  }
}

class PopularMoviesHomePage extends StatelessWidget {
  final String title;

  PopularMoviesHomePage({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            PopupMenuButton(itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: IconButton(
                    icon: Icon(Icons.email),
                    onPressed: () {
                      print('Hello World from Menu');
                    },
                  ),
                ),
              ];
            }),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  'idiotLeon',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                accountEmail: Text('yanglyu.leon.7@gmail.com',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('graphics/ncage_cigar.jpg'),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                  title: Text('Profile'),
                  leading: Icon(Icons.account_circle),
                  onTap: () {
                    Navigator.of(context).pop(); // to close the drawer
                    Navigator.pushNamed(context, UserProfilePage.routeName);
                  }),
            ],
          ),
        ),
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
    return new Card(
      elevation: 5.0,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return new GestureDetector(
            child: new Container(
              alignment: Alignment.center,
              child: CachedNetworkImage(
                imageUrl: URL_IMAGE_BASE + movies[index].posterPath,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
                fit: BoxFit.fill,
                fadeInCurve: Curves.easeIn,
              ),
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            ),
            onTap: () {
              Navigator.pushNamed(context, DetailsPage.routeName,
                  arguments: movies[index]);
            },
          );
        },
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
