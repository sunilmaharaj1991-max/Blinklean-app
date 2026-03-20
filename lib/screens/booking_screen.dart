import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/service_model.dart';
import '../services/payment_service.dart';
import '../core/app_theme.dart';

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
  final SupabaseClient _supabase = Supabase.instance.client;
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _paymentService.initialize(_handleSuccess, _handleFailure, _handleWallet);
    
    // Prefill user data
    final user = _supabase.auth.currentUser;
    if (user != null) {
      _nameController.text = user.userMetadata?['full_name'] ?? '';
      _emailController.text = user.email ?? '';
    }
  }
  
  final TextEditingController _emailController = TextEditingController();

  void _handleSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking Confirmed Successfully!'), backgroundColor: Colors.green),
    );
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _handleFailure(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Failed: ${response.message}'), backgroundColor: Colors.red),
    );
  }

  void _handleWallet(ExternalWalletResponse response) {}

  @override
  void dispose() {
    _addressController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _paymentService.dispose();
    super.dispose();
  }

  void _initiatePayment() {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a date and time slot')));
      return;
    }
    if (_addressController.text.isEmpty || _phoneController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all details')));
       return;
    }

    _paymentService.openCheckout(
      amount: widget.service.startingPrice,
      contact: _phoneController.text,
      email: _emailController.text,
      description: 'Booking for ${widget.service.name}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isVehicle = widget.service.category == 'Vehicle';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Text('Complete Booking', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppTheme.textColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Summary Card (Stitch Design)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.primaryColor.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                    child: Icon(widget.service.icon, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.service.name, style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Order Amount', style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12)),
                        Text('₹${widget.service.startingPrice.toInt()}', style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            _buildSectionHeader('Personal Details'),
            const SizedBox(height: 20),
            _buildInputField(_nameController, 'Full Name', Icons.person_outline_rounded),
            const SizedBox(height: 16),
            _buildInputField(_phoneController, 'Phone Number', Icons.phone_android_rounded, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildInputField(_emailController, 'Email Address', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildInputField(_addressController, 'Service Address', Icons.location_on_outlined, maxLines: 2),

            const SizedBox(height: 40),
            _buildSectionHeader('Schedule Appointment'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildPickerCard(
                    Icons.calendar_today_rounded, 
                    _selectedDate == null ? 'Select Date' : '${_selectedDate!.toLocal()}'.split(' ')[0],
                    () async {
                       final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 30)));
                       if (d != null) setState(() => _selectedDate = d);
                    }
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPickerCard(
                    Icons.access_time_rounded, 
                    _selectedTime == null ? 'Select Time' : _selectedTime!.format(context),
                    () async {
                       final t = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 10, minute: 0));
                       if (t != null) setState(() => _selectedTime = t);
                    }
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
            // Requirement Reminder
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.orange.withAlpha(50)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Colors.orange),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      isVehicle 
                        ? 'Reminder: No water or electricity required from your side.'
                        : 'Reminder: Customer provides water/electricity.',
                      style: GoogleFonts.outfit(fontSize: 13, color: Colors.orange.shade900),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Payable', style: GoogleFonts.outfit(fontSize: 14, color: AppTheme.subtleColor)),
                Text('₹${widget.service.startingPrice.toInt()}', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 8,
                  shadowColor: AppTheme.primaryColor.withValues(alpha: 0.3),
                ),
                onPressed: _initiatePayment,
                child: Text('Confirm & Pay', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5));
  }

  Widget _buildInputField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.subtleColor, letterSpacing: 1)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppTheme.primaryColor, size: 20),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey.shade100)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _buildPickerCard(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 24),
            const SizedBox(height: 8),
            Text(label, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppTheme.textColor)),
          ],
        ),
      ),
    );
  }
}
