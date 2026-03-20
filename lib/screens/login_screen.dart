import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../core/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  
  bool _isSignUp = false;
  bool _isLoading = false;
  final AuthService _authService = AuthService();


  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      if (_isSignUp) {
        await _authService.registerWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
        );
      } else {
        await _authService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Premium Branding Header (Stitch Tonal Principle)
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor.withValues(alpha: 0.1),
                    AppTheme.secondaryColor.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(60)),
              ),
              child: Stack(
                children: [
                   Positioned(
                    top: 60,
                    left: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/logo_icon.png',
                          height: 70,
                          errorBuilder: (c, e, s) => const Icon(Icons.bolt, size: 60, color: AppTheme.primaryColor),
                        ),
                        const SizedBox(height: 12),
                         Image.asset(
                          'assets/images/logo_full.png',
                          height: 30,
                          errorBuilder: (c, e, s) => Text('BlinKlean', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.textColor)),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 24,
                    right: 24,
                    child: Text(
                      'THE NEW ERA OF\nECO-CARE',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1,
                        color: AppTheme.primaryColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_isSignUp ? 'Create Account' : 'Welcome Back', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -1)),
                    const SizedBox(height: 8),
                    Text(_isSignUp ? 'Join the community for a cleaner tomorrow.' : 'Sign in to access your dashboard.', style: GoogleFonts.outfit(color: AppTheme.subtleColor)),
                    const SizedBox(height: 32),

                    if (_isSignUp) ...[
                      _buildTextField(_nameController, 'FULL NAME', Icons.person_outline_rounded),
                      const SizedBox(height: 20),
                      _buildTextField(_phoneController, 'PHONE NUMBER', Icons.phone_android_rounded, keyboardType: TextInputType.phone),
                      const SizedBox(height: 20),
                    ],

                    _buildTextField(_emailController, 'EMAIL ADDRESS', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 20),
                    _buildTextField(_passwordController, 'PASSWORD', Icons.lock_outline_rounded, isPassword: true),

                    if (_isSignUp) ...[
                      const SizedBox(height: 20),
                      _buildTextField(_addressController, 'FULL ADDRESS (WITH PINCODE)', Icons.location_on_outlined, maxLines: 2),
                    ],

                    const SizedBox(height: 48),

                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                          elevation: 12,
                          shadowColor: AppTheme.primaryColor.withValues(alpha: 0.3),
                        ),
                        onPressed: _isLoading ? null : _submit,
                        child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(_isSignUp ? 'Sign Up' : 'Login', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Center(
                      child: TextButton(
                        onPressed: () => setState(() => _isSignUp = !_isSignUp),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.outfit(color: AppTheme.subtleColor, fontSize: 14),
                            children: [
                              TextSpan(text: _isSignUp ? "Already have an account? " : "Don't have an account? "),
                              TextSpan(text: _isSignUp ? 'Sign In' : 'Sign Up', style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                            ],
                          ),
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

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false, TextInputType? keyboardType, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: AppTheme.subtleColor)),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 16),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppTheme.primaryColor, size: 22),
            filled: true,
            fillColor: AppTheme.primaryColor.withValues(alpha: 0.03),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.transparent)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.red, width: 1)),
            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.red, width: 2)),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Field required' : null,
        ),
      ],
    );
  }
}
