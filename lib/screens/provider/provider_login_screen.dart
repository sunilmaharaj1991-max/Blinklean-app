import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_theme.dart';
import '../../services/auth_service.dart';

class ProviderLoginScreen extends StatefulWidget {
  const ProviderLoginScreen({super.key});

  @override
  State<ProviderLoginScreen> createState() => _ProviderLoginScreenState();
}

class _ProviderLoginScreenState extends State<ProviderLoginScreen> {
  final _idController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;
  bool _isAwaiting = false;

  Future<void> _handleLogin() async {
    if (_idController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final authService = AuthService();
      final result = await authService.signInProvider(
        _idController.text.trim(), // Utilizing Email Alias
        _passController.text.trim(),
      );

      if (result?.isSignedIn ?? false) {
        // Navigate to Home which will check the Role/Group via MainEntry
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAwaiting) return _buildAwaitingScreen();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              FadeInDown(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.security_rounded, color: AppTheme.primaryColor, size: 48),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Provider Portal',
                style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textColor),
              ),
              const SizedBox(height: 12),
              Text(
                'Log in to manage your cleanings and schedules.',
                style: GoogleFonts.outfit(fontSize: 16, color: AppTheme.subtleColor),
              ),
              const SizedBox(height: 64),
              TextField(
                controller: _idController,
                style: GoogleFonts.outfit(),
                decoration: InputDecoration(
                  labelText: 'Provider ID (e.g. RAHUL_4821@)',
                  labelStyle: GoogleFonts.outfit(color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  prefixIcon: const Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _passController,
                obscureText: true,
                style: GoogleFonts.outfit(),
                decoration: InputDecoration(
                  labelText: 'Your Secure Password',
                  labelStyle: GoogleFonts.outfit(color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.textColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 10,
                  ),
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Enter Workspace', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Not a Provider? Go Back Home', style: GoogleFonts.outfit(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAwaitingScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Pulse(
                infinite: true,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.pending_actions_rounded, color: Colors.white, size: 60),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Approval Awaiting',
                style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.textColor),
              ),
              const SizedBox(height: 16),
              Text(
                'The Admin is currently reviewing your application. You will receive an SMS confirmation once your account is active.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 16, color: AppTheme.subtleColor),
              ),
              const SizedBox(height: 64),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.textColor, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () => setState(() => _isAwaiting = false),
                  child: Text('Close Application', style: GoogleFonts.outfit(color: AppTheme.textColor, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
