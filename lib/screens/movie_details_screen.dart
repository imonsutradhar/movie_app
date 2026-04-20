import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/database_service.dart';
import 'package:movie_server_app/screens/video_player_screen.dart';
import 'package:movie_server_app/services/api_service.dart';

class MovieDetailsScreen extends StatefulWidget {
  final MovieModel movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final DatabaseService _dbService = DatabaseService();

  bool isFav = false;
  bool isWatch = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  // Initial status
  void _loadStatus() async {
    bool favStatus = await _dbService.isFavourite(widget.movie.id);
    bool watchStatus = await _dbService.isInWatchlist(widget.movie.id);

    if (mounted) {
      setState(() {
        isFav = favStatus;
        isWatch = watchStatus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      body: CustomScrollView(
        slivers: [
          // Poster image
          SliverAppBar(
            expandedHeight: 500,
            backgroundColor: const Color(0xFF0F1115),
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.movie.posterUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Movie details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        "${widget.movie.rating}/10",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        widget.movie.year.toString(),
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final String? trailerKey = await ApiService()
                                .getTrailerKey(widget.movie.id);
                            if (trailerKey != null) {
                              if (!context.mounted) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VideoPlayerScreen(videoId: trailerKey),
                                ),
                              );
                            }
                            else {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Trailer not found"),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Play Trailer",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),

                      // Favourite Button
                      _buildActionButton(
                        icon: isFav ? Icons.favorite : Icons.favorite_border,
                        iconColor: isFav ? Colors.redAccent : Colors.white,
                        onTap: () async {
                          await _dbService.toggleFavourite(widget.movie);
                          setState(() {
                            isFav = !isFav;
                          });
                        },
                      ),
                      const SizedBox(width: 15),

                      // Watchlist
                      _buildActionButton(
                        icon: isWatch ? Icons.bookmark : Icons.bookmark_border,
                        iconColor: isWatch ? Colors.blueAccent : Colors.white,
                        onTap: () async {
                          await _dbService.toggleWatchlist(widget.movie);
                          setState(() {
                            isWatch = !isWatch;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Storyline",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.movie.overview,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: iconColor, size: 26),
      ),
    );
  }
}
