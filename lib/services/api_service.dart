import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class ApiService {
  final String apiKey = "c25f1860f53b8ded24377815e99e00df";
  final String baseUrl = "https://api.themoviedb.org/3";

  final Map<String, int> genreIds = {
    "Action": 28,
    "Sci-Fi": 878,
    "Comedy": 35,
    "Horror": 27,
  };

  Future<List<MovieModel>> getTrendingMovies() async {
    final url = Uri.parse("$baseUrl/trending/movie/day?api_key=$apiKey");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((movieJson) => MovieModel.fromJson(movieJson)).toList();
      }
      else {
        throw Exception("Server status error: ${response.statusCode}");
      }
    }
    catch (e) {
      throw Exception("Unable to fetch the data: $e");
    }
  }

  Future<String?> getTrailerKey(int movieId) async {
    final url = Uri.parse("$baseUrl/movie/$movieId/videos?api_key=$apiKey");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        for (var video in results) {
          if (video['site'] == 'YouTube' && video['type'] == 'Trailer') {
            return video['key'];
          }
        }
      }
    }
    catch (e) {
      print("Unable to load trailer: $e");
    }
    return null;
  }

  Future<List<MovieModel>> getCast(int movieId) async {
    final url = Uri.parse("$baseUrl/movie/$movieId/credits?api_key=$apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> castList = data['cast'];

      return castList.take(10).map((actor) {
        return MovieModel(
          id: actor['id'] ?? 0,
          title: actor['name'] ?? 'Unknown',
          posterUrl: actor['profile_path'] != null
              ? 'https://image.tmdb.org/t/p/w200${actor['profile_path']}'
              : 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
          rating: '',
          year: '',
          duration: '',
          overview: actor['character'] ?? '',
          genreIds: [],
        );
      }).toList();
    }
    else {
      throw Exception("Unable to load cast");
    }
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    final url = Uri.parse("$baseUrl/search/movie?api_key=$apiKey&query=${Uri.encodeComponent(query)}",);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((movieJson) => MovieModel.fromJson(movieJson)).toList();
      }
      else {
        throw Exception("Search server error: ${response.statusCode}");
      }
    }
    catch (e) {
      throw Exception("Unable to search movies: $e");
    }
  }

  Future<List<MovieModel>> getTopRatedMovies() async {
    final url = Uri.parse("$baseUrl/movie/top_rated?api_key=$apiKey");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((movieJson) => MovieModel.fromJson(movieJson)).toList();
    }
    else {
      throw Exception("Failed to load top rated movies");
    }
  }

  Future<List<MovieModel>> getMoviesByGenre(int genreId) async {
    final url = Uri.parse(
      "$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId",
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((movieJson) => MovieModel.fromJson(movieJson)).toList();
    }
    else {
      throw Exception("Failed to load genre movies");
    }
  }
}
