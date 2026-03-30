import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/api_service.dart';
import '../core/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/premium_background.dart';
import '../widgets/glass_card.dart';

class ScrapScreen extends StatefulWidget {
  const ScrapScreen({super.key});

  @override
  State<ScrapScreen> createState() => _ScrapScreenState();
}

class _ScrapScreenState extends State<ScrapScreen> {
  final Map<String, IconData> _categoryIcons = {
    'Paper': Icons.description_rounded,
    'Plastic': Icons.inventory_2_rounded,
    'Metal': Icons.settings_rounded,
    'Glass': Icons.wine_bar_rounded,
    'E-Waste': Icons.devices_rounded,
    'Cardboard': Icons.view_in_ar_rounded,
  };

  final Map<String, String> _categoryDescriptions = {
    'Paper': 'Newspapers, books',
    'Plastic': 'Bottles, bags',
    'Metal': 'Iron, aluminum',
    'Glass': 'Bottles, jars',
    'E-Waste': 'Old electronics',
    'Cardboard': 'Boxes, packagings',
  };

  final Map<String, String> _categoryBackgrounds = {
    'Paper': 'https://images.unsplash.com/photo-1583521214690-7338ef470086?auto=format&fit=crop&q=80&w=800',
    'Plastic': 'https://images.unsplash.com/photo-1620843343382-72352885976b?auto=format&fit=crop&q=80&w=800',
    'Metal': 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&q=80&w=800',
    'Glass': 'https://images.unsplash.com/photo-1610444583731-971759547ea5?auto=format&fit=crop&q=80&w=800',
    'E-Waste': 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?auto=format&fit=crop&q=80&w=800',
    'Cardboard': 'https://images.unsplash.com/photo-1512412086192-9115ed93cee8?auto=format&fit=crop&q=80&w=800',
  };

  String? _selectedCategory;
  final TextEditingController _weightController = TextEditingController();
  final List<Map<String, dynamic>> _scrapItems = [];
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final ScrollController _categoryScrollController = ScrollController();
  Timer? _scrollTimer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_categoryScrollController.hasClients) {
        final maxScroll = _categoryScrollController.position.maxScrollExtent;
        final currentScroll = _categoryScrollController.position.pixels;
        const scrollAmount = 142.0;

        if (currentScroll + scrollAmount >= maxScroll + 5) {
          _categoryScrollController.animateTo(
            0,
            duration: 1200.ms,
            curve: Curves.easeInOutExpo,
          );
        } else {
          _categoryScrollController.animateTo(
            currentScroll + scrollAmount,
            duration: 1000.ms,
            curve: Curves.easeOutQuart,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _categoryScrollController.dispose();
    _weightController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _addScrapItem() {
    final weightError = Validators.validateWeight(_weightController.text);
    if (_selectedCategory == null) {
      _showSnack('Please select a material category', Colors.orange);
      return;
    }
    if (weightError != null) {
      _showSnack(weightError, Colors.redAccent);
      return;
    }

    double weight = double.parse(_weightController.text);
    setState(() {
      _scrapItems.add({'category': _selectedCategory, 'weight': weight});
      _selectedCategory = null;
      _weightController.clear();
    });
    Feedback.forTap(context);
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  double get _totalWeight {
    return _scrapItems.fold(0, (sum, item) => sum + (item['weight'] as double));
  }

  void _submitScrapPickup() async {
    if (_addressController.text.isEmpty || _nameController.text.isEmpty || _phoneController.text.isEmpty) {
      _showSnack('Please fill all contact details', Colors.orange);
      return;
    }
    if (_scrapItems.isEmpty) {
      _showSnack('Please add at least one item', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final pickupData = {
        'name': _nameController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'items': _scrapItems,
        'totalWeight': _totalWeight,
        'status': 'pending',
        'type': 'scrap_pickup',
        'createdAt': DateTime.now().toIso8601String(),
      };

      await apiService.createScrapPickup(pickupData);

      if (mounted) {
        _showSnack('Scrap pickup requested successfully! ♻️', Colors.green);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) _showSnack('Failed to book pickup: $e', Colors.redAccent);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const PremiumBackground(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildNavHeader(),
                  const SizedBox(height: 20),
                  _buildHeroCard().animate().fadeIn(duration: 600.ms).slideY(begin: -0.1),
                  const SizedBox(height: 32),
                  _buildHowToBookGuide().animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.98, 0.98)),
                  const SizedBox(height: 32),
                  _buildCategorySection().animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 32),
                  _buildWeightInput().animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
                  const SizedBox(height: 24),
                  if (_scrapItems.isNotEmpty) ...[
                    _buildItemsList().animate().fadeIn().scale(),
                    const SizedBox(height: 32),
                  ],
                  _buildContactForm().animate().fadeIn(delay: 800.ms),
                  const SizedBox(height: 32),
                  if (_scrapItems.isNotEmpty) _buildSubmitButton().animate().scale(curve: Curves.easeOutBack),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: GlassCard(
            padding: EdgeInsets.zero,
            width: 45,
            height: 45,
            child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
          ),
        ),
        const SizedBox(width: 20),
        Text(
          'Sell Scrap',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    final String background = _selectedCategory != null 
        ? _categoryBackgrounds[_selectedCategory] ?? 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&q=80&w=800'
        : 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&q=80&w=800';

    return GlassCard(
      height: 200,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.network(background, fit: BoxFit.cover),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.1), Colors.black.withValues(alpha: 0.8)],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                          ),
                          child: Text(_selectedCategory != null ? '♻️' : '🌍', style: const TextStyle(fontSize: 28)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedCategory != null ? 'Selling $_selectedCategory' : 'Sell Your Scrap',
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'AI-Verified Recycling Partner',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowToBookGuide() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 10),
              Text(
                'Instant Pickup Guide',
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildGuideStep(1, 'Log Material', 'Choose scrap and enter weight.'),
          _buildGuideStep(2, 'Set Location', 'Drop your address and phone.'),
          _buildGuideStep(3, 'Relax & Earn', 'Our exec picks it up, you get paid!'),
        ],
      ),
    );
  }

  Widget _buildGuideStep(int step, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.3), blurRadius: 10)],
            ),
            child: Center(child: Text('$step', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                Text(desc, style: GoogleFonts.outfit(fontSize: 12, color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'What do you have?',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
            ),
            Text(
              'SWIPE',
              style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.primaryColor, letterSpacing: 1),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 165,
          child: ListView.builder(
            controller: _categoryScrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _categoryIcons.length,
            itemBuilder: (context, index) {
              final category = _categoryIcons.keys.elementAt(index);
              final icon = _categoryIcons[category];
              final isSelected = category == _selectedCategory;

              return AnimatedContainer(
                duration: 400.ms,
                curve: Curves.easeOutQuint,
                width: 135,
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [AppTheme.primaryColor, AppTheme.primaryColor.withValues(alpha: 0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                    width: 1.5,
                  ),
                ),
                child: InkWell(
                  onTap: () => setState(() => _selectedCategory = category),
                  borderRadius: BorderRadius.circular(28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white.withValues(alpha: 0.2) : AppTheme.primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: isSelected ? Colors.white : AppTheme.primaryColor, size: 28),
                      ),
                      const SizedBox(height: 12),
                      Text(category, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white)),
                      Text(
                        _categoryDescriptions[category] ?? '',
                        style: GoogleFonts.outfit(fontSize: 10, color: Colors.white.withValues(alpha: 0.4), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeightInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Approximate Weight',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GlassCard(
                padding: EdgeInsets.zero,
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w800, color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter weight (kg)',
                    hintStyle: GoogleFonts.outfit(color: Colors.white.withValues(alpha: 0.3), fontWeight: FontWeight.w600),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            GestureDetector(
              onTap: _addScrapItem,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.primaryColor, Color(0xFF148B3D)]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 5))],
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemsList() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Scrap List', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
              Text('${_scrapItems.length} ITEMS', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.primaryColor, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 20),
          ..._scrapItems.map((item) {
            final idx = _scrapItems.indexOf(item);
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Icon(_categoryIcons[item['category']] ?? Icons.recycling, color: AppTheme.primaryColor, size: 20),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(item['category'], style: GoogleFonts.outfit(fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                  Text('${item['weight']} kg', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: Colors.white.withValues(alpha: 0.3), size: 18),
                    onPressed: () => setState(() => _scrapItems.removeAt(idx)),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 10),
          const Divider(color: Colors.white10),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Weight', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.5))),
              Text('${_totalWeight.toStringAsFixed(1)} kg', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.primaryColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact & Location',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        const SizedBox(height: 20),
        _buildGlassField(_nameController, 'Your Full Name', Icons.person_rounded),
        const SizedBox(height: 15),
        _buildGlassField(_phoneController, 'Active Phone Number', Icons.phone_rounded),
        const SizedBox(height: 15),
        _buildGlassField(_addressController, 'Detailed Pickup Address', Icons.location_on_rounded, maxLines: 2),
      ],
    );
  }

  Widget _buildGlassField(TextEditingController controller, String hint, IconData icon, {int maxLines = 1}) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.outfit(color: Colors.white.withValues(alpha: 0.3), fontWeight: FontWeight.w600),
          prefixIcon: Icon(icon, color: AppTheme.primaryColor, size: 20),
          contentPadding: const EdgeInsets.all(20),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.3), blurRadius: 25, offset: const Offset(0, 10))],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitScrapPickup,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: _isLoading
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('PROCEED BOOKING', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
                  const SizedBox(width: 12),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                ],
              ),
      ),
    );
  }
}
