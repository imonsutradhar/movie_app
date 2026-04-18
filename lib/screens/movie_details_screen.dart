import 'package:flutter/material.dart';
import 'package:movie_server_app/screens/video_player_screen.dart';
import 'package:movie_server_app/services/api_service.dart';
import '../models/movie_model.dart';

class MovieDetailsScreen extends StatelessWidget {
  final MovieModel movie;
  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                backgroundColor: Colors.black.withValues(alpha: 0.5),
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
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(
                          " ${movie.rating}/10",
                          style: const TextStyle(color: Colors.white70)
                      ),
                      const SizedBox(width: 20),
                      Text(
                          movie.year,
                          style: const TextStyle(color: Colors.white70)
                      ),
                      const SizedBox(width: 20),
                      Text(
                          movie.duration,
                          style: const TextStyle(color: Colors.white70)
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final String? trailerKey =
                        await ApiService().getTrailerKey(movie.id);
                        if (trailerKey != null) {
                          if (!context.mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(videoId: trailerKey)
                            ),
                          );
                        }
                        else {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Trailer not found")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        ),
                      ),
                      icon: Icon(Icons.play_arrow, color: Colors.white),
                      label: Text(
                          "Play Trailer",
                          style: TextStyle(color: Colors.white, fontSize: 18)
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Storyline",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    movie.overview,
                    style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Top Cast",
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  FutureBuilder<List<MovieModel>>(
                      future: ApiService().getCast(movie.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SizedBox(
                            height: 120,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.redAccent
                                ),
                            ),
                          );
                        }
                        else if (snapshot.hasError) {
                          return Text(
                              "Could not load cast",
                              style: TextStyle(color: Colors.white70)
                          );
                        }
                        else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text(
                              "No cast information available",
                              style: TextStyle(color: Colors.white70)
                          );
                        }
                        final castList = snapshot.data!;

                        return SizedBox(
                          height: 130,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: castList.length,
                            itemBuilder: (context, index) {
                              final actor = castList[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 35,
                                      backgroundColor: Colors.grey[900],
                                      backgroundImage:
                                      NetworkImage(actor.posterUrl),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        actor.title,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }),
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