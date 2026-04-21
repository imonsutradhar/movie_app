import 'package:flutter/material.dart';
import 'package:movie_server_app/screens/movie_details_screen.dart';
import 'package:movie_server_app/services/api_service.dart';
import '../models/movie_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();
  List<MovieModel> _searchResults = [];
  List<MovieModel> _displayMovies = [];
  bool _isLoading = false;
  String _currentQuery = "";
  String _selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() async {
    setState(() => _isLoading =true);
    try {
      List<MovieModel> results;
      if(_selectedCategory == "All") {
        results = await _apiService.getTopRatedMovies();
      }
      else {
        int? genreId = _apiService.genreIds[_selectedCategory];
        results = await _apiService.getMoviesByGenre(genreId!);
      }
      setState(() {
        _displayMovies =results;
        _isLoading= false;
      });
    }
    catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _searchMovies(String query) async {
    setState(() {
      _currentQuery = query;
    });

    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final results = await _apiService.searchMovies(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  List<MovieModel> get _getFinalDisplayList {
    if (_currentQuery.isEmpty) {
       return _displayMovies;
    }
    if (_selectedCategory == "All") {
      return _searchResults;
    }
    int? targetGenreId = _apiService.genreIds[_selectedCategory];
    return _searchResults.where((movie) {
      return movie.genreIds.contains(targetGenreId);
    }).toList();
  }

  void _onCategoryTap(String category) {
    setState(() {
      _selectedCategory = category;
    });
    if (_currentQuery.isEmpty) {
      _loadInitialData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayList = _getFinalDisplayList;
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Explore Movies",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),
              TextField(
                onChanged: (value) => _searchMovies(value),
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search for movies",
                  hintStyle: TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.search, color: Colors.redAccent),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 45,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryChip("All"),
                    _buildCategoryChip("Action"),
                    _buildCategoryChip("Sci-Fi"),
                    _buildCategoryChip("Comedy"),
                    _buildCategoryChip("Horror"),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              Text(
                _currentQuery.isEmpty ? "$_selectedCategory Movies" : "Result in $_selectedCategory",
                style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.redAccent,
                        ),
                      )
                    : displayList.isEmpty
                    ? const Center(
                        child: Text(
                          "No movies found in this category",
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 0.7,
                            ),
                        itemCount: displayList.length,
                        itemBuilder: (context, index) {
                          final movie =displayList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailsScreen(movie: movie),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    movie.posterUrl,
                                  ),
                                  fit: BoxFit.cover,
                                  onError: (error, stackTrace) => Icon(Icons.broken_image),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // category chip widget
  Widget _buildCategoryChip(String tittle) {
    bool isSelected = _selectedCategory == tittle;
    return GestureDetector(
      onTap: () => _onCategoryTap(tittle),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.redAccent : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tittle,
          style: TextStyle(
            color:  Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
