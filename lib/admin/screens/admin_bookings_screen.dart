import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../admin_theme.dart';
import '../models/admin_models.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<BookingAdminModel> _allBookings = BookingAdminModel.demoBookings();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<BookingAdminModel> _getFilteredBookings(String status) {
    var bookings = _allBookings;
    if (status != 'all') {
      bookings = bookings.where((b) => b.status == status).toList();
    }
    if (_searchQuery.isNotEmpty) {
      bookings = bookings
          .where(
            (b) =>
                b.customerName.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                b.providerName.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                b.serviceName.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                b.id.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
    return bookings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminTheme.backgroundColor,
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildTabs(),
          Expanded(child: _buildBookingsList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bookings Management',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_allBookings.length} total bookings',
                style: GoogleFonts.outfit(color: AdminTheme.subtleColor),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Booking'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AdminTheme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: AdminTheme.subtleColor),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search by customer, provider, service...',
                  hintStyle: GoogleFonts.outfit(color: AdminTheme.subtleColor),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AdminTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: AdminTheme.primaryColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AdminTheme.primaryColor,
        unselectedLabelColor: AdminTheme.subtleColor,
        indicatorColor: AdminTheme.primaryColor,
        indicatorWeight: 3,
        isScrollable: true,
        labelStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Pending'),
          Tab(text: 'Upcoming'),
          Tab(text: 'In Progress'),
          Tab(text: 'Completed'),
        ],
      ),
    );
  }

  Widget _buildBookingsList() {
    final statuses = ['all', 'pending', 'upcoming', 'in_progress', 'completed'];
    return TabBarView(
      controller: _tabController,
      children: statuses.map((s) => _buildBookingGrid(s)).toList(),
    );
  }

  Widget _buildBookingGrid(String status) {
    final bookings = _getFilteredBookings(status);
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No bookings found',
              style: GoogleFonts.outfit(
                color: AdminTheme.subtleColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.8,
      ),
      itemCount: bookings.length,
      itemBuilder: (context, index) => _buildBookingCard(bookings[index]),
    );
  }

  Widget _buildBookingCard(BookingAdminModel booking) {
    Color statusColor;
    IconData statusIcon;
    switch (booking.status) {
      case 'completed':
        statusColor = AdminTheme.successColor;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'in_progress':
        statusColor = AdminTheme.warningColor;
        statusIcon = Icons.autorenew_rounded;
        break;
      case 'pending':
        statusColor = AdminTheme.accentOrange;
        statusIcon = Icons.pending_rounded;
        break;
      default:
        statusColor = AdminTheme.secondaryColor;
        statusIcon = Icons.schedule_rounded;
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      booking.status.replaceAll('_', ' ').toUpperCase(),
                      style: GoogleFonts.outfit(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '#${booking.id}',
                style: GoogleFonts.outfit(
                  color: AdminTheme.subtleColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            booking.serviceName,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            booking.serviceCategory,
            style: GoogleFonts.outfit(
              color: AdminTheme.subtleColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.person_rounded,
                size: 14,
                color: AdminTheme.subtleColor,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  booking.customerName,
                  style: GoogleFonts.outfit(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.engineering_rounded,
                size: 14,
                color: AdminTheme.subtleColor,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  booking.providerName,
                  style: GoogleFonts.outfit(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${booking.price.toInt()}',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AdminTheme.primaryColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AdminTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  booking.scheduledDate,
                  style: GoogleFonts.outfit(fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
