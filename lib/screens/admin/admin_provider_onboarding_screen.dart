import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_theme.dart';
import '../../services/provider_onboarding_service.dart';
import '../../utils/provider_id_helper.dart';

class AdminProviderOnboardingScreen extends StatefulWidget {
  const AdminProviderOnboardingScreen({super.key});

  @override
  State<AdminProviderOnboardingScreen> createState() => _AdminProviderOnboardingScreenState();
}

class _AdminProviderOnboardingScreenState extends State<AdminProviderOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _experienceController = TextEditingController();
  
  String _serviceType = 'Cleaning';
  bool _isVerified = false;
  bool _isLoading = false;

  final List<String> _serviceTypes = ['Cleaning', 'Laundry', 'Vehicle Detailing', 'Scrap Pickup'];

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    try {
      final onboardingService = ProviderOnboardingService();
      
      // Generate Provider ID
      final providerId = ProviderIdHelper.generate(_nameController.text);

      await onboardingService.createProviderAccount(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        serviceType: _serviceType,
        experience: _experienceController.text.trim(),
        verified: _isVerified,
        providerId: providerId,
      );

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: Text('Provider account created!\nID: $providerId'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('New Provider', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.textColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create a new service provider account',
                style: GoogleFonts.outfit(fontSize: 16, color: AppTheme.subtleColor),
              ),
              const SizedBox(height: 32),
              
              _buildField('Full Name', _nameController, Icons.person_outline_rounded),
              _buildField('Phone Number', _phoneController, Icons.phone_android_rounded, keyboardType: TextInputType.phone),
              _buildField('Email (Optional)', _emailController, Icons.email_outlined, keyboardType: TextInputType.emailAddress, required: false),
              _buildField('Detailed Address', _addressController, Icons.location_on_outlined, maxLines: 2),
              _buildField('Work Experience/Bio', _experienceController, Icons.history_edu_rounded, maxLines: 3),
              
              const SizedBox(height: 16),
              Text('Service Category', style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: AppTheme.textColor)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _serviceType,
                    isExpanded: true,
                    items: _serviceTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) => setState(() => _serviceType = val!),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              SwitchListTile(
                title: Text('Verification Status', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                subtitle: const Text('Mark as verified immediately?'),
                value: _isVerified,
                onChanged: (val) => setState(() => _isVerified = val),
				activeThumbColor: AppTheme.primaryColor,
              ),
              
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Create Account', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {bool required = true, TextInputType? keyboardType, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: AppTheme.textColor)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: GoogleFonts.outfit(),
            validator: required ? (v) => v!.isEmpty ? 'Required' : null : null,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppTheme.primaryColor),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
