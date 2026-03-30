import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/service_model.dart';
import '../core/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'service_detail_screen.dart';
import '../widgets/premium_background.dart';
import '../widgets/glass_card.dart';

class AllServicesScreen extends StatefulWidget {
  final String? category;

  const AllServicesScreen({super.key, this.category});

  @override
  State<AllServicesScreen> createState() => _AllServicesScreenState();
}

class _AllServicesScreenState extends State<AllServicesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedFilter = 0;

  final List<Map<String, dynamic>> _filters = [
    {'name': 'All', 'icon': Icons.apps_rounded, 'color': AppTheme.primaryColor},
    {'name': 'Home', 'icon': Icons.home_rounded, 'color': AppTheme.primaryColor},
    {
      'name': 'Vehicle',
      'icon': Icons.directions_car_rounded,
      'color': AppTheme.secondaryColor,
    },
    {
      'name': 'Laundry',
      'icon': Icons.local_laundry_service_rounded,
      'color': AppTheme.secondaryColor,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filters.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedFilter = _tabController.index);
      }
    });

    if (widget.category != null) {
      final index = _filters.indexWhere((f) => f['name'] == widget.category);
      if (index != -1) {
        _selectedFilter = index;
        _tabController.index = index;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ServiceModel> _getFilteredServices() {
    switch (_selectedFilter) {
      case 1:
        return ServiceModel.getHomeCleaningServices();
      case 2:
        return ServiceModel.getVehicleServices();
      case 3:
        return ServiceModel.getLaundryServices();
      default:
        return ServiceModel.getAllServices();
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = _getFilteredServices();
    final selectedColor = _filters[_selectedFilter]['color'] as Color;

    return Scaffold(
      body: Stack(
        children: [
          const PremiumBackground(),
          SafeArea(
            child: Column(
              children: [
                // Glass Header
                _buildHeader(selectedColor, services.length),

                // Filters
                _buildFilters(),

                // Services List
                Expanded(
                  child: services.isEmpty
                      ? _buildEmptyState(selectedColor)
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                          itemCount: services.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return _buildServiceCard(services[index], selectedColor)
                                .animate(delay: (50 * index).ms)
                                .fadeIn(duration: 500.ms)
                                .slideY(begin: 0.1, curve: Curves.easeOutCirc);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color accentColor, int count) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: GlassCard(
              padding: EdgeInsets.zero,
              width: 50,
              height: 50,
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Our Services',
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Professional help at your doorstep',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: accentColor,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  '$count',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 10),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withValues(alpha: 0.4),
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        tabAlignment: TabAlignment.start,
        tabs: _filters.map((filter) {
          final isSelected = _filters.indexOf(filter) == _selectedFilter;
          final color = filter['color'] as Color;
          return AnimatedContainer(
            duration: 400.ms,
            curve: Curves.easeOutQuint,
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [color, color.withValues(alpha: 0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter['icon'] as IconData,
                    size: 18,
                    color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    filter['name'] as String,
                    style: GoogleFonts.outfit(
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildServiceCard(ServiceModel service, Color accentColor) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => ServiceDetailScreen(service: service),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withValues(alpha: 0.2),
                          accentColor.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: service.buildIcon(color: Colors.white, size: 36),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                service.name,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                  color: Colors.white,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(service.category).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _getCategoryColor(service.category).withValues(alpha: 0.3),
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                service.category.split(' ').first.toUpperCase(),
                                style: GoogleFonts.outfit(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: _getCategoryColor(service.category),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          service.shortDescription,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXCLUSIVE PRICE',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.3),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        service.formattedPrice,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accentColor, accentColor.withValues(alpha: 0.8)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          'BOOK NOW',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color accentColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GlassCard(
            width: 100,
            height: 100,
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.auto_mode_rounded,
              size: 40,
              color: accentColor,
            ),
          ).animate(onPlay: (c) => c.repeat()).rotate(duration: 3.seconds),
          const SizedBox(height: 24),
          Text(
            'Expanding Curated List',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Stay tuned for professional additions',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Home Cleaning':
        return AppTheme.primaryColor;
      case 'Vehicle Care':
        return AppTheme.secondaryColor;
      case 'Laundry':
        return AppTheme.secondaryColor;
      default:
        return AppTheme.primaryColor;
    }
  }
}
