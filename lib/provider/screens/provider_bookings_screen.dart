import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../provider_theme.dart';
import '../models/booking_model.dart';

class ProviderBookingsScreen extends StatefulWidget {
  const ProviderBookingsScreen({super.key});

  @override
  State<ProviderBookingsScreen> createState() => _ProviderBookingsScreenState();
}

class _ProviderBookingsScreenState extends State<ProviderBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<BookingModel> _allBookings = BookingModel.demoBookings();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<BookingModel> _getFilteredBookings(String status) {
    if (status == 'all') return _allBookings;
    return _allBookings.where((b) => b.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProviderTheme.backgroundColor,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 3,
                  indicator: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelStyle: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  unselectedLabelStyle: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  padding: EdgeInsets.zero,
                  tabs: const [
                    Tab(text: ' All '),
                    Tab(text: ' Upcoming '),
                    Tab(text: ' Completed '),
                    Tab(text: ' Cancelled '),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildBookingList('all'),
              _buildBookingList('upcoming'),
              _buildBookingList('completed'),
              _buildBookingList('cancelled'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFilterSheet(),
        backgroundColor: ProviderTheme.primaryColor,
        icon: const Icon(Icons.filter_list_rounded, color: Colors.white),
        label: Text(
          'Filter',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ProviderTheme.primaryColor, ProviderTheme.secondaryColor],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Bookings',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.search_rounded, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${_allBookings.length} total bookings',
            style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(String status) {
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
                color: ProviderTheme.subtleColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) => _buildBookingCard(bookings[index]),
    );
  }

  Widget _buildBookingCard(BookingModel booking) {
    Color statusColor;
    IconData statusIcon;
    switch (booking.status) {
      case 'upcoming':
        statusColor = ProviderTheme.warningColor;
        statusIcon = Icons.schedule_rounded;
        break;
      case 'completed':
        statusColor = ProviderTheme.successColor;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'cancelled':
        statusColor = ProviderTheme.errorColor;
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusColor = ProviderTheme.subtleColor;
        statusIcon = Icons.help_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ProviderTheme.primaryColor.withValues(alpha: 0.12),
                            ProviderTheme.secondaryColor.withValues(
                              alpha: 0.12,
                            ),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _getServiceIcon(booking.serviceCategory),
                        color: ProviderTheme.primaryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.serviceName,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            booking.customerName,
                            style: GoogleFonts.outfit(
                              color: ProviderTheme.subtleColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 14, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            booking.status.toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: ProviderTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      _buildInfoItem(
                        Icons.calendar_today_rounded,
                        booking.scheduledDate,
                      ),
                      Container(
                        height: 30,
                        width: 1,
                        color: Colors.grey.shade300,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      _buildInfoItem(
                        Icons.access_time_rounded,
                        booking.scheduledTime,
                      ),
                      Container(
                        height: 30,
                        width: 1,
                        color: Colors.grey.shade300,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      _buildInfoItem(
                        Icons.attach_money_rounded,
                        '₹${booking.price.toInt()}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ProviderTheme.backgroundColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  size: 18,
                  color: ProviderTheme.subtleColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    booking.customerAddress,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: ProviderTheme.subtleColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (booking.status == 'upcoming')
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showBookingDetails(booking),
                      icon: const Icon(Icons.info_outline_rounded, size: 18),
                      label: const Text('Details'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: ProviderTheme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.play_arrow_rounded, size: 18),
                      label: const Text('Start'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ProviderTheme.successColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: ProviderTheme.subtleColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  IconData _getServiceIcon(String category) {
    switch (category) {
      case 'Home Cleaning':
        return Icons.home_rounded;
      case 'Vehicle Care':
        return Icons.directions_car_rounded;
      case 'Laundry':
        return Icons.local_laundry_service_rounded;
      default:
        return Icons.cleaning_services_rounded;
    }
  }

  void _showBookingDetails(BookingModel booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Booking Details',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Booking ID', booking.id),
            _buildDetailRow('Service', booking.serviceName),
            _buildDetailRow('Customer', booking.customerName),
            _buildDetailRow('Phone', booking.customerPhone),
            _buildDetailRow('Date', booking.scheduledDate),
            _buildDetailRow('Time', booking.scheduledTime),
            _buildDetailRow('Price', '₹${booking.price.toInt()}'),
            _buildDetailRow('Payment', booking.paymentStatus.toUpperCase()),
            if (booking.notes.isNotEmpty)
              _buildDetailRow('Notes', booking.notes),
            const SizedBox(height: 20),
            Text(
              'Address',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ProviderTheme.subtleColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              booking.customerAddress,
              style: GoogleFonts.outfit(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(color: ProviderTheme.subtleColor),
          ),
          Text(value, style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Bookings',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Service Type',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['All', 'Home Cleaning', 'Vehicle Care', 'Laundry']
                  .map(
                    (s) => FilterChip(
                      label: Text(s),
                      selected: s == 'All',
                      onSelected: (v) {},
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Date Range',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Today', 'This Week', 'This Month', 'Custom']
                  .map(
                    (s) => FilterChip(
                      label: Text(s),
                      selected: s == 'Today',
                      onSelected: (v) {},
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _StickyTabBarDelegate(this.tabBar);

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ProviderTheme.primaryColor, ProviderTheme.secondaryColor],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: tabBar,
      ),
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height + 16;

  @override
  double get minExtent => tabBar.preferredSize.height + 16;

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) => false;
}
