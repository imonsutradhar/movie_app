import 'package:flutter/material.dart';
import 'movie_details_screen.dart';

import '../models/movie_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  MovieDetailsScreen(movie: dummyMovies[0])),
                );
              },
              child: Stack(
                children: [
                  Container(
                    height: 550,
                    width: double.infinity,
                    child: Image.network(
                      dummyMovies[0].posterUrl,
                      fit: BoxFit.cover,
                    ),
                  ),


                  Container(
                    height: 550,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.3, 0.7, 1.0],
                        colors: [
                          Colors.transparent,
                          const Color(0xFF0F1115).withOpacity(0.4),
                          const Color(0xFF0F1115),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dummyMovies[0].title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),

                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildTag(dummyMovies[0].year),
                            const SizedBox(width: 10),
                            _buildTag("Action"),
                            const SizedBox(width: 10),
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            Text(
                              dummyMovies[0].rating,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Trending Now",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                itemCount: dummyMovies.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  MovieDetailsScreen(movie: dummyMovies[index])),
                      );
                    },
                    child: Container(
                      width: 150,
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(dummyMovies[index].posterUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
