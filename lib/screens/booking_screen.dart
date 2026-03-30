import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/service_model.dart';
import '../services/payment_service.dart';
import '../services/api_service.dart';
import '../core/app_theme.dart';
import '../widgets/premium_background.dart';
import '../widgets/glass_card.dart';

class BookingScreen extends StatefulWidget {
  final ServiceModel service;

  const BookingScreen({super.key, required this.service});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final PaymentService _paymentService = PaymentService();
  final ApiService _api = apiService;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _paymentService.initialize(_handleSuccess, _handleFailure, _handleWallet);
    _loadAmplifyUser();
  }

  Future<void> _loadAmplifyUser() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      String name = '';
      String phone = '';

      for (var attr in attributes) {
        if (attr.userAttributeKey == AuthUserAttributeKey.name) name = attr.value;
        if (attr.userAttributeKey == AuthUserAttributeKey.phoneNumber) phone = attr.value;
      }

      setState(() {
        _nameController.text = name;
        _phoneController.text = phone;
      });
    } catch (e) {
      debugPrint('Error fetching Amplify user for booking: $e');
    }
  }

  void _handleSuccess(PaymentSuccessResponse response) async {
    _processBooking(response.paymentId ?? '');
  }

  void _handleFailure(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.message}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleWallet(ExternalWalletResponse response) {}

  @override
  void dispose() {
    _addressController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _paymentService.dispose();
    super.dispose();
  }

  void _initiatePayment() {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time slot')),
      );
      return;
    }
    if (_addressController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all details')));
      return;
    }

    _processBooking('mock_transaction_${DateTime.now().millisecondsSinceEpoch}');
  }

  void _processBooking(String transactionId) async {
    final bookingData = {
      'service': {
        'serviceId': widget.service.id,
        'name': widget.service.name,
        'category': widget.service.category,
        'icon': widget.service.icon.codePoint.toString(),
      },
      'address': {
        'street': _addressController.text,
        'area': '',
        'city': 'Bengaluru',
      },
      'schedule': {
        'date': _selectedDate?.toIso8601String().split('T')[0] ?? '',
        'time': _selectedTime?.format(context) ?? '',
      },
      'pricing': {
        'basePrice': widget.service.startingPrice,
        'totalPrice': widget.service.startingPrice,
      },
      'payment': {
        'method': 'online',
        'status': 'paid',
        'transactionId': transactionId,
      },
    };

    try {
      await _api.createBooking(bookingData);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking Confirmed Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black26,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          "SECURE BOOKING",
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: PremiumBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 120, 24, 150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Summary Card
              GlassCard(
                padding: const EdgeInsets.all(24),
                color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: widget.service.buildIcon(color: AppTheme.secondaryColor, size: 32),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.service.name,
                            style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'PREMIUM SERVICE',
                            style: GoogleFonts.outfit(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: 0.1),

              const SizedBox(height: 40),
              _buildSectionHeader('PERSONAL DETAILS'),
              const SizedBox(height: 20),
              _buildInputField(_nameController, 'FULL NAME', Icons.person_rounded),
              const SizedBox(height: 16),
              _buildInputField(_phoneController, 'PHONE NUMBER', Icons.phone_android_rounded, keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildInputField(_addressController, 'SERVICE ADDRESS', Icons.location_on_rounded, maxLines: 2),

              const SizedBox(height: 40),
              _buildSectionHeader('SCHEDULE APPOINTMENT'),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildPickerCard(
                      Icons.calendar_today_rounded,
                      _selectedDate == null ? 'SELECT DATE' : '${_selectedDate!.toLocal()}'.split(' ')[0],
                      () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 30)),
                        );
                        if (d != null) setState(() => _selectedDate = d);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildPickerCard(
                      Icons.access_time_rounded,
                      _selectedTime == null ? 'SELECT TIME' : _selectedTime!.format(context),
                      () async {
                        final t = await showTimePicker(
                          context: context,
                          initialTime: const TimeOfDay(hour: 10, minute: 0),
                        );
                        if (t != null) setState(() => _selectedTime = t);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              // Requirement Info
              GlassCard(
                padding: const EdgeInsets.all(20),
                color: Colors.orangeAccent.withValues(alpha: 0.05),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: Colors.orangeAccent, size: 20),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("SERVICE REQUIREMENTS", style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.orangeAccent, letterSpacing: 1)),
                          const SizedBox(height: 4),
                          Text(widget.service.customerProvides, style: GoogleFonts.outfit(fontSize: 13, color: Colors.white70, height: 1.3)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TOTAL PAYABLE', style: GoogleFonts.outfit(fontSize: 10, color: Colors.white30, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              Text('₹${widget.service.startingPrice.toInt()}', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 64,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: ElevatedButton(
              onPressed: _initiatePayment,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              child: Text('CONFIRM & PAY SECURELY', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: Colors.white24,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType, int maxLines = 1}) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white.withValues(alpha: 0.03),
      borderRadius: 20,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          icon: Icon(icon, color: AppTheme.secondaryColor, size: 20),
          hintText: label,
          hintStyle: GoogleFonts.outfit(color: Colors.white24, fontSize: 13, fontWeight: FontWeight.w700),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPickerCard(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: 20,
        child: Column(
          children: [
            Icon(icon, color: AppTheme.secondaryColor, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.outfit(fontWeight: FontWeight.w800, color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
