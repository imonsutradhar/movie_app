import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie_model.dart';

class DatabaseService {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> toggleFavourite(MovieModel movie) async {
    DocumentReference docRef = _db.collection('users').doc(uid).collection('favourites').doc(movie.id.toString());
    DocumentSnapshot doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        'id': movie.id,
        'title': movie.title,
        'posterUrl': movie.posterUrl,
        'rating': movie.rating,
        'year': movie.year,
        'overview': movie.overview,
        'duration': movie.duration,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<bool> isFavourite(int movieId) async {
    DocumentSnapshot doc = await _db.collection('users').doc(uid).collection('favourites').doc(movieId.toString()).get();
    return doc.exists;
  }

  Stream<int> getFavouriteCount() {
    return _db.collection('users').doc(uid).collection('favourites').snapshots().map((snap) => snap.docs.length);
  }

  Future<void> toggleWatchlist(MovieModel movie) async {
    DocumentReference docRef = _db.collection('users').doc(uid).collection('watchlist').doc(movie.id.toString());
    DocumentSnapshot doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        'id': movie.id,
        'title': movie.title,
        'posterUrl': movie.posterUrl,
        'rating': movie.rating,
        'year': movie.year,
        'overview': movie.overview,
        'duration': movie.duration,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<bool> isInWatchlist(int movieId) async {
    DocumentSnapshot doc = await _db.collection('users').doc(uid).collection('watchlist').doc(movieId.toString()).get();
    return doc.exists;
  }

  Stream<int> getWatchlistCount() {
    return _db.collection('users').doc(uid).collection('watchlist').snapshots().map((snap) => snap.docs.length);
  }
}