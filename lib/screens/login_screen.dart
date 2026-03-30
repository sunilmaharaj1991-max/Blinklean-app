import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import '../services/auth_service.dart';
import '../core/app_theme.dart';
import '../widgets/brand_logo.dart';
import '../widgets/premium_background.dart';
import '../widgets/glass_card.dart';

enum AuthStatus { idle, loading, confirming }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  AuthStatus _status = AuthStatus.idle;
  bool _isSignUp = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _status = AuthStatus.loading);
    try {
      String phone = _phoneController.text.trim();
      if (!phone.startsWith('+')) phone = '+91$phone';

      if (_isSignUp) {
        await _auth.registerWithPhone(
          phoneNumber: phone,
        );
        _showSuccess("Welcome! Verification code sent to $phone.");
        if (mounted) {
          Navigator.pushNamed(context, '/verify-otp', arguments: {
            'phoneNumber': phone,
            'isSignUp': true,
          });
        }
      } else {
        final result = await _auth.signInCustomer(phone);
            
        if (result?.nextStep.signInStep == AuthSignInStep.confirmSignInWithCustomChallenge) {
          _showSuccess("Check your mobile for verification code.");
          if (mounted) {
            Navigator.pushNamed(context, '/verify-otp', arguments: {
              'phoneNumber': phone,
              'isSignUp': false,
            });
          }
        } else if (result?.isSignedIn ?? false) {
           Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      }
    } on UserNotFoundException {
      _showError("Account not found. Please click 'Get Started' to sign up first.");
      setState(() => _isSignUp = true);
    } catch (e) {
      _showError("Authentication failed: ${e.toString()}");
    } finally {
      if (mounted && _status != AuthStatus.confirming) {
        setState(() => _status = AuthStatus.idle);
      }
    }
  }

  Future<void> _verifyOTP() async {
    setState(() => _status = AuthStatus.loading);
    try {
      String phone = _phoneController.text.trim();
      if (!phone.startsWith('+')) phone = '+91$phone';
      
      if (_isSignUp) {
        await _auth.confirmRegistrationOTP(phone, _otpController.text.trim());
        _showSuccess("Account verified! You can now sign in.");
        setState(() {
          _isSignUp = false;
          _status = AuthStatus.idle;
        });
      } else {
        // MFA verification or Custom Challenge
        await _auth.confirmSignInOTP(_otpController.text.trim());
      }
    } catch (e) {
      _showError(e.toString());
      setState(() => _status = AuthStatus.confirming);
    } finally {
      if (mounted && _status != AuthStatus.idle) {
        setState(() => _status = AuthStatus.idle);
      }
    }
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
      );
    }
  }

  void _showSuccess(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PremiumBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🏢 Branding Layer
                  const BrandLogo(size: 80, iconOnly: true)
                    .animate()
                    .scale(duration: 800.ms, curve: Curves.easeOutBack)
                    .rotate(begin: -0.1, end: 0)
                    .shimmer(delay: 2.seconds),
                  
                  const SizedBox(height: 24),
                  
                  Text(
                    "BlinKlean",
                    style: GoogleFonts.outfit(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1.5,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                  
                  Text(
                    _isSignUp ? "Experience Premium Cleaning" : "Welcome Back",
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: Colors.white60,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 48),

                  // 🧊 Frosted Form Container
                  GlassCard(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (_status != AuthStatus.confirming) ...[
                            if (_isSignUp) ...[
                              _buildPremiumField(
                                controller: _nameController,
                                hint: "Full Name",
                                icon: Icons.person_outline_rounded,
                              ).animate().fadeIn(delay: 500.ms),
                              const SizedBox(height: 20),
                              _buildPremiumField(
                                controller: _emailController,
                                hint: "Email (Optional)",
                                icon: Icons.alternate_email_rounded,
                                keyboardType: TextInputType.emailAddress,
                              ).animate().fadeIn(delay: 600.ms),
                              const SizedBox(height: 20),
                            ],
                            _buildPremiumField(
                              controller: _phoneController,
                              hint: "Mobile Number",
                              icon: Icons.phone_iphone_rounded,
                              keyboardType: TextInputType.phone,
                            ).animate().fadeIn(delay: 700.ms),
                          ] else 
                            Column(
                              children: [
                                Text(
                                  "VERIFY MOBILE",
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.secondaryColor,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                _buildPremiumField(
                                  controller: _otpController,
                                  hint: "6-Digit OTP",
                                  icon: Icons.lock_clock_rounded,
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ).animate().fadeIn().scale(),

                          const SizedBox(height: 40),

                          // ⚡ Action Button
                          _buildActionButton()
                              .animate(target: _status == AuthStatus.loading ? 0 : 1)
                              .shimmer(delay: 2.seconds, duration: 2.seconds),
                          
                          const SizedBox(height: 24),
                          
                          // 🔄 Mode Switcher
                          if (_status != AuthStatus.confirming)
                            TextButton(
                              onPressed: () => setState(() => _isSignUp = !_isSignUp),
                              style: TextButton.styleFrom(foregroundColor: Colors.white60),
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.outfit(fontSize: 14),
                                  children: [
                                    TextSpan(text: _isSignUp ? "Already a member? " : "New here? "),
                                    TextSpan(
                                      text: _isSignUp ? "Log In" : "Get Started",
                                      style: const TextStyle(
                                        color: AppTheme.secondaryColor, 
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animate().fadeIn(delay: 900.ms),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),

                  const SizedBox(height: 48),

                  // 🤝 Role Switch Section
                  if (_status == AuthStatus.idle) ...[
                    const Text(
                      "OR CONTINUE AS",
                      style: TextStyle(
                        color: Colors.white24,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ).animate().fadeIn(delay: 1.2.seconds),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildModernRoleBtn("Partner", Icons.handshake_rounded, () {
                           Navigator.pushNamed(context, '/provider-login');
                        }),
                        const SizedBox(width: 16),
                        _buildModernRoleBtn("Admin", Icons.admin_panel_settings_rounded, () {
                           Navigator.pushNamed(context, '/admin-login');
                        }),
                      ],
                    ).animate().fadeIn(delay: 1.4.seconds),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
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
        onPressed: _status == AuthStatus.loading 
          ? null 
          : (_status == AuthStatus.confirming ? _verifyOTP : _handleAuth),
        child: _status == AuthStatus.loading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
            )
          : Text(
              _status == AuthStatus.confirming 
                ? "Verify & Continue" 
                : "Get Fast Access",
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
      ),
    );
  }

  Widget _buildModernRoleBtn(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white54, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.outfit(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.outfit(color: Colors.white24, fontSize: 16),
          prefixIcon: Icon(icon, color: AppTheme.secondaryColor.withValues(alpha: 0.7), size: 22),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppTheme.secondaryColor, width: 1.5),
          ),
          contentPadding: const EdgeInsets.all(20),
        ),
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
      ),
    );
  }
}
