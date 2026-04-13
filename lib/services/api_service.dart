import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';
import '../constants/app_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Uri _buildUrl(String endpoint, {Map<String, String>? extraParams}) {
    final params = {
      'api_key': AppConstants.apiKey,
      ...?extraParams,
    };
    return Uri.parse('${AppConstants.baseUrl}$endpoint').replace(
      queryParameters: params,
    );
  }

  Future<List<MovieModel>> _fetchMovies(String endpoint,
      {Map<String, String>? extraParams}) async {
    try {
      final response = await http.get(_buildUrl(endpoint, extraParams: extraParams));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'];
        return results.map((e) => MovieModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<MovieModel>> getPopularMovies() =>
      _fetchMovies(AppConstants.popular);

  Future<List<MovieModel>> getTopRatedMovies() =>
      _fetchMovies(AppConstants.topRated);

  Future<List<MovieModel>> getUpcomingMovies() =>
      _fetchMovies(AppConstants.upcoming);

  Future<List<MovieModel>> getTrendingMovies() =>
      _fetchMovies(AppConstants.trending);

  Future<List<MovieModel>> searchMovies(String query) =>
      _fetchMovies(AppConstants.search, extraParams: {'query': query});
}