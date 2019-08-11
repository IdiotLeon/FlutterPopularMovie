import 'package:flutter/material.dart';
import 'package:flutter_popular_movie/models.dart';

class DetailsPage extends StatelessWidget {
  static const routeName = '/detailsPage';

  @override
  Widget build(BuildContext context) {
    final ResponseMovieResult movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Details of " + movie.title),
      ),
      body: Center(
        child: Text(movie.overview),
      ),
    );
  }
}
