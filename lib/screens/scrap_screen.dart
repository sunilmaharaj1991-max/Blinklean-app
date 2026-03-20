import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scrap_item_model.dart';
import '../services/scrap_price_service.dart';
import '../core/app_theme.dart';
import '../utils/validators.dart';
import '../utils/error_handler.dart';
import 'pickup_booking_screen.dart';

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

  final ScrapPriceService _priceService = ScrapPriceService();
  String? _selectedCategory;
  final TextEditingController _weightController = TextEditingController();
  final List<ScrapItemModel> _scrapItems = [];

  double? _totalEstimatedValue;
  bool _isEstimating = false;

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _addScrapItem() {
    final weightError = Validators.validateWeight(_weightController.text);
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a material category')),
      );
      return;
    }
    if (weightError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(weightError)),
      );
      return;
    }

    double weight = double.parse(_weightController.text);
    setState(() {
      _scrapItems.add(
        ScrapItemModel(
          itemName: '$_selectedCategory Scrap',
          category: _selectedCategory!,
          estimatedWeight: weight,
          estimatedPrice: 0.0,
          quantity: 1,
        ),
      );
      _selectedCategory = null;
      _weightController.clear();
      _totalEstimatedValue = null;
    });
  }

  Future<void> _estimateValue() async {
    if (_scrapItems.isEmpty) return;

    setState(() => _isEstimating = true);

    try {
      final calculatedEstimates = await _priceService.calculateEstimates(_scrapItems);
      final calculatedTotal = _priceService.calculateTotal(calculatedEstimates);

      if (mounted) {
        setState(() {
          _totalEstimatedValue = calculatedTotal;
          _isEstimating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isEstimating = false);
        ErrorHandler.showError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Text('Sell Scrap', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
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
            _buildRecycleHeader(),
            const SizedBox(height: 40),

            Text(
              'What are you recycling?',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            ),
            const SizedBox(height: 16),
            _buildCategoryGrid(),
            
            const SizedBox(height: 32),
            Text(
              'Approximate Weight',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: 'e.g. 5.5',
                        suffixText: 'kg',
                        suffixStyle: GoogleFonts.outfit(color: AppTheme.subtleColor),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  height: 56,
                  width: 56,
                  child: ElevatedButton(
                    onPressed: _addScrapItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 4,
                    ),
                    child: const Icon(Icons.add_rounded),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 48),

            if (_scrapItems.isNotEmpty) ...[
               _buildSectionDivider('MY RECYCLING CART'),
               const SizedBox(height: 20),
               _buildItemsList(),
               const SizedBox(height: 40),
               
               if (_totalEstimatedValue == null)
                 _buildEstimateButton()
               else
                 _buildTotalWithSchedule(),
            ] else 
               Center(
                 child: Column(
                   children: [
                     const SizedBox(height: 40),
                     Icon(Icons.recycling_rounded, size: 80, color: AppTheme.primaryColor.withValues(alpha: 0.1)),
                     const SizedBox(height: 16),
                     Text(
                       'Your cart is empty',
                       style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.subtleColor),
                     ),
                     const SizedBox(height: 8),
                     Text(
                       'Add items like paper or plastic to get an estimate.',
                       style: GoogleFonts.outfit(fontSize: 13, color: AppTheme.subtleColor.withValues(alpha: 0.7)),
                       textAlign: TextAlign.center,
                     ),
                   ],
                 ),
               ),

             const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionDivider(String label) {
    return Row(
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.subtleColor, letterSpacing: 1.5)),
        const SizedBox(width: 16),
        Expanded(child: Divider(color: Colors.grey.shade100, thickness: 1.5)),
      ],
    );
  }

  Widget _buildRecycleHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.bolt_rounded, color: AppTheme.primaryColor, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('India\'s 1st AI Powered', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                    Text('Eco-Smart Recycling', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.textColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Recycling 10kg of paper saves 17 trees and reduces 70% of energy consumption! Be the hero today.',
            style: GoogleFonts.outfit(fontSize: 13, color: AppTheme.subtleColor, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: _categoryIcons.length,
      itemBuilder: (context, index) {
        final category = _categoryIcons.keys.elementAt(index);
        final icon = _categoryIcons[category];
        final isSelected = category == _selectedCategory;
        
        return InkWell(
          onTap: () => setState(() => _selectedCategory = category),
          borderRadius: BorderRadius.circular(24),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: isSelected ? AppTheme.primaryColor : Colors.grey.shade100),
              boxShadow: isSelected 
                  ? [BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 5))] 
                  : [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withValues(alpha: 0.2) : AppTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: isSelected ? Colors.white : AppTheme.primaryColor, size: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  category,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppTheme.textColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _scrapItems.length,
      itemBuilder: (context, index) {
        final item = _scrapItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.05), shape: BoxShape.circle),
                child: Icon(_categoryIcons[item.category] ?? Icons.recycling, color: AppTheme.primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.category, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('${item.estimatedWeight} kg', style: GoogleFonts.outfit(color: AppTheme.subtleColor, fontSize: 13)),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove_circle_rounded, color: Colors.red.shade300, size: 28),
                onPressed: () => setState(() {
                  _scrapItems.removeAt(index);
                  _totalEstimatedValue = null;
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEstimateButton() {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton.icon(
        onPressed: _isEstimating ? null : _estimateValue,
        icon: const Icon(Icons.calculate_rounded),
        label: Text(_isEstimating ? 'ANALYZING...' : 'GET VALUE ESTIMATE'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.textColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 10,
        ),
      ),
    );
  }

  Widget _buildTotalWithSchedule() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.3), blurRadius: 30, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Text('ESTIMATED EARNINGS', style: GoogleFonts.outfit(color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 10)),
          const SizedBox(height: 12),
          Text(
            '₹${_totalEstimatedValue?.toStringAsFixed(0)}',
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: -1),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PickupBookingScreen(items: _scrapItems)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, 
                foregroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: Text('SCHEDULE FREE PICKUP', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
