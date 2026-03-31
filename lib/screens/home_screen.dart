import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import '../core/app_theme.dart';
import '../models/service_model.dart';
import 'scrap_screen.dart';
import 'all_services_screen.dart';
import 'service_detail_screen.dart';
import 'location_selection_screen.dart';
import '../widgets/brand_logo.dart';
import '../widgets/premium_background.dart';
import '../widgets/glass_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _popularScrollController = ScrollController();
  Timer? _scrollTimer;
  late Future<List<ServiceModel>> _servicesFuture;

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_popularScrollController.hasClients) {
        if (_scrollTimer == null || !_scrollTimer!.isActive) return;
        
        final maxScroll = _popularScrollController.position.maxScrollExtent;
        final currentScroll = _popularScrollController.position.pixels;
        final scrollAmount = 194.0;

        if (currentScroll + scrollAmount >= maxScroll + 10) {
          _popularScrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutExpo,
          );
        } else {
          _popularScrollController.animateTo(
            currentScroll + scrollAmount,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
          );
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _servicesFuture = ServiceModel.fetchAllServices();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _tabController.dispose();
    _popularScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: PremiumBackground(
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: false,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white.withValues(alpha: 0.4),
                          indicatorColor: AppTheme.primaryColor,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorWeight: 3,
                          indicator: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryColor.withValues(alpha: 0.2),
                                AppTheme.secondaryColor.withValues(alpha: 0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          labelStyle: GoogleFonts.outfit(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                          unselectedLabelStyle: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          tabs: const [
                            Tab(text: 'Home'),
                            Tab(text: 'Vehicle'),
                            Tab(text: 'Laundry'),
                            Tab(text: 'Scrap'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            body: AnimatedSwitcher(
              duration: 600.ms,
              switchInCurve: Curves.easeOutQuart,
              child: FutureBuilder<List<ServiceModel>>(
                key: ValueKey<int>(_tabController.index),
                future: _servicesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildSkeletonLoader();
                  }
                  
                  final services = snapshot.data ?? ServiceModel.getAllServices();
                  
                  return TabBarView(
                    controller: _tabController,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildHomeTab(services),
                      _buildVehicleTab(services),
                      _buildLaundryTab(services),
                      _buildScrapTab(),
                    ],
                  ).animate().fadeIn(duration: 400.ms);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: List.generate(4, (i) => 
          GlassCard(
            margin: const EdgeInsets.only(bottom: 16),
            height: 100,
            child: Shimmer.fromColors(
              baseColor: Colors.white10,
              highlightColor: Colors.white24,
              child: Container(color: Colors.white),
            ),
          ).animate(delay: (i * 100).ms).fadeIn().slideY(begin: 0.1),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: const BrandLogo(size: 32),
                  ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WELCOME TO',
                        style: GoogleFonts.outfit(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (c) => const LocationSelectionScreen()),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_rounded, color: AppTheme.primaryColor, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              'Check Service Area',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white60, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  _buildHeaderAction(Icons.search_rounded),
                  const SizedBox(width: 12),
                  _buildHeaderAction(Icons.notifications_none_rounded, hasBadge: true),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withValues(alpha: 0.2),
                      AppTheme.secondaryColor.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Text(
                  "PREMIUM CLEANING EXPERIENCE",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
              const SizedBox(height: 16),
              Text(
                'Luxury Care for\nEverything You Own',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  letterSpacing: -1.2,
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2).shimmer(delay: 1.5.seconds, duration: 2.seconds),
              const SizedBox(height: 16),
              Text(
                'BlinKlean uses state-of-the-art waterless technology\nand professional eco-friendly methods.',
                style: GoogleFonts.outfit(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 13,
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 500.ms),
            ],
          ),
        ),
        const SizedBox(height: 40),
        GlassCard(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildModernStat('150L', 'WATER SAVED'),
              _buildVerticalDivider(),
              _buildModernStat('4.9★', 'CLIENT RATING'),
              _buildVerticalDivider(),
              _buildModernStat('PAN', 'INDIA SERVICE'),
            ],
          ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.9, 0.9)),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildHeaderAction(IconData icon, {bool hasBadge = false}) {
    return Stack(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        if (hasBadge)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppTheme.accentColor,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0F172A), width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildModernStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            color: Colors.white38,
            fontSize: 8,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white12,
    );
  }

  Widget _buildHomeTab(List<ServiceModel> services) {
    final popularServices = services.take(4).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildSectionTitle(
              'Popular Services',
              Icons.local_fire_department_rounded,
              AppTheme.primaryColor,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
          const SizedBox(height: 16),
          SizedBox(
            height: 260,
            child: ListView.builder(
              controller: _popularScrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: popularServices.length,
              itemBuilder: (context, index) {
                final service = popularServices[index];
                return _buildModernPopularCard(service)
                    .animate(delay: (200 + (index * 100)).ms)
                    .fadeIn(duration: 500.ms)
                    .slideX(begin: 0.2, curve: Curves.easeOutCubic);
              },
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildSectionTitle(
              'Home Wellness',
              Icons.spa_rounded,
              AppTheme.primaryColor,
            ),
          ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: services
                  .where((s) => s.category == 'Home Cleaning')
                  .take(4)
                  .map((s) => _buildServiceItem(s))
                  .toList()
                  .animate(interval: 50.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.1),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const AllServicesScreen()),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withValues(alpha: 0.1),
                      AppTheme.secondaryColor.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All Services',
                      style: GoogleFonts.outfit(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppTheme.primaryColor,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildModernPopularCard(ServiceModel service) {
    return GlassCard(
      width: 200,
      margin: const EdgeInsets.only(right: 14, bottom: 12),
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => ServiceDetailScreen(service: service)),
        ),
        borderRadius: BorderRadius.circular(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                child: Stack(
                  children: [
                    Image.network(
                      service.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service.formattedPrice,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.white54),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleTab(List<ServiceModel> services) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVehicleHero(),
          const SizedBox(height: 24),
          _buildSectionTitle(
            'Car Services',
            Icons.directions_car_rounded,
            AppTheme.secondaryColor,
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
          const SizedBox(height: 14),
          ...services
              .where((s) => s.category == 'Vehicle Care' && s.id.contains('car'))
              .map((s) => _buildServiceItem(s))
              .toList()
              .animate(interval: 50.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1),
          const SizedBox(height: 24),
          _buildSectionTitle(
            'Bike & Others',
            Icons.two_wheeler_rounded,
            AppTheme.primaryColor,
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),
          const SizedBox(height: 14),
          ...services
              .where(
                (s) =>
                    s.category == 'Vehicle Care' &&
                    (s.id.contains('bike') ||
                    s.id.contains('auto') ||
                    s.id.contains('cycle')),
              )
              .map((s) => _buildServiceItem(s))
              .toList()
              .animate(interval: 50.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildVehicleHero() {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1552933529-e359b24772ff?auto=format&fit=crop&q=80&w=1200',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.black.withValues(alpha: 0.2),
                ],
              ),
            ),
          ),
          Positioned(
            left: 24,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'WATERLESS TECH',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Precision\nVehicle Care',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Save 150L water per wash.',
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildLaundryTab(List<ServiceModel> services) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLaundryHero(),
          const SizedBox(height: 24),
          _buildSectionTitle(
            'Laundry Services',
            Icons.local_laundry_service_rounded,
            AppTheme.secondaryColor,
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
          const SizedBox(height: 14),
          ...services.where((s) => s.category == 'Laundry').map((s) => _buildServiceItem(s))
              .toList()
              .animate(interval: 50.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildLaundryHero() {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1545173159-bb1d333af55d?auto=format&fit=crop&q=80&w=1200',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.black.withValues(alpha: 0.3),
                ],
              ),
            ),
          ),
          Positioned(
            left: 24,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'HYGIENIC WASH',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Premium\nLaundry Care',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Quick, professional, and safe.',
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrapTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScrapHero(),
          const SizedBox(height: 24),
          _buildSectionTitle(
            'What We Collect',
            Icons.recycling_rounded,
            AppTheme.primaryColor,
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
          const SizedBox(height: 14),
          _buildScrapCategories(),
          const SizedBox(height: 24),
          _buildSectionTitle(
            'Service Areas',
            Icons.location_on_rounded,
            AppTheme.primaryColor,
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
          const SizedBox(height: 14),
          _buildServiceZones(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildScrapHero() {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => const ScrapScreen()),
        ),
        child: Stack(
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?auto=format&fit=crop&q=80&w=1200',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 24,
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'ECO RECLAMATION',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Turn Scrap\nInto Value',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AI-Powered Fair Pricing.',
                    style: GoogleFonts.outfit(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_rounded, color: AppTheme.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrapCategories() {
    final items = [
      {'name': 'Paper', 'icon': '📄'},
      {'name': 'Plastic', 'icon': '🥤'},
      {'name': 'Metal', 'icon': '🔩'},
      {'name': 'E-Waste', 'icon': '📱'},
      {'name': 'Cardboard', 'icon': '📦'},
      {'name': 'Glass', 'icon': '🫙'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item['icon']!, style: const TextStyle(fontSize: 30)),
              const SizedBox(height: 8),
              Text(
                item['name'] as String,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceZones() {
    final zones = [
      'Vijayanagar',
      'Rajajinagar',
      'R.R Nagar',
      'Chandra Layout',
      'Hassan',
      'Amaravathi',
    ];

    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: zones
                .map(
                  (zone) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 13,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          zone,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.amber,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Price will be informed on pickup based on current market rates',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: Colors.amber,
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

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceItem(ServiceModel service) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => ServiceDetailScreen(service: service),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withValues(alpha: 0.1),
                      AppTheme.secondaryColor.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: service.buildIcon(
                  color: AppTheme.primaryColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      service.shortDescription,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      service.formattedPrice,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 11,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        service.estimatedDuration,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 72;

  @override
  double get minExtent => 72;

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
