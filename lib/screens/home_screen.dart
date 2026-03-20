import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';
import 'scrap_screen.dart';
import 'all_services_screen.dart';
import 'location_availability_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _heroController = PageController();
  int _heroActive = 0;

  final List<Map<String, String>> _heroBanners = [
    {
      'title': "India's 1st AI Powered QuickClean",
      'subtitle': 'Smart cleaning tailored for your modern lifestyle.',
      'image': '✨',
      'accent': '#009543',
    },
    {
      'title': 'Eco-Friendly Waterless Car Care',
      'subtitle': 'Saving 150L of water with every signature wash.',
      'image': '🚗',
      'accent': '#00ADEF',
    },
    {
      'title': 'The Blink Recycle Program',
      'subtitle': 'Turn your household scrap into instant rewards.',
      'image': '♻️',
      'accent': '#009543',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9), 
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 100,
            floating: true,
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 8,
            shadowColor: Colors.black.withValues(alpha: 0.05),
            toolbarHeight: 80,
            leadingWidth: 180,
            leading: Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 12, bottom: 12),
              child: Image.asset(
                'assets/images/logo_full.png',
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => Text('BlinKlean', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: AppTheme.primaryColor, fontSize: 24)),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 24),
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade100)),
                child: IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded, color: AppTheme.textColor, size: 24)),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMinimalistLocationBar(),
                _buildEditorialShowcase(),
                const SizedBox(height: 48),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Core Services', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                          const SizedBox(height: 8),
                          Text('Premium care for your everyday needs.', style: GoogleFonts.outfit(fontSize: 14, color: AppTheme.subtleColor)),
                        ],
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const AllServicesScreen())),
                        child: Text('See All', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildAdvancedServiceGrid(),
                const SizedBox(height: 48),
                _buildTrustBanner(),
                const SizedBox(height: 32),
                _buildCommitmentHighlight(),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalistLocationBar() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_rounded, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('YOUR LOCATION', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.subtleColor, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text('Checking availability...', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textColor)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const LocationAvailabilityScreen())),
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorialShowcase() {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _heroController,
            onPageChanged: (v) => setState(() => _heroActive = v),
            itemCount: _heroBanners.length,
            itemBuilder: (context, i) {
              final Color accentColor = Color(int.parse(_heroBanners[i]['accent']!.replaceAll('#', '0xFF')));
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [accentColor, accentColor.withValues(alpha: 0.8)],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            child: Text('FEATURED', style: GoogleFonts.outfit(color: accentColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 220,
                            child: Text(_heroBanners[i]['title']!, style: GoogleFonts.outfit(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.1)),
                          ),
                          const SizedBox(height: 8),
                          Text(_heroBanners[i]['subtitle']!, style: GoogleFonts.outfit(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                        ],
                      ),
                    ),
                    Positioned(right: 32, bottom: 32, child: Text(_heroBanners[i]['image']!, style: const TextStyle(fontSize: 60))),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_heroBanners.length, (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.all(4),
            height: 6,
            width: _heroActive == i ? 24 : 6,
            decoration: BoxDecoration(color: _heroActive == i ? AppTheme.primaryColor : Colors.grey.shade200, borderRadius: BorderRadius.circular(3)),
          )),
        ),
      ],
    );
  }

  Widget _buildAdvancedServiceGrid() {
    final services = [
      {'name': 'Home Deep', 'icon': Icons.home_work_rounded, 'color': AppTheme.primaryColor},
      {'name': 'Waterless VIP', 'icon': Icons.directions_car_filled_rounded, 'color': AppTheme.secondaryColor},
      {'name': 'Smart Laundry', 'icon': Icons.local_laundry_service_rounded, 'color': AppTheme.primaryColor},
      {'name': 'Scrap Sell', 'icon': Icons.recycling_rounded, 'color': AppTheme.secondaryColor},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1,
        ),
        itemCount: services.length,
        itemBuilder: (c, i) => InkWell(
          onTap: () {
            if (services[i]['name'] == 'Scrap Sell') {
              Navigator.push(context, MaterialPageRoute(builder: (c) => const ScrapScreen()));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (c) => const AllServicesScreen()));
            }
          },
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 8))],
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: (services[i]['color'] as Color).withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(services[i]['icon'] as IconData, color: services[i]['color'] as Color, size: 36),
                ),
                const SizedBox(height: 16),
                Text(services[i]['name'] as String, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrustBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTrustItem('4.8+', 'Rating'),
          _buildTrustItem('1,000+', 'Happy Clients'),
          _buildTrustItem('Verified', 'Professionals'),
        ],
      ),
    );
  }

  Widget _buildTrustItem(String val, String label) {
    return Column(
      children: [
        Text(val, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.outfit(fontSize: 10, color: AppTheme.subtleColor, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
      ],
    );
  }

  Widget _buildCommitmentHighlight() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          const Icon(Icons.bolt_rounded, color: AppTheme.primaryColor, size: 40),
          const SizedBox(height: 16),
          Text(
            'Clean in a Blink',
            style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            "India's first AI Powered QuickClean Platform. We bring advanced clean-tech to your doorstep, saving time and water while keeping your modern lifestyle sparkling clean.",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(color: AppTheme.subtleColor, height: 1.6),
          ),
        ],
      ),
    );
  }
}
