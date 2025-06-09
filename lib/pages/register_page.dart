import 'package:flutter/material.dart';
import '../services/user_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _register() async {
    setState(() { _isLoading = true; _error = null; });
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final result = await UserService.register(username, password);
    if (result == true) {
      if (mounted) Navigator.pop(context);
    } else {
      setState(() { _error = result ?? 'Register failed'; });
    }
    setState(() { _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
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
                          Icons.person_add_rounded, 
                          size: 64, 
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Create Account', 
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold, 
                          color: Colors.blue.shade800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Join us to explore movies',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.blue.shade700),
                          prefixIcon: Icon(Icons.person_outline, color: Colors.blue.shade600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.blue.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.blue.shade300),
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade50,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.blue.shade700),
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.blue.shade600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.blue.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.blue.shade300),
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade50,
                        ),
                        obscureText: true,
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _error!, 
                                  style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.person_add_rounded, color: Colors.white),
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            disabledBackgroundColor: Colors.blue.shade300,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            shadowColor: Colors.blue.withOpacity(0.4),
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
                                'Create Account', 
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: 'Sudah punya akun? ',
                            style: TextStyle(
                              color: Colors.blue.shade600,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
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
