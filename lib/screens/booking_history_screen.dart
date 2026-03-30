import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/app_theme.dart';
import '../services/api_service.dart';
import '../widgets/premium_background.dart';
import '../widgets/glass_card.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  List<dynamic> _bookings = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await apiService.getUserBookings();
      if (!mounted) return;
      setState(() {
        _bookings = response['bookings'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  double get _totalSpent {
    double total = 0;
    for (var b in _bookings) {
      if (b['status'] == 'Completed') {
        final amountText = b['amount']?.toString().replaceAll(RegExp(r'[^0-9.]'), '') ?? '0';
        total += double.tryParse(amountText) ?? 0;
      }
    }
    return total;
  }

  int get _completedCount => _bookings.where((b) => b['status'] == 'Completed').length;

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
          "BOOKING HISTORY",
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
        child: RefreshIndicator(
          onRefresh: _fetchBookings,
          backgroundColor: Colors.grey[900],
          color: AppTheme.secondaryColor,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 120)),

              // Stats Row
              SliverToBoxAdapter(
                child: _isLoading 
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          _buildMiniStat('Total', _bookings.length.toString(), Icons.receipt_long_rounded, Colors.blueAccent),
                          const SizedBox(width: 12),
                          _buildMiniStat('Finished', _completedCount.toString(), Icons.verified_rounded, AppTheme.secondaryColor),
                          const SizedBox(width: 12),
                          _buildMiniStat('Spent', '₹${_totalSpent.toStringAsFixed(0)}', Icons.payments_rounded, Colors.orangeAccent),
                        ],
                      ).animate().fadeIn().slideY(begin: 0.1),
                    ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // Bookings List
              if (_isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppTheme.secondaryColor),
                  ),
                )
              else if (_errorMessage != null)
                SliverFillRemaining(child: _buildErrorState())
              else if (_bookings.isEmpty)
                SliverFillRemaining(child: _buildEmptyState())
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final booking = _bookings[index];
                        return _buildBookingCard(booking, index);
                      },
                      childCount: _bookings.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 16),
        color: Colors.white.withValues(alpha: 0.05),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 9,
                color: Colors.white30,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking, int index) {
    final status = booking['status']?.toString() ?? 'Pending';
    final statusColor = _getStatusColor(status);
    final serviceName = booking['service']?.toString() ?? 'Cleaning Service';
    final amount = booking['amount']?.toString() ?? '₹0';
    final dateStr = booking['date']?.toString() ?? 'N/A';
    final timeStr = booking['time']?.toString() ?? 'N/A';

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(_getServiceIcon(serviceName), color: AppTheme.secondaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceName,
                      style: GoogleFonts.outfit(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 12, color: Colors.white30),
                        const SizedBox(width: 6),
                        Text(dateStr, style: GoogleFonts.outfit(fontSize: 12, color: Colors.white60)),
                        const SizedBox(width: 12),
                        Icon(Icons.access_time_rounded, size: 12, color: Colors.white30),
                        const SizedBox(width: 6),
                        Text(timeStr, style: GoogleFonts.outfit(fontSize: 12, color: Colors.white60)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: statusColor,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Text(
                amount.contains('₹') ? amount : '₹$amount',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: (100 * index).ms).fadeIn().slideX(begin: 0.1);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.white10),
          const SizedBox(height: 24),
          Text(
            'No Bookings Yet',
            style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            'Your service history will appear here\nonce you make your first booking.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(fontSize: 15, color: Colors.white30),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('EXPLORE SERVICES', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 13, letterSpacing: 1)),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 64, color: Colors.redAccent),
            const SizedBox(height: 24),
            Text(
              'Connection Error',
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage ?? 'Unable to sync with AWS',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(color: Colors.white38),
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: _fetchBookings,
              child: Text('RETRY CONNECTION', style: GoogleFonts.outfit(color: AppTheme.secondaryColor, fontWeight: FontWeight.w900, letterSpacing: 1)),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getServiceIcon(String serviceName) {
    serviceName = serviceName.toLowerCase();
    if (serviceName.contains('car') || serviceName.contains('vehicle')) {
      return Icons.directions_car_filled_rounded;
    }
    if (serviceName.contains('cleaning')) {
      return Icons.cleaning_services_rounded;
    }
    if (serviceName.contains('laundry')) {
      return Icons.local_laundry_service_rounded;
    }
    if (serviceName.contains('scrap') || serviceName.contains('recycling')) {
      return Icons.recycling_rounded;
    }
    return Icons.miscellaneous_services_rounded;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'finished':
        return AppTheme.secondaryColor;
      case 'in progress':
      case 'active':
        return Colors.blueAccent;
      case 'pending':
        return Colors.orangeAccent;
      case 'cancelled':
        return Colors.redAccent;
      default:
        return Colors.white24;
    }
  }
}
