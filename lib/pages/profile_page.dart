import 'package:flutter/material.dart';
import 'currency_page.dart';
import 'sensor_page.dart';
import 'movie_quiz_page.dart';
import 'ai_chat_page.dart';
import 'edit_profile_page.dart';
import 'history_page.dart';
import '../services/session_service.dart';
import 'quiz_genre_page.dart';
import 'kesan_pesan_page.dart';
import '../services/user_service.dart';
import 'admin_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "Guest";
  String role = "user";

  bool biometricEnabled = false;
  Future<void> loadBiometric() async {
    final data = await SessionService.getBiometricUser();

    setState(() {
      biometricEnabled = data["username"] != null;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUser();
    loadBiometric();
  }

  Future<void> loadUser() async {
    final user = await SessionService.getUsername();
    role = await UserService.getRole();

    setState(() {
      username = user ?? "Guest";
    });
  }

  Widget menuButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(icon),
          label: Text(title),
          onPressed: onTap,
        ),
      ),
    );
  }
  Widget biometricButton() {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 8,
    ),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        child: Row(
          children: [
            const Icon(Icons.fingerprint),
            const SizedBox(width: 12),

            const Expanded(
              child: Text(
                "Biometric Login",
              ),
            ),

            Switch(
              value: biometricEnabled,
              onChanged: (value) async {
                if (value) {
                  final username =
                      await UserService.getUsername();

                  final email =
                      await UserService.getEmail();

                  final role =
                      await UserService.getRole();

                  await SessionService.saveBiometricUser(
                    username!,
                    email!,
                    role,
                  );

                  setState(() {
                    biometricEnabled = true;
                  });
                } else {
                  await SessionService.removeBiometricUser();

                  setState(() {
                    biometricEnabled = false;
                  });
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          if (role == "admin")
            IconButton(
              icon: const Icon(
                Icons.admin_panel_settings,
              ),
              tooltip: "Admin Dashboard",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminPage(),
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const CircleAvatar(
              radius: 55,
              child: Icon(
                Icons.person,
                size: 60,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              username,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            menuButton(
              icon: Icons.edit,
              title: "Edit Profile",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditProfilePage(),
                  ),
                );
              },
            ),
            menuButton(
              icon: Icons.quiz,
              title: "Movie Quiz",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const QuizGenrePage(),
                  ),
                );
              },
            ),
            menuButton(
              icon: Icons.feedback,
              title: "Kesan & Pesan TPM",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const KesanPesanPage(),
                  ),
                );
              },
            ),
            biometricButton(),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              onPressed: () async {
                await SessionService.logout();

                if (!context.mounted) {
                  return;
                }

                Navigator.pushReplacementNamed(
                  context,
                  '/login',
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
