  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:flutter_founders/data/api/auth_api_service.dart';
  import 'package:flutter_secure_storage/flutter_secure_storage.dart';
  import 'package:flutter_founders/presentation/auth/phone_input/bloc/phone_input_bloc.dart';
  import 'package:flutter_founders/presentation/auth/phone_input/phone_input_screen.dart';
  import 'package:flutter_founders/presentation/main_navigation_page.dart';
  import 'package:google_fonts/google_fonts.dart';

  class SplashScreen extends StatefulWidget {
    const SplashScreen({super.key});

    @override
    State<SplashScreen> createState() => _SplashScreenState();
  }

  class _SplashScreenState extends State<SplashScreen> {
    @override
    void initState() {
      super.initState();
      _checkAuthToken();
    }

    Future<void> _checkAuthToken() async {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      await Future.delayed(const Duration(seconds: 2)); // Splash delay

      if (token != null) {
        // فيه توكن → روح على MainNavigationPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationPage()),
        );
      } else {
        // مفيش توكن → روح على PhoneInputScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => PhoneInputBloc(AuthApiService()),
              child: PhoneInputScreen(),
            ),
          ),
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Время — деньги',
                style: GoogleFonts.inriaSans(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: Text(
                    'Бенджамин Франклин',
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
