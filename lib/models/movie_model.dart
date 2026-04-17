class MovieModel {
  final String title;
  final String posterUrl;
  final String rating;
  final String year;
  final String duration;
  final String overview;

  MovieModel({
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.year,
    required this.duration,
    required this.overview,
  });
}


List<MovieModel> dummyMovies = [
  MovieModel(
    title: "The Batman",
    posterUrl: "https://m.media-amazon.com/images/M/MV5BMmU5NGJlMzAtMGNmOC00YjJjLTgyMzUtNjAyYmE4Njg5YWMyXkEyXkFqcGc@._V1_.jpg",
    rating: "8.5",
    year: "2022",
    duration: "2h 56m",
    overview: "In his second year of fighting crime, Batman uncovers corruption in Gotham City...",
  ),
  MovieModel(
    title: "Spider-Man",
    posterUrl: "https://upload.wikimedia.org/wikipedia/en/e/e1/Spider-Man_PS4_cover.jpg",
    rating: "8.3",
    year: "2021",
    duration: "2h 28m",
    overview: "With Spider-Man's identity now revealed, Peter asks Doctor Strange for help...",
  ),
];