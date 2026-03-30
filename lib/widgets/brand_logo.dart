import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BrandLogo extends StatelessWidget {
  final double size;
  final bool iconOnly;
  
  const BrandLogo({
    super.key, 
    this.size = 60,
    this.iconOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      iconOnly ? 'assets/images/logo_icon.png' : 'assets/images/logo_full.png',
      height: size,
      fit: BoxFit.contain,
    ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.9, 0.9));
  }
}
