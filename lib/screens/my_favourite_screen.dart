import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie_model.dart';
import 'movie_details_screen.dart';

class MyFavouriteScreen extends StatelessWidget {
  const MyFavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid =FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1115),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        surfaceTintColor: Colors.transparent,
        title: Text(
          "My Favourites",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size:20),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('favourites')
              //.orderBy('addedAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.redAccent),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No favourites yet!", style: TextStyle(color: Colors.white54, fontSize: 16)),
              );
            }
            final favMovies = snapshot.data!.docs;
        
            return GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: favMovies.length,
              itemBuilder: (context, index) {
                var data = favMovies[index].data() as Map<String, dynamic>;
                try {
                  String ratingString = "0.0";
                  if (data['rating'] != null) {
                    ratingString = data['rating'].toString();
                  }
        
                  MovieModel movie = MovieModel(
                      title: data['title'] ?? "Unknown",
                      posterUrl: data['posterUrl'] ?? '',
                      rating: ratingString,
                      year: data['year'] ?? 0,
                      duration: data['duration'] ?? "",
                      overview: data['overview'] ?? "",
                      id: data['id'],
                      genreIds: data['genreIds'] is List ? List<int>.from(data['genreIds']) : [],
                  );
        
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie: movie))
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          Image.network(
                            movie.posterUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                                ),
                              ),
                              child: Text(
                                movie.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
                catch (e) {
                  print("Final Mapping Error : $e");
                  return const SizedBox();
                }
              }
            );
          }
        ),
      ),
    );
  }
}
