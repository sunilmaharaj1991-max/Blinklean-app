import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';
import 'main_navigation_screen.dart';
import '../core/app_state.dart';
import '../services/location_service.dart';

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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundColor,
              AppTheme.primaryColor.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Hero(
                  tag: 'app_logo',
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_searching_rounded,
                      size: 60,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Check Service Area',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Enter your pincode to see if BlinkLean\nis available in your neighborhood.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 50),
                
                // Pincode Input Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _pincodeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: '000000',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade300,
                            letterSpacing: 8,
                          ),
                          errorText: _errorText,
                          prefixIcon: const Icon(Icons.pin_drop_outlined),
                        ),
                        onChanged: (val) {
                          if (val.length == 6) {
                            _handleCheckAvailability();
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isChecking ? null : _handleCheckAvailability,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor: AppTheme.primaryColor,
                          ),
                          child: _isChecking
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'Check Availability',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Result View
                if (_isAvailable != null)
                  _buildResultView()
                else if (!_isChecking && _pincodeController.text.isEmpty)
                   _buildRecentAreas(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultView() {
    final Color color = _isAvailable! ? Colors.green : Colors.orange;
    final IconData icon = _isAvailable! 
        ? Icons.check_circle_outline_rounded 
        : Icons.info_outline_rounded;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 50),
          const SizedBox(height: 16),
          Text(
            _isAvailable! ? 'Great News!' : 'Coming Soon!',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isAvailable! 
                ? 'Services are available in $_areaName.'
                : 'We haven\'t reached your area yet, but we\'re expanding fast!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 15),
          ),
          const SizedBox(height: 24),
          if (_isAvailable!)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  AppState().setLocation(
                    _pincodeController.text, 
                    _isAvailable!, 
                    _areaName
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainNavigationScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Start Booking'),
              ),
            )
          else
            Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Phone for Notify',
                    hintStyle: GoogleFonts.poppins(fontSize: 14),
                    prefixText: '+91 ',
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                     // Notify logic
                  },
                  child: const Text('Notify Me'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRecentAreas() {
    return Column(
      children: [
        Text(
          'Popular Areas',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
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
    return InkWell(
      onTap: () {
        _pincodeController.text = pin;
        _handleCheckAvailability();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          name,
          style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.primaryColor),
        ),
      ),
    );
  }
}
