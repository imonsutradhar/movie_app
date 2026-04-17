import 'dart:collection';

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F1115),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 70),
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white12,
                        backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
                      ),
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.edit, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Imon Sutradhar",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "imon@gmail.com",
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem("Favourites", "12"),
                  _buildStatItem("Watched", "45"),
                  _buildStatItem("Reviews", "8"),
                ],
              ),
            ),

            const SizedBox(height: 40),
            
            _buildListTile(Icons.favorite, "My Favourite"),
            _buildListTile(Icons.history, "Watch History"),
            _buildListTile(Icons.file_download, "Downloads"),
            _buildListTile(Icons.settings, "Settings"),
            _buildListTile(Icons.help_outline, "Help & Support"),

            const SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () {},
                leading: Icon(Icons.logout, color: Colors.redAccent),
                title: Text("Logout", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(color: Colors.white38, fontSize: 13)),
      ],
    );
  }

  Widget _buildListTile(IconData icon, String tittle) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        onTap: () {},
        leading: Icon(icon, color: Colors.white70),
        title: Text(tittle, style: TextStyle(color: Colors.white, fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
        tileColor: Colors.white.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
