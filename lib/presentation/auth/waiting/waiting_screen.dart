// lib/presentation/auth/waiting/waiting_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_founders/data/api/auth_api_service.dart';
import 'package:flutter_founders/presentation/main_navigation_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({super.key});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  final AuthApiService authApiService = AuthApiService();
  static const int totalSeconds = 600;
  late int remainingSeconds;
  Timer? _timer;
  bool registerSent = false;

  @override
  void initState() {
    super.initState();
    remainingSeconds = totalSeconds;
    _sendRegisterRequestOnce();
    _startPolling();
  }

  Future<void> _sendRegisterRequestOnce() async {
    try {
      await authApiService.sendRegisterRequest();
      print("📬 Register request sent successfully");
      registerSent = true;
    } catch (e) {
      print("❌ Failed to send register request: $e");
    }
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        final result = await authApiService.checkRegisterStatus();
        final status = result['registerStatus'];
        print("🟡 Current registerStatus: $status");

        if (status == 'accepted') {
          timer.cancel();
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainNavigationPage()),
            );
          }
        }
      } catch (e) {
        print("🔴 Error checking register status: $e");
        if (mounted && remainingSeconds <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Something went wrong. Please try again later."),
            ),
          );
        }
      }

      if (remainingSeconds <= 0) {
        timer.cancel();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Your request is still under review. Please try again later.",
            ),
          ),
        );
      } else {
        setState(() => remainingSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  double get _progress => (totalSeconds - remainingSeconds) / totalSeconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Founders',
              style: GoogleFonts.inriaSerif(
                fontSize: 36,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 12.0,
              percent: _progress,
              reverse: true,
              backgroundColor: Colors.white24,
              progressColor: Colors.white,
              center: Text(
                _formattedTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              animation: true,
              animateFromLastPercent: true,
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Text(
                'В течение 10 минут с Вами свяжется наш менеджер.\nПожалуйста, подождите.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
