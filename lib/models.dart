class ResponsePopularMovie {
  final int page;
  final int totalResults;
  final int totalPages;
  final List<ResponseMovieResult> results;

  ResponsePopularMovie(
      {this.page, this.totalPages, this.totalResults, this.results});

  factory ResponsePopularMovie.fromJson(Map<String, dynamic> json) {
    var resultsFromJson = json['results'].cast<Map<String, dynamic>>();
    var results = resultsFromJson
        .map<ResponseMovieResult>((json) => ResponseMovieResult.fromJson(json))
        .toList();

    return ResponsePopularMovie(
        page: json['page'] as int,
        totalPages: json['total_pages'] as int,
        totalResults: json['total_results'] as int,
        results: results);
  }
}

class ResponseMovieResult {
  final int voteCount;
  final int id;
  final bool video;
  final double voteAveraage;
  final String title;
  final double popularity;
  final String posterPath;
  final String originalLanguage;
  final String originalTitle;
  final List<int> genreId;
  final String backdropPath;
  final bool adult;
  final String overview;
  final String releaseDate;

  ResponseMovieResult(
      {this.voteCount,
      this.id,
      this.video,
      this.voteAveraage,
      this.title,
      this.popularity,
      this.posterPath,
      this.originalLanguage,
      this.originalTitle,
      this.genreId,
      this.backdropPath,
      this.adult,
      this.overview,
      this.releaseDate});

  factory ResponseMovieResult.fromJson(Map<String, dynamic> json) {
    return ResponseMovieResult(
        voteCount: json['vote_count'] as int,
        id: json['id'] as int,
        video: json['video'] as bool,
        voteAveraage: json['vote_average'].toDouble() as double,
        title: json['title'] as String,
        popularity: json['popularity'].toDouble() as double,
        posterPath: json['poster_path'] as String,
        originalLanguage: json['original_langauge'] as String,
        originalTitle: json['original_title'] as String,
        genreId: json['genre_id'] as List<int>,
        backdropPath: json['backdrop_path'] as String,
        adult: json['adult'] as bool,
        overview: json['overview'] as String,
        releaseDate: json['release_date'] as String);
  }
}
