import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/user_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState
    extends State<EditProfilePage> {

  final usernameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final addressController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {

    final profile =
        await UserService.getProfile();

    if (profile != null) {

      usernameController.text =
          profile.username;

      emailController.text =
          profile.email;

      phoneController.text =
          profile.phone;

      addressController.text =
          profile.address;
    }
  }

  Future<void> saveProfile() async {

    final profile =
        UserProfile(
      username:
          usernameController.text,
      email:
          emailController.text,
      phone:
          phoneController.text,
      address:
          addressController.text,
    );

    await UserService.saveProfile(
      profile,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Profile Saved",
        ),
      ),
    );
  }

  Widget field(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 15,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border:
              const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          children: [

            field(
              "Username",
              usernameController,
            ),

            field(
              "Email",
              emailController,
            ),

            field(
              "Phone",
              phoneController,
            ),

            field(
              "Address",
              addressController,
            ),

            ElevatedButton(
              onPressed: saveProfile,
              child: const Text(
                "Save Profile",
              ),
            ),
          ],
        ),
      ),
    );
  }
}