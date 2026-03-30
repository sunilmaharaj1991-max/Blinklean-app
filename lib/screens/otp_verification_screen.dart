import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pinput/pinput.dart';
import '../services/auth_service.dart';
import '../core/app_theme.dart';
import '../widgets/brand_logo.dart';
import '../widgets/premium_background.dart';
import '../widgets/glass_card.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final bool isSignUp;

  const OtpVerificationScreen({
    super.key, 
    required this.phoneNumber, 
    this.isSignUp = false,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final AuthService _auth = AuthService();
  bool _isLoading = false;

  Future<void> _handleUserRedirect() async {
    try {
      final authSession = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
      final groups = authSession.userPoolTokensResult.value.idToken.groups;

      if (groups.contains('Admins')) {
        Navigator.pushReplacementNamed(context, '/admin-dashboard');
      } else if (groups.contains('Providers')) {
        Navigator.pushReplacementNamed(context, '/partner-home');
      } else {
        Navigator.pushReplacementNamed(context, '/customer-home');
      }
    } catch (e) {
      safePrint("Error fetching groups: $e");
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    try {
      if (widget.isSignUp) {
        final result = await Amplify.Auth.confirmSignUp(
          username: widget.phoneNumber,
          confirmationCode: _otpController.text.trim(),
        );
        
        if (result.isSignUpComplete) {
          if (mounted) {
            try {
              // Sign in silently to enable attribute updates
              await _auth.signInCustomer(widget.phoneNumber);
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Account verified! Let's set up your profile."), backgroundColor: Colors.green),
                );
                Navigator.pushReplacementNamed(context, '/profile-setup');
              }
            } catch (e) {
               // Fallback to login if auto sign-in fails
               Navigator.pushReplacementNamed(context, '/login');
            }
          }
        }
      } else {
        final result = await Amplify.Auth.confirmSignIn(
          confirmationValue: _otpController.text.trim(),
        );

        if (result.isSignedIn) {
          if (mounted) {
            await _handleUserRedirect();
          }
        }
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid Code: ${e.message}"), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PremiumBackground(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const BrandLogo(size: 64)
                          .animate()
                          .scale(duration: 600.ms, curve: Curves.easeOutBack)
                          .shimmer(delay: 1.seconds),
                      const SizedBox(height: 32),
                      
                      Text(
                        "Verify Identity",
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                      
                      const SizedBox(height: 12),
                      
                      Text(
                        "We've sent a 6-digit code to\n${widget.phoneNumber}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.7),
                          height: 1.5,
                        ),
                      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                      
                      const SizedBox(height: 48),
                      
                      // Premium OTP Input
                      _buildPremiumOtpField()
                          .animate()
                          .fadeIn(delay: 400.ms)
                          .scale(),
                      
                      const SizedBox(height: 48),
                      
                      // Verification Button
                      _buildVerifyButton()
                          .animate()
                          .fadeIn(delay: 500.ms)
                          .slideY(begin: 0.2),
                      
                      const SizedBox(height: 24),
                      
                      TextButton(
                        onPressed: () {
                          // Resend code logic
                        },
                        child: Text(
                          "Resend Code",
                          style: GoogleFonts.outfit(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ).animate().fadeIn(delay: 600.ms),
                    ],
                  ),
                ),
              ),
            ),
            
            // Back Button
            Positioned(
              top: 50,
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumOtpField() {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 64,
      textStyle: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppTheme.secondaryColor, width: 2),
        color: Colors.white.withValues(alpha: 0.1),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.5)),
      ),
    );

    return Pinput(
      length: 6,
      controller: _otpController,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      autofocus: true,
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      onCompleted: (pin) => _verifyOtp(),
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            width: 20,
            height: 2,
            color: AppTheme.secondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyButton() {
    return Container(
      width: double.infinity,
      height: 62,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: _isLoading ? null : _verifyOtp,
        child: _isLoading 
          ? const SizedBox(
              width: 24, height: 24, 
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
            )
          : Text(
              "CONFIRM & CONTINUE",
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
      ),
    );
  }
}

