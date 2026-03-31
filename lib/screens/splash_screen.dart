import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';
import '../services/auth_service.dart';
import 'dart:math' as math;

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
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    _startTransition();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startTransition() async {
    await Future.delayed(const Duration(milliseconds: 4000));
    
    if (!mounted) return;

    bool isSignedIn = false;
    try {
      final user = await AuthService().currentUser;
      isSignedIn = user != null || kDebugMode;
    } catch (e) {
      isSignedIn = kDebugMode;
    }

    if (!mounted) return;

    // Use pushReplacementNamed for cleaner route management
    Navigator.of(context).pushReplacementNamed(
      isSignedIn ? '/customer-home' : '/login'
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 🌌 Galactic Depth Orbs
          ...List.generate(3, (i) {
            final random = math.Random(i + 7);
            return Positioned(
              top: random.nextDouble() * size.height,
              left: random.nextDouble() * size.width - 200,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (i % 2 == 0 ? AppTheme.primaryColor : AppTheme.secondaryColor).withValues(alpha: 0.05),
                      blurRadius: 150,
                    )
                  ],
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .moveY(begin: -50, end: 50, duration: (7 + i).seconds)
               .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.1, 1.1), duration: 10.seconds),
            );
          }),

          // 🌠 Distant Stars
          ...List.generate(15, (i) {
            final random = math.Random(i);
            return Positioned(
              top: random.nextDouble() * size.height,
              left: random.nextDouble() * size.width,
              child: Container(
                width: 2,
                height: 2,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .fadeIn(duration: (2 + (i % 3)).seconds),
            );
          }),

          // 🏮 Center Branding Core
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // 🎇 Outer Orbiting Rings
                  ...List.generate(3, (i) {
                    return RotationTransition(
                      turns: _controller.drive(
                        CurveTween(curve: Curves.linear).chain(
                          Tween(begin: 0.0, end: i % 2 == 0 ? 1.0 : -1.0),
                        ),
                      ),
                      child: Container(
                        width: (140 + (i * 40)).toDouble(),
                        height: (140 + (i * 40)).toDouble(),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1 - (i * 0.02)),
                            width: 1,
                          ),
                        ),
                        child: Align(
                          alignment: i == 0 ? Alignment.topCenter : (i == 1 ? Alignment.bottomRight : Alignment.centerLeft),
                          child: Container(
                            width: (8 + i).toDouble(),
                            height: (8 + i).toDouble(),
                            decoration: BoxDecoration(
                              color: i % 2 == 0 ? AppTheme.primaryColor : AppTheme.secondaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (i % 2 == 0 ? AppTheme.primaryColor : AppTheme.secondaryColor).withValues(alpha: 0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  // 💎 Glass Orb Container
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.03),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          blurRadius: 40,
                          spreadRadius: 10,
                        )
                      ],
                    ),
                    child: Center(
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: const Image(
                              image: AssetImage('assets/images/logo_icon.png'),
                              height: 80,
                              fit: BoxFit.contain,
                            ).animate()
                              .fadeIn(duration: 800.ms)
                              .scale(begin: const Offset(0.2, 0.2), curve: Curves.elasticOut, duration: 1200.ms),
                          ),
                        ),
                      ),
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true))
                   .shimmer(duration: 3.seconds, color: Colors.white12)
                   .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 2.seconds),
                ],
              ),

              const SizedBox(height: 60),

              // 🏷 Modern Branding Text
              Column(
                children: [
                  Text(
                    "BLINKLEAN",
                    style: GoogleFonts.outfit(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 10,
                    ),
                  ).animate()
                   .fadeIn(delay: 600.ms, duration: 1.seconds)
                   .slideY(begin: 0.3, curve: Curves.easeOutBack)
                   .shimmer(delay: 2.seconds, color: AppTheme.secondaryColor, duration: 2.seconds),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      "AUTO DETAILING • HOME WELLNESS",
                      style: GoogleFonts.outfit(
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryColor,
                        letterSpacing: 3,
                      ),
                    ),
                  ).animate()
                   .fadeIn(delay: 1.seconds)
                   .scale(begin: const Offset(0.8, 0.8), duration: 1.seconds, curve: Curves.easeOutQuint),
                ],
              ),
            ],
          ),

          // ⚡ Futuristic Loader Base
          Positioned(
            bottom: 60,
            child: Column(
              children: [
                Container(
                  width: 250,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppTheme.primaryColor.withValues(alpha: 0.5),
                        AppTheme.secondaryColor.withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: AppTheme.secondaryColor.withValues(alpha: 0.8), blurRadius: 10, spreadRadius: 2)
                        ],
                      ),
                    ).animate(onPlay: (c) => c.repeat())
                     .moveX(begin: -125, end: 125, duration: 2.seconds, curve: Curves.easeInOutSine),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "NEXUS OPERATIONAL",
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.white30,
                    letterSpacing: 4,
                  ),
                ).animate().fadeIn(delay: 1.5.seconds),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


