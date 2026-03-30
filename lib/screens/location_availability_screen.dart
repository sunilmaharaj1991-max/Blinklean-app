import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/app_theme.dart';
import 'main_navigation_screen.dart';
import '../core/app_state.dart';
import '../services/location_service.dart';
import '../widgets/premium_background.dart';
import '../widgets/glass_card.dart';

class LocationAvailabilityScreen extends StatefulWidget {
  const LocationAvailabilityScreen({super.key});

  @override
  State<LocationAvailabilityScreen> createState() =>
      _LocationAvailabilityScreenState();
}

class _LocationAvailabilityScreenState
    extends State<LocationAvailabilityScreen> {
  final TextEditingController _pincodeController = TextEditingController();
  final LocationService _locationService = LocationService();
  bool _isChecking = false;
  bool? _isAvailable;
  String? _areaName;
  String? _errorText;

  Future<void> _handleCheckAvailability() async {
    final pincode = _pincodeController.text.trim();
    if (pincode.length != 6) {
      setState(() => _errorText = 'Enter a valid 6-digit Pincode');
      return;
    }

    setState(() {
      _isChecking = true;
      _errorText = null;
      _isAvailable = null;
    });

    try {
      final result = await _locationService.checkServiceAvailability(pincode);
      setState(() {
        _isAvailable = result['available'];
        _areaName = result['area'];
        _isChecking = false;
      });
    } catch (e) {
      setState(() {
        _errorText = 'Something went wrong. Try again.';
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PremiumBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                
                // Animated Icon Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Hero(
                    tag: 'location_search_icon',
                    child: Icon(
                      Icons.location_searching_rounded,
                      size: 56,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ).animate()
                 .scale(duration: 600.ms, curve: Curves.easeOutBack)
                 .shimmer(delay: 1.seconds, duration: 1.5.seconds),
                
                const SizedBox(height: 32),
                
                Text(
                  'Check Service Area',
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                
                const SizedBox(height: 12),
                
                Text(
                  'Enter your pincode to see if BlinkLean\nis available in your neighborhood.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                
                const SizedBox(height: 40),
                
                // Pincode Input Card
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildPincodeField(),
                      const SizedBox(height: 24),
                      _buildCheckButton(),
                    ],
                  ),
                ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.95, 0.95)),

                const SizedBox(height: 40),

                // Result View or Popular Areas
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _isAvailable != null
                      ? _buildResultView()
                      : _buildRecentAreas(),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPincodeField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        controller: _pincodeController,
        keyboardType: TextInputType.number,
        maxLength: 6,
        style: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 12,
        ),
        textAlign: TextAlign.center,
        cursorColor: AppTheme.primaryColor,
        decoration: InputDecoration(
          counterText: '',
          hintText: '000000',
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.1),
            letterSpacing: 12,
          ),
          errorText: _errorText,
          errorStyle: GoogleFonts.outfit(color: Colors.redAccent),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
        onChanged: (val) {
          if (val.length == 6) {
            _handleCheckAvailability();
          }
        },
      ),
    );
  }

  Widget _buildCheckButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isChecking ? null : _handleCheckAvailability,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: _isChecking
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(
                'CHECK AVAILABILITY',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
      ),
    );
  }

  Widget _buildResultView() {
    final bool available = _isAvailable!;
    final Color color = available ? Colors.tealAccent : Colors.orangeAccent;
    final IconData icon = available 
        ? Icons.check_circle_outline_rounded 
        : Icons.info_outline_rounded;

    return GlassCard(
      key: ValueKey('result_$available'),
      padding: const EdgeInsets.all(24),
      borderOpacity: 0.2,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 48),
          ),
          const SizedBox(height: 20),
          Text(
            available ? 'Great News!' : 'Coming Soon!',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            available 
                ? 'Services are available in $_areaName.'
                : 'We haven\'t reached your area yet, but we\'re expanding fast!',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          if (available)
            _buildStartBookingButton()
          else
            _buildNotifyMeSection(),
        ],
      ),
    );
  }

  Widget _buildStartBookingButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.tealAccent.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.tealAccent.withValues(alpha: 0.3)),
      ),
      child: TextButton(
        onPressed: () {
          AppState().setLocation(
            _pincodeController.text, 
            _isAvailable!, 
            _areaName
          );
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, anim, _) => FadeTransition(opacity: anim, child: const MainNavigationScreen()),
              transitionDuration: const Duration(milliseconds: 800),
            ),
          );
        },
        child: Text(
          'START BOOKING',
          style: GoogleFonts.outfit(
            color: Colors.tealAccent,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildNotifyMeSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: TextField(
            style: GoogleFonts.outfit(color: Colors.white),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Enter Phone Number',
              hintStyle: GoogleFonts.outfit(color: Colors.white24),
              prefixText: '+91 ',
              prefixStyle: GoogleFonts.outfit(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
             // Notify logic
          },
          child: Text(
            'NOTIFY ME ON LAUNCH',
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentAreas() {
    return Column(
      key: const ValueKey('popular_areas'),
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: Colors.white10)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'POPULAR AREAS',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.white54,
                  letterSpacing: 2,
                ),
              ),
            ),
            const Expanded(child: Divider(color: Colors.white10)),
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            _buildAreaChip('Vijayanagar', '560040'),
            _buildAreaChip('Rajajinagar', '560023'),
            _buildAreaChip('R.R Nagar', '560098'),
          ],
        ),
      ],
    );
  }

  Widget _buildAreaChip(String name, String pin) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _pincodeController.text = pin;
          _handleCheckAvailability();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_rounded, size: 14, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              Text(
                name,
                style: GoogleFonts.outfit(
                  fontSize: 14, 
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
