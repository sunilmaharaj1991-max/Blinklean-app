import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../services/auth_service.dart';
import '../core/app_theme.dart';

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
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
        );
        _showSuccess("OTP sent to $phone. Please verify.");
        setState(() => _status = AuthStatus.confirming);
      } else {
        final result = await _auth.signInCustomer(phone, _passwordController.text.trim());
        if (result?.nextStep.signInStep == AuthSignInStep.confirmSignInWithSmsMfaCode) {
          setState(() => _status = AuthStatus.confirming);
        } else if (result?.isSignedIn ?? false) {
           // Handled by MainEntry switch
           Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      }
    } catch (e) {
      _showError(e.toString());
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
        // MFA verification
        await Amplify.Auth.confirmSignIn(confirmationValue: _otpController.text.trim());
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Animation
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Image.asset(
                      'assets/images/logo_icon.png',
                      color: Colors.white,
                      errorBuilder: (_, _, _) => const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 30),
                    ),
                  ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack).rotate(begin: -0.1, end: 0),
                  const SizedBox(height: 32),
                  Text(
                    _status == AuthStatus.confirming ? "Verify Mobile" : (_isSignUp ? "Join BlinKlean" : "Welcome Back"),
                    style: GoogleFonts.outfit(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
                  const SizedBox(height: 8),
                  Text(
                    _status == AuthStatus.confirming 
                      ? "Enter the 6-digit code sent to your mobile"
                      : "India's first AI-powered premium vehicle & home care.",
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.white60,
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.2),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Form Area
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (_status != AuthStatus.confirming) ...[
                      if (_isSignUp) 
                        _buildTextField(
                          controller: _nameController,
                          label: "NAME",
                          icon: Icons.person_outline_rounded,
                          hint: "Your Full Name",
                        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
                      const SizedBox(height: 24),
                      if (_isSignUp) ...[
                         _buildTextField(
                          controller: _emailController,
                          label: "EMAIL ADDRESS",
                          icon: Icons.email_outlined,
                          hint: "you@example.com",
                          keyboardType: TextInputType.emailAddress,
                        ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.2),
                        const SizedBox(height: 24),
                      ],
                      _buildTextField(
                        controller: _phoneController,
                        label: "PHONE NUMBER",
                        icon: Icons.phone_android_rounded,
                        hint: "9876543210",
                        keyboardType: TextInputType.phone,
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                      const SizedBox(height: 24),
                      _buildTextField(
                        controller: _passwordController,
                        label: "PASSWORD",
                        icon: Icons.lock_outline_rounded,
                        hint: "••••••••",
                        isPassword: true,
                      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                    ] else 
                      Column(
                        children: [
                          _buildTextField(
                            controller: _otpController,
                            label: "OTP CODE",
                            icon: Icons.security_rounded,
                            hint: "123456",
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () => _auth.resendOTP(_phoneController.text),
                            child: Text(
                              "Resend OTP",
                              style: GoogleFonts.outfit(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn().scale(),

                    const SizedBox(height: 48),

                    // Main Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 10,
                          shadowColor: AppTheme.primaryColor.withValues(alpha: 0.35),
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
                              _status == AuthStatus.confirming ? "Verify & Proceed" : (_isSignUp ? "Create Account" : "Sign In"),
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      ),
                    ).animate(target: _status == AuthStatus.loading ? 0 : 1)
                     .shimmer(delay: 2.seconds, duration: 2.seconds)
                     .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),

                    const SizedBox(height: 24),

                    // Switch Mode Toggle
                    if (_status != AuthStatus.confirming)
                      TextButton(
                        onPressed: () => setState(() => _isSignUp = !_isSignUp),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.outfit(color: AppTheme.subtleColor, fontSize: 14),
                            children: [
                              TextSpan(text: _isSignUp ? "Already a member? " : "New to BlinKlean? "),
                              TextSpan(
                                text: _isSignUp ? "Login" : "Join Now",
                                style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 600.ms)
                    else 
                      TextButton(
                        onPressed: () => setState(() => _status = AuthStatus.idle),
                        child: Text(
                          "Change Phone Number",
                          style: GoogleFonts.outfit(color: Colors.grey, fontWeight: FontWeight.w600),
                        ),
                      ),

                    const SizedBox(height: 40),
                    
                    // Partner Section
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: const Icon(Icons.handshake_rounded, color: AppTheme.primaryColor, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "SERVICE PARTNER?",
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.subtleColor,
                                    letterSpacing: 2,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(context, '/provider-login'),
                                  child: Text(
                                    "Partner Dashboard",
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
                        ],
                      ),
                    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3),

                    if (kDebugMode) ...[
                      const SizedBox(height: 60),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.red.withValues(alpha: 0.1)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.bug_report_rounded, color: Colors.redAccent, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  "DEVELOPER QUICK ACCESS",
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.redAccent,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.center,
                              children: [
                                _buildDebugButton(context, "CUSTOMER", () {
                                  AuthService.setDebugRole(UserRole.customer);
                                  Navigator.pushReplacementNamed(context, '/home');
                                }),
                                _buildDebugButton(context, "PARTNER", () {
                                  AuthService.setDebugRole(UserRole.partner);
                                  Navigator.pushReplacementNamed(context, '/home');
                                }),
                                _buildDebugButton(context, "ADMIN", () {
                                  AuthService.setDebugRole(UserRole.admin);
                                  Navigator.pushReplacementNamed(context, '/home');
                                }),
                              ],
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 1.seconds),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugButton(BuildContext context, String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[100],
        foregroundColor: Colors.black,
        elevation: 0,
        textStyle: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: AppTheme.subtleColor,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 17),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.outfit(color: Colors.grey[300]),
            prefixIcon: Icon(icon, color: AppTheme.primaryColor, size: 22),
            filled: true,
            fillColor: Colors.grey[50],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Colors.grey[100]!, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
        ),
      ],
    );
  }
}
