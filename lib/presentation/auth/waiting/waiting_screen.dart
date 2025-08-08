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
  int tick = 0;

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
      debugPrint("📬 Register request sent successfully");
      registerSent = true;
    } catch (e) {
      debugPrint("❌ Failed to send register request: $e");
    }
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingSeconds <= 0) {
        timer.cancel();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Your request is still under review. Please try again later.",
              ),
            ),
          );
        }
        return;
      }

      // Check status every 5 seconds
      if (tick % 5 == 0) {
        try {
          final result = await authApiService.checkRegisterStatus();
          final status = result['registerStatus'];
          debugPrint("🟡 Current registerStatus: $status");

          if (status == 'accepted') {
            timer.cancel();
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainNavigationPage()),
                (route) => false,
              );
            }
          }
        } catch (e) {
          debugPrint("🔴 Error checking register status: $e");
        }
      }

      if (!mounted) return;
      setState(() {
        remainingSeconds--;
        tick++;
      });
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
