import 'package:flutter/material.dart';
import 'package:movie_server_app/screens/movie_details_screen.dart';
import '../models/movie_model.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text("Explore Movies", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),

              const SizedBox(height: 20),
              TextField(
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
                    _buildCategoryChip("All", true),
                    _buildCategoryChip("Action", false),
                    _buildCategoryChip("Sci-Fi", false),
                    _buildCategoryChip("Comedy", false),
                    _buildCategoryChip("Horror", false),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              // grid view/ movie result
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: dummyMovies.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie: dummyMovies[index])),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(dummyMovies[index].posterUrl),
                            fit: BoxFit.cover
                          ),
                        ),
                      ),
                    );
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
// category chip widget
  Widget _buildCategoryChip(String tittle, bool isSelected) {
    return Container(
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
          color: isSelected ? Colors.white : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
