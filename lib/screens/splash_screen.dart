import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _startTransition();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startTransition() async {
    // Shorter delay but smoother transition
    await Future.delayed(const Duration(milliseconds: 2800));
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, anim, __) => FadeTransition(opacity: anim, child: const MainEntry()),
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A), // Premium Dark Slate
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Floating Neon Orbs (Background)
            ...List.generate(4, (i) {
              final List<Color> colors = [
                AppTheme.primaryColor.withValues(alpha: 0.2),
                AppTheme.secondaryColor.withValues(alpha: 0.2),
                Colors.purple.withValues(alpha: 0.2),
                Colors.blue.withValues(alpha: 0.2),
              ];
              return Positioned(
                top: 50.0 + (i * 200),
                left: (i % 2 == 0) ? -50 : null,
                right: (i % 2 != 0) ? -50 : null,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colors[i],
                        blurRadius: 100,
                        spreadRadius: 20,
                      )
                    ],
                  ),
                ).animate(onPlay: (c) => c.repeat(reverse: true))
                 .moveY(begin: -30, end: 30, duration: (3 + i).seconds, curve: Curves.easeInOutSine)
                 .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: (4 + i).seconds),
              );
            }),

            // Glassmorphic Center Card
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                Container(
                  width: 140,
                  height: 140,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.2),
                        blurRadius: 40,
                        spreadRadius: 10,
                      )
                    ],
                  ),
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/images/logo_icon.png',
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.auto_awesome_rounded,
                        size: 60,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ).animate()
                 .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1), curve: Curves.elasticOut, duration: 1200.ms)
                 .shimmer(delay: 1.seconds, duration: 2.seconds, color: AppTheme.primaryColor.withValues(alpha: 0.1)),

                const SizedBox(height: 40),

                // Branded Text
                Text(
                  "BlinKlean",
                  style: GoogleFonts.outfit(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ).animate()
                 .fadeIn(delay: 400.ms, duration: 800.ms)
                 .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),

                const SizedBox(height: 8),

                // Neon Tagline
                Text(
                  "India's 1st AI Powered QuickClean",
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.secondaryColor,
                    letterSpacing: 1.5,
                  ),
                ).animate()
                 .fadeIn(delay: 800.ms, duration: 800.ms)
                 .shimmer(delay: 2.seconds, duration: 2.seconds),
              ],
            ),

            // Futuristic Loader
            Positioned(
              bottom: 100,
              child: Column(
                children: [
                   SizedBox(
                    width: 150,
                    height: 2,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    ).animate().scaleX(begin: 0, end: 1, duration: 2500.ms, curve: Curves.easeInOutExpo),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Revolutionizing Cleanliness",
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white38,
                    ),
                  ).animate().fadeIn(delay: 1.seconds),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
