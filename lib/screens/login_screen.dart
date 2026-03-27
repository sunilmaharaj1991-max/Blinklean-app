import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
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
  final _otpController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  AuthStatus _status = AuthStatus.idle;
  bool _isSignUp = false;

  @override
  void dispose() {
    _phoneController.dispose();
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
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
        );
        _showSuccess("OTP sent to $phone. Please verify.");
        setState(() => _status = AuthStatus.confirming);
      } else {
        final result = await _auth.signInWithPhone(
          phone,
          _passwordController.text.trim(),
        );
        if (result?.nextStep.signInStep == AuthSignInStep.confirmSignInWithSmsMfaCode) {
          setState(() => _status = AuthStatus.confirming);
        } else if (result?.isSignedIn ?? false) {
           // Handled by Authenticator or Main Navigation
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
            FadeInDown(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF009543), Color(0xFF00ADEF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.bolt_rounded, color: AppTheme.primaryColor, size: 32),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _status == AuthStatus.confirming ? "Verify Mobile" : (_isSignUp ? "Join BlinKlean" : "Welcome Back"),
                      style: GoogleFonts.outfit(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      _status == AuthStatus.confirming 
                        ? "Enter the 6-digit code sent to you"
                        : "Premium Quick-Clean Services at your doorstep.",
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, '/provider-login'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.handyman_rounded, color: Colors.white70, size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Are you a BlinKlean Partner?",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        "LOGIN HERE",
                        style: GoogleFonts.outfit(
                          color: AppTheme.secondaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Form Area
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (_status != AuthStatus.confirming) ...[
                      if (_isSignUp) 
                        FadeInUp(
                          child: _buildTextField(
                            controller: _nameController,
                            label: "NAME",
                            icon: Icons.person_outline_rounded,
                            hint: "Your Full Name",
                          ),
                        ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 100),
                        child: _buildTextField(
                          controller: _phoneController,
                          label: "PHONE NUMBER",
                          icon: Icons.phone_android_rounded,
                          hint: "9876543210",
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: _buildTextField(
                          controller: _passwordController,
                          label: "PASSWORD",
                          icon: Icons.lock_outline_rounded,
                          hint: "••••••••",
                          isPassword: true,
                        ),
                      ),
                    ] else 
                      FadeInUp(
                        child: Column(
                          children: [
                            Text(
                              "We've sent an OTP to your phone",
                              style: GoogleFonts.outfit(color: Colors.grey, fontSize: 13),
                            ),
                            const SizedBox(height: 24),
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
                        ),
                      ),

                    const SizedBox(height: 48),

                    // Main Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
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
                          ? const Center(child: CircularProgressIndicator(color: Colors.white))
                          : Text(
                              _status == AuthStatus.confirming ? "Verify & Proceed" : (_isSignUp ? "Create Account" : "Sign In"),
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Switch Mode Toggle
                    if (_status != AuthStatus.confirming)
                      FadeIn(
                        delay: const Duration(milliseconds: 500),
                        child: TextButton(
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
                        ),
                      )
                    else 
                      TextButton(
                        onPressed: () => setState(() => _status = AuthStatus.idle),
                        child: Text(
                          "Change Phone Number",
                          style: GoogleFonts.outfit(color: Colors.grey, fontWeight: FontWeight.w600),
                        ),
                      ),

                    const SizedBox(height: 32),
                    FadeIn(
                      delay: const Duration(milliseconds: 700),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.handshake_rounded, color: AppTheme.primaryColor),
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
                                      "Login to Partner Portal",
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
