import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class MovieDetailsScreen extends StatelessWidget {
  final MovieModel movie;
  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 500,
            pinned: true,
            backgroundColor: const Color(0xFF0F1115),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: const BackButton(color: Colors.white),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                movie.posterUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(" ${movie.rating}/10", style: const TextStyle(color: Colors.white70)),
                      const SizedBox(width: 20),
                      Text(movie.year, style:  TextStyle(color: Colors.white70)),
                      const SizedBox(width: 20),
                      Text(movie.duration, style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      icon: Icon(Icons.play_arrow, color: Colors.white),
                      label: Text("Play Trailer", style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),

                  const SizedBox(height: 25),
                  Text(
                    "Storyline",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    movie.overview,
                    style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    "Top Cast",
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Column(
                            children: [
                              const CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/licensed-image?q=tbn:ANd9GcTvf37Li9vM6RSzpllW2pCmj5WMv2Own1YFi4JNgQ3E5CHu3aacKKcUokeHR6iqf5GumYJmdz5XcQRvsCI"),
                              ),
                              SizedBox(height: 8),
                              Text("Tom Cruise", style: TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
