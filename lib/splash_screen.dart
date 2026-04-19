import 'package:flutter/material.dart';
import 'todo_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Scaling effect for the icon
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Fading effect for the text
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    _controller.forward();

    // Navigate after 4 seconds to allow animation to play out
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TodoHomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          // Modern Deep Gradient Background
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A), // Dark Navy
              Color(0xFF1E293B), // Slate
              Color(0xFF334155), // Lighter Slate
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Icon with Scale
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.2), width: 2),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 100,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Animated Text with Fade
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Text(
                    "TASK MASTER",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 8, // Sophisticated spacing
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "ORGANIZE YOUR LIFE",
                    style: TextStyle(
                      color: Colors.blueAccent.withOpacity(0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),

            // Minimalist Loading Bar
            const SizedBox(
              width: 50,
              child: LinearProgressIndicator(
                backgroundColor: Colors.white12,
                color: Colors.blueAccent,
                minHeight: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}