class MovieModel {
  final String title;
  final String posterUrl;
  final String rating;
  final String year;
  final String duration;
  final String overview;
  final int id;

  MovieModel({
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.year,
    required this.duration,
    required this.overview,
    required this.id,
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
    );
  }
}


List<MovieModel> dummyMovies = [
  MovieModel(
    id: 1,
    title: "The Batman",
    posterUrl: "https://m.media-amazon.com/images/M/MV5BMmU5NGJlMzAtMGNmOC00YjJjLTgyMzUtNjAyYmE4Njg5YWMyXkEyXkFqcGc@._V1_.jpg",
    rating: "8.5",
    year: "2022",
    duration: "2h 56m",
    overview: "In his second year of fighting crime, Batman uncovers corruption in Gotham City...",
  ),
  MovieModel(
    id: 2,
    title: "Spider-Man",
    posterUrl: "https://upload.wikimedia.org/wikipedia/en/e/e1/Spider-Man_PS4_cover.jpg",
    rating: "8.3",
    year: "2021",
    duration: "2h 28m",
    overview: "With Spider-Man's identity now revealed, Peter asks Doctor Strange for help...",
  ),
];