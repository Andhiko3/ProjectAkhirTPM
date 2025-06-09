import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'services/user_service.dart';
import '../pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialPage() async {
    final user = await UserService.getLoggedInUser();
    if (user != null) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialPage(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
            debugShowCheckedModeBanner: false,
          );
        }
        return MaterialApp(
          title: 'Movie App',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),
          home: snapshot.data,
          debugShowCheckedModeBanner: false,
          routes: {
            '/login': (_) => const LoginPage(),
            '/register': (_) => const RegisterPage(),
            '/home': (_) => const HomePage(),
          },
        );
      },
    );
  }
}