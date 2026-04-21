class MovieModel {
  final String title;
  final String posterUrl;
  final String rating;
  final String year;
  final String duration;
  final String overview;
  final int id;
  final List<int> genreIds;

  MovieModel({
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.year,
    required this.duration,
    required this.overview,
    required this.id,
    required this.genreIds,
  });
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Tittle',
      posterUrl: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
      rating: json['vote_average']?.toString() ?? '0.0',
      year: (json['release_date'] != null && json['release_date'] != "")
          ? json['release_date'].split('-')[0]
          : 'N/A',
      duration: "N/A",
      overview: json['overview'] ?? 'No description available.',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
    );
  }
}