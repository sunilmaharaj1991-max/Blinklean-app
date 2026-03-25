import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../admin_theme.dart';

class AdminServicesScreen extends StatefulWidget {
  const AdminServicesScreen({super.key});

  @override
  State<AdminServicesScreen> createState() => _AdminServicesScreenState();
}

class _AdminServicesScreenState extends State<AdminServicesScreen> {
  final List<_ServiceCategory> _categories = [
    _ServiceCategory('Home Cleaning', Icons.home_rounded, [
      _ServiceItem('1BHK Deep Cleaning', 1499, true),
      _ServiceItem('2BHK Deep Cleaning', 2199, true),
      _ServiceItem('3BHK Deep Cleaning', 2999, true),
      _ServiceItem('Kitchen Cleaning', 1299, true),
      _ServiceItem('Bathroom Cleaning', 599, true),
      _ServiceItem('Sofa Cleaning', 399, true),
      _ServiceItem('Carpet Cleaning', 25, true),
      _ServiceItem('Office Cleaning', 3, true),
    ]),
    _ServiceCategory('Vehicle Care', Icons.directions_car_rounded, [
      _ServiceItem('Car Waterless Wash', 299, true),
      _ServiceItem('Car Interior + Exterior', 499, true),
      _ServiceItem('Car Premium Polish', 699, true),
      _ServiceItem('Bike Waterless Clean', 149, true),
      _ServiceItem('Bike Premium Polish', 249, true),
      _ServiceItem('Auto Rickshaw Cleaning', 299, true),
      _ServiceItem('Bicycle Wash', 99, true),
    ]),
    _ServiceCategory('Laundry', Icons.local_laundry_service_rounded, [
      _ServiceItem('Wash & Fold', 79, true),
      _ServiceItem('Wash & Iron', 99, true),
      _ServiceItem('Steam Iron Only', 10, true),
      _ServiceItem('Dry Cleaning', 149, true),
    ]),
    _ServiceCategory('Scrap & Recycling', Icons.recycling_rounded, [
      _ServiceItem('Paper', 0, true),
      _ServiceItem('Plastic', 0, true),
      _ServiceItem('Metal', 0, true),
      _ServiceItem('E-Waste', 0, true),
      _ServiceItem('Cardboard', 0, true),
      _ServiceItem('Glass', 0, true),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminTheme.backgroundColor,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: _categories.length,
              itemBuilder: (context, index) =>
                  _buildCategoryCard(_categories[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddServiceDialog(),
        backgroundColor: AdminTheme.primaryColor,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Add Service',
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
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Services & Pricing',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Manage services and their pricing',
            style: GoogleFonts.outfit(color: AdminTheme.subtleColor),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(_ServiceCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getCategoryColor(category.name),
                  _getCategoryColor(category.name).withValues(alpha: 0.7),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(category.icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '${category.services.length} services',
                        style: GoogleFonts.outfit(
                          color: Colors.white70,
                          fontSize: 12,
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
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Active',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...category.services.map((s) => _buildServiceRow(s)),
        ],
      ),
    );
  }

  Widget _buildServiceRow(_ServiceItem service) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              service.name,
              style: GoogleFonts.outfit(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              service.price == 0 ? 'Market Rate' : '₹${service.price}',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: service.price == 0
                    ? AdminTheme.accentOrange
                    : AdminTheme.primaryColor,
              ),
            ),
          ),
          if (service.price != 0)
            Text(
              '/unit',
              style: GoogleFonts.outfit(
                color: AdminTheme.subtleColor,
                fontSize: 11,
              ),
            ),
          const SizedBox(width: 16),
          Switch(
            value: service.isActive,
            onChanged: (v) {},
            activeTrackColor: AdminTheme.successColor.withValues(alpha: 0.5),
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AdminTheme.successColor;
              }
              return Colors.grey;
            }),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.edit_rounded,
              color: AdminTheme.subtleColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Home Cleaning':
        return AdminTheme.primaryColor;
      case 'Vehicle Care':
        return AdminTheme.secondaryColor;
      case 'Laundry':
        return AdminTheme.accentOrange;
      case 'Scrap & Recycling':
        return const Color(0xFF00BFA5);
      default:
        return AdminTheme.primaryColor;
    }
  }

  void _showAddServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add New Service',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Service Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _categories
                  .map(
                    (c) => DropdownMenuItem(value: c.name, child: Text(c.name)),
                  )
                  .toList(),
              onChanged: (v) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(onPressed: () {}, child: const Text('Add Service')),
        ],
      ),
    );
  }
}

class _ServiceCategory {
  final String name;
  final IconData icon;
  final List<_ServiceItem> services;
  _ServiceCategory(this.name, this.icon, this.services);
}

class _ServiceItem {
  final String name;
  final double price;
  final bool isActive;
  _ServiceItem(this.name, this.price, this.isActive);
}
