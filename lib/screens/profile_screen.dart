import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_server_app/services/database_service.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final AuthService _authService = AuthService();
    final DatabaseService _dbService = DatabaseService();

    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 80),

            // Profile Header Section
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.redAccent.withOpacity(0.2),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: (user?.photoURL != null)
                          ? NetworkImage(user!.photoURL!)
                          : const NetworkImage("https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    user?.displayName ?? "Movie Buff",
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user?.email ?? "user@gmail.com",
                    style: const TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // Stats Cards Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1F26),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Favourites Real-time Count
                    StreamBuilder<int>(
                        stream: _dbService.getFavouriteCount(),
                        builder: (context, snapshot) {
                          String count = snapshot.data?.toString() ?? "0";
                          return _buildStatItem("Favourites", count);
                        }
                    ),

                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.white12,
                    ),

                    // Watchlist Real-time Count
                    StreamBuilder<int>(
                        stream: _dbService.getWatchlistCount(),
                        builder: (context, snapshot) {
                          String count = snapshot.data?.toString() ?? "0";
                          return _buildStatItem("Watchlist", count);
                        }
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 35),

            _buildSectionHeader("Personal Activity"),

            // My Favourite Tile
            _buildMenuTile(
              Icons.favorite,
              "My Favourite",
              Colors.redAccent,
              onTap: () {
                // TODO: Navigator push koro Favourite screen-e
                print("Navigate to Favourites");
              },
            ),

            // Watch List Tile
            _buildMenuTile(
              Icons.history,
              "Watch List",
              Colors.blueAccent,
              onTap: () {
                // TODO: Navigator push koro Watchlist screen-e
                print("Navigate to Watchlist");
              },
            ),

            const SizedBox(height: 20),

            _buildSectionHeader("Settings & Support"),
            _buildMenuTile(
              Icons.settings,
              "Settings",
              Colors.grey,
              onTap: () {
                print("Navigate to Settings");
              },
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: InkWell(
                onTap: () async {
                  await _authService.signOut();
                  if(context.mounted) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false
                    );
                  }
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                  ),
                  child: const Center(
                    child: Text(
                      "Logout",
                      style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
            title,
            style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8
            )
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 4),
        Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 12)
        ),
      ],
    );
  }

  Widget _buildMenuTile(IconData icon, String title, Color iconColor, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white12, size: 14),
        tileColor: const Color(0xFF1C1F26),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}