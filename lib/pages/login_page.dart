import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';
import 'register_page.dart';
import '../services/user_service.dart';
import 'admin_page.dart';
import 'package:local_auth/local_auth.dart';
import '../services/biometric_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LocalAuthentication _auth = LocalAuthentication();

  bool _isLoading = false;
  String? _error;

  // =========================
  // LOGIN (REVISI BERHASIL)
  // =========================
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      print("LOGIN BUTTON CLICK");
      Future<void> _loginWithBiometric() async {
        try {
          bool isSupported = await _auth.isDeviceSupported();

          bool canCheck = await _auth.canCheckBiometrics;

          print("Supported: $isSupported");
          print("CanCheck: $canCheck");

          List<BiometricType> biometrics = await _auth.getAvailableBiometrics();

          print("Biometrics: $biometrics");

          if (!isSupported || !canCheck) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Biometrik tidak tersedia",
                ),
              ),
            );
            return;
          }

          bool authenticated = await _auth.authenticate(
            localizedReason: 'Login menggunakan sidik jari',
            options: const AuthenticationOptions(
              biometricOnly: true,
              stickyAuth: true,
            ),
          );

          if (authenticated && mounted) {
            final biometricUser = await SessionService.getBiometricUser();

            if (biometricUser["username"] != null) {
              await UserService.saveUser(
                biometricUser["username"]!,
                biometricUser["email"]!,
                biometricUser["role"]!,
              );

              await SessionService.saveLogin();

              if (biometricUser["role"] == "admin") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminPage(),
                  ),
                );
              } else {
                Navigator.pushReplacementNamed(
                  context,
                  '/home',
                );
              }
            }
          }
        } catch (e) {
          print("ERROR BIOMETRIC:");
          print(e);
        }
      }

// LOGIN ADMIN TANPA API
      if (username == "admin" && password == "123") {
        await UserService.saveUser(
          username,
          "admin@gmail.com",
          "admin",
        );
        await SessionService.saveLastUser(
          "admin",
          "admin@gmail.com",
          "admin",
        );
        await SessionService.saveLogin();

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const AdminPage(),
            ),
          );
        }

        return;
      }

// LOGIN USER BIASA VIA API
      final data = await AuthService.login(
        username,
        password,
      );

      print(data);

      // REVISI: Mengecek keberadaan 'token', bukan lagi boolean 'success'
      if (data['token'] != null) {
        await AuthService.saveToken(
          data['token'],
        );

        await UserService.saveUser(
          username,
          '$username@gmail.com',
          "user",
        );
        await SessionService.saveLastUser(
          username,
          '$username@gmail.com',
          "user",
        );

        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            '/home',
          );
        }
      } else {
        setState(() {
          _error = data['message'] ?? 'Login gagal';
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _error = e.toString();
      });
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loginWithBiometric() async {
    try {
      bool canCheck = await _auth.canCheckBiometrics;

      if (!canCheck) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Biometrik tidak tersedia"),
          ),
        );
        return;
      }

      bool authenticated = await _auth.authenticate(
        localizedReason: 'Login menggunakan sidik jari',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      if (authenticated && mounted) {
        final biometricUser = await SessionService.getBiometricUser();

        if (biometricUser["username"] != null) {
          await UserService.saveUser(
            biometricUser["username"]!,
            biometricUser["email"]!,
            biometricUser["role"]!,
          );

          await SessionService.saveLogin();

          Navigator.pushReplacementNamed(
            context,
            '/home',
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Belum ada user yang pernah login",
              ),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF3B82F6),
              Color(0xFF60A5FA),
              Color(0xFFDDD6FE),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 12,
              shadowColor: Colors.blue.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.blue.shade50,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.movie_filter_rounded,
                          size: 64,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Movie App',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                              letterSpacing: 1.2,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Discover Amazing Movies',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // USERNAME
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Colors.blue.shade600,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade50,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // PASSWORD
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.blue.shade600,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade50,
                        ),
                      ),

                      // ERROR DISPLAY
                      if (_error != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),

                      // LOGIN BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.login_rounded,
                            color: Colors.white,
                          ),
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          label: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.fingerprint),
                          label: const Text(
                            'Login dengan Biometrik',
                          ),
                          onPressed: _loginWithBiometric,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Belum punya akun? Register',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
