import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PremiumBackground extends StatelessWidget {
  final Widget? child;
  final List<Color>? glowColors;

  const PremiumBackground({
    super.key,
    this.child,
    this.glowColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A), // Dark Slate
      ),
      child: Stack(
        children: [
          // Background Image with Low Opacity
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.network(
                'https://images.unsplash.com/photo-1557683316-973673baf926?auto=format&fit=crop&q=80&w=1200',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Animated Glow Blobs
          ..._buildGlows(),

          // The Content
          if (child != null) child!,
        ],
      ),
    );
  }

  List<Widget> _buildGlows() {
    final colors = glowColors ?? [
      const Color(0xFF14B351), // BlinKlean Green
      const Color(0xFF00AEEF), // BlinKlean Sky Blue
      const Color(0xFF6366F1), // Indigo accents
    ];

    return [
      // Top Right Glow (Blueish)
      Positioned(
        top: -150,
        right: -100,
        child: _GlowBlob(
          color: colors[1].withValues(alpha: 0.2),
          size: 450,
          duration: 6.seconds,
          moveOffset: const Offset(-80, 100),
        ),
      ),

      // Bottom Left Glow (Greenish)
      Positioned(
        bottom: -100,
        left: -120,
        child: _GlowBlob(
          color: colors[0].withValues(alpha: 0.15),
          size: 400,
          duration: 8.seconds,
          moveOffset: const Offset(100, -80),
        ),
      ),

      // Center Accents (Indigo/Purple)
      Positioned(
        top: 200,
        left: -50,
        child: _GlowBlob(
          color: colors[2].withValues(alpha: 0.1),
          size: 300,
          duration: 10.seconds,
          moveOffset: const Offset(50, 50),
        ),
      ),
    ];
  }
}

class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;
  final Duration duration;
  final Offset moveOffset;

  const _GlowBlob({
    required this.color,
    required this.size,
    required this.duration,
    required this.moveOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            Colors.transparent,
          ],
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
     .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: duration, curve: Curves.easeInOut)
     .move(begin: Offset.zero, end: moveOffset, duration: duration, curve: Curves.easeInOut);
  }
}
