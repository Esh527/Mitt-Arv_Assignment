import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mitt_arv_assignment/model/movie.dart';
import './movie_service.dart';

class MovieService {
  static Future<List<Movie>> fetchTopRatedMovies(String apiKey, int page) async {
    final url =
        "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey&language=en-US&page=$page";

    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      List<Movie> fetchedMovies = [];

      responseData['results'].forEach((movieData) {
        final movie = Movie(
          id: movieData['id'],
          name: movieData['title'],
          posterPath: movieData['poster_path'],
          year: movieData['release_date'] != null ? movieData['release_date'].substring(0, 4) : 'N/A',
          rating: movieData['vote_average'] != null ? movieData['vote_average'].toDouble() : 0.0,
        );
        fetchedMovies.add(movie);
      });

      return fetchedMovies;
    } catch (error) {
      throw Exception("Error fetching movies: $error");
    }
  }

  static searchMovies(String apiKey, String query) {}
}
