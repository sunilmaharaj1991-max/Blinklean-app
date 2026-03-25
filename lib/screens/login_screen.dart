import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../core/app_theme.dart';

enum AuthMode { emailSignIn, emailSignUp, phoneRequest, phoneVerify }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _otpController = TextEditingController();

  AuthMode _authMode = AuthMode.emailSignIn;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _switchMode(AuthMode newMode) {
    _animationController.reverse().then((_) {
      setState(() => _authMode = newMode);
      _animationController.forward();
    });
  }

  Future<void> _submitEmailAuth() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      if (_authMode == AuthMode.emailSignUp) {
        String phoneInput = _phoneController.text.trim();
        if (!phoneInput.startsWith('+')) phoneInput = '+91$phoneInput';

        await _authService.registerWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
          phone: phoneInput,
          address: _addressController.text.trim(),
        );

        await _authService.sendVerificationOTP(phoneInput);
        _switchMode(AuthMode.phoneVerify);
      } else {
        await _authService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      }
    } catch (e) {
      _showError(_getErrorMessage(e.toString()));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _requestPhoneOTP() async {
    if (_phoneController.text.trim().isEmpty) {
      _showError("Please enter a valid phone number.");
      return;
    }
    setState(() => _isLoading = true);
    try {
      String phone = _phoneController.text.trim();
      if (!phone.startsWith('+')) {
        phone = '+91$phone';
      }
      await _authService.sendVerificationOTP(phone);
      _switchMode(AuthMode.phoneVerify);
    } catch (e) {
      _showError(_getErrorMessage(e.toString()));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyPhoneOTP() async {
    if (_otpController.text.trim().isEmpty) {
      _showError("Please enter the OTP.");
      return;
    }
    setState(() => _isLoading = true);
    try {
      String phone = _phoneController.text.trim();
      if (!phone.startsWith('+')) phone = '+91$phone';

      await _authService.verifyPhoneOTP(phone, _otpController.text.trim());
    } catch (e) {
      _showError(_getErrorMessage(e.toString()));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      _showError(_getErrorMessage(e.toString()));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('user-disabled')) {
      return 'This account has been disabled.';
    }
    if (error.contains('wrong-password')) {
      return 'Incorrect password. Please try again.';
    }
    if (error.contains('user-not-found')) {
      return 'No account found with this email.';
    }
    if (error.contains('email-already-in-use')) {
      return 'An account already exists with this email.';
    }
    if (error.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    }
    if (error.contains('weak-password')) {
      return 'Password should be at least 6 characters.';
    }
    if (error.contains('image.png') || error.contains('DEVELOPER_ERROR')) {
      return 'Google Sign-In requires SHA-1 fingerprint setup in Firebase Console.';
    }
    if (error.contains('popup_closed')) return 'Sign-In cancelled.';
    if (error.contains('invalid-phone-number')) {
      return 'Please enter a valid phone number.';
    }
    if (error.contains('quotaExceeded')) {
      return 'Too many requests. Please try again later.';
    }
    if (error.contains('invalid-verification-code')) {
      return 'Invalid OTP. Please check and try again.';
    }
    if (error.contains('session-expired')) {
      return 'Session expired. Please request a new OTP.';
    }
    if (error.contains('credential-already-in-use')) {
      return 'This phone number is already linked to another account.';
    }
    return error.split('Exception:').last.split(':').last.trim();
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: GoogleFonts.outfit(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
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
            // Premium Header with BlinKlean Branding
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo and Company Name Row
                      Row(
                        children: [
                          // Logo Container
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.bolt_rounded,
                                size: 36,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Company Name
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BlinKlean',
                                style: GoogleFonts.outfit(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                'Premium Home Services',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Taglines
                      Text(
                        "India's 1st",
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.white60,
                        ),
                      ),
                      Text(
                        'AI Powered QuickClean',
                        style: GoogleFonts.outfit(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Premium Home Services & Scrap Recycling',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Form Area
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderTexts(),
                      const SizedBox(height: 28),

                      // Google Sign-In Button
                      if (_authMode == AuthMode.emailSignIn ||
                          _authMode == AuthMode.emailSignUp)
                        _buildGoogleButton(),

                      const SizedBox(height: 24),

                      // Divider
                      if (_authMode == AuthMode.emailSignIn ||
                          _authMode == AuthMode.emailSignUp) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Divider(color: Colors.grey.shade300),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                "OR",
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(color: Colors.grey.shade300),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Input Fields
                      ..._buildInputFields(),

                      const SizedBox(height: 28),

                      // Action Button
                      _buildMainActionButton(),

                      const SizedBox(height: 20),

                      // Toggle Mode
                      _buildModeToggleButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return InkWell(
      onTap: _isLoading ? null : _loginWithGoogle,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Image.network(
                'https://www.google.com/favicon.ico',
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.g_mobiledata_rounded, color: Colors.red),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Continue with Google",
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTexts() {
    String title = "";
    String subtitle = "";
    switch (_authMode) {
      case AuthMode.emailSignIn:
        title = "Welcome Back";
        subtitle = "Sign in to manage your bookings.";
        break;
      case AuthMode.emailSignUp:
        title = "Create Account";
        subtitle = "Join us for a cleaner tomorrow.";
        break;
      case AuthMode.phoneRequest:
        title = "Verify Phone";
        subtitle = "Enter your phone number.";
        break;
      case AuthMode.phoneVerify:
        title = "Verify OTP";
        subtitle = "Enter the code sent to your phone.";
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.outfit(color: AppTheme.subtleColor, fontSize: 15),
        ),
      ],
    );
  }

  List<Widget> _buildInputFields() {
    if (_authMode == AuthMode.emailSignUp) {
      return [
        _buildTextField(
          _nameController,
          'FULL NAME',
          Icons.person_outline_rounded,
        ),
        const SizedBox(height: 14),
        _buildTextField(
          _phoneController,
          'PHONE NUMBER',
          Icons.phone_android_rounded,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 14),
        _buildTextField(
          _emailController,
          'EMAIL ADDRESS',
          Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _buildTextField(
          _passwordController,
          'PASSWORD',
          Icons.lock_outline_rounded,
          isPassword: true,
        ),
        const SizedBox(height: 14),
        _buildTextField(
          _addressController,
          'ADDRESS',
          Icons.location_on_outlined,
          maxLines: 2,
        ),
      ];
    } else if (_authMode == AuthMode.emailSignIn) {
      return [
        _buildTextField(
          _emailController,
          'EMAIL ADDRESS',
          Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _buildTextField(
          _passwordController,
          'PASSWORD',
          Icons.lock_outline_rounded,
          isPassword: true,
        ),
      ];
    } else if (_authMode == AuthMode.phoneRequest) {
      return [
        _buildTextField(
          _phoneController,
          'PHONE NUMBER',
          Icons.phone_android_rounded,
          keyboardType: TextInputType.phone,
          hintText: "9876543210",
        ),
      ];
    } else {
      return [
        _buildTextField(
          _otpController,
          'OTP CODE',
          Icons.security_rounded,
          keyboardType: TextInputType.number,
          hintText: "123456",
        ),
      ];
    }
  }

  Widget _buildMainActionButton() {
    String label = "Sign In";
    VoidCallback action = _submitEmailAuth;

    if (_authMode == AuthMode.emailSignUp) {
      label = "Create Account";
    } else if (_authMode == AuthMode.phoneRequest) {
      label = "Send OTP";
      action = _requestPhoneOTP;
    } else if (_authMode == AuthMode.phoneVerify) {
      label = "Verify & Login";
      action = _verifyPhoneOTP;
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: AppTheme.primaryColor.withValues(alpha: 0.4),
        ),
        onPressed: _isLoading ? null : action,
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  Widget _buildModeToggleButtons() {
    if (_authMode == AuthMode.phoneRequest ||
        _authMode == AuthMode.phoneVerify) {
      return Center(
        child: TextButton(
          onPressed: () => _switchMode(AuthMode.emailSignIn),
          child: Text(
            "← Back to Email Login",
            style: GoogleFonts.outfit(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    } else {
      bool isSignUp = _authMode == AuthMode.emailSignUp;
      return Center(
        child: TextButton(
          onPressed: () => _switchMode(
            isSignUp ? AuthMode.emailSignIn : AuthMode.emailSignUp,
          ),
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.outfit(
                color: AppTheme.subtleColor,
                fontSize: 15,
              ),
              children: [
                TextSpan(
                  text: isSignUp
                      ? "Already have an account? "
                      : "Don't have an account? ",
                ),
                TextSpan(
                  text: isSignUp ? 'Sign In' : 'Sign Up',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPassword = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppTheme.subtleColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 16),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.outfit(color: Colors.grey.shade400),
            prefixIcon: Icon(icon, color: AppTheme.primaryColor, size: 22),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppTheme.primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? 'This field is required' : null,
        ),
      ],
    );
  }
}
