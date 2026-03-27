import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../core/app_theme.dart';
import '../utils/validators.dart';

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
    'Paper': 'Newspapers, books, notebooks',
    'Plastic': 'Bottles, containers, bags',
    'Metal': 'Iron, aluminum, copper',
    'Glass': 'Bottles, jars, broken glass',
    'E-Waste': 'Old electronics, batteries',
    'Cardboard': 'Boxes, packaging material',
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
  bool _isLoading = false;

  @override
  void dispose() {
    _weightController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(weightError)));
      return;
    }

    double weight = double.parse(_weightController.text);
    setState(() {
      _scrapItems.add({'category': _selectedCategory, 'weight': weight});
      _selectedCategory = null;
      _weightController.clear();
    });
  }

  double get _totalWeight {
    return _scrapItems.fold(0, (sum, item) => sum + (item['weight'] as double));
  }

  void _submitScrapPickup() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your address')),
      );
      return;
    }
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }
    if (_scrapItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one scrap item')),
      );
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
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Assuming we have ApiService imported or accessible via locator
      // Wait, ApiService isn't imported yet, I'll add the import at the top
      await apiService.createScrapPickup(pickupData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Scrap pickup requested successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to book pickup: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
        ),
        title: Text(
          'Sell Scrap',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildHowToBookGuide(),
            const SizedBox(height: 32),
            _buildCategorySection(),
            const SizedBox(height: 32),
            _buildWeightInput(),
            const SizedBox(height: 24),
            if (_scrapItems.isNotEmpty) ...[
              _buildItemsList(),
              const SizedBox(height: 32),
            ],
            _buildContactForm(),
            const SizedBox(height: 24),
            if (_scrapItems.isNotEmpty) _buildSubmitButton(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final String background = _selectedCategory != null 
        ? _categoryBackgrounds[_selectedCategory] ?? 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?auto=format&fit=crop&q=80&w=800'
        : 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?auto=format&fit=crop&q=80&w=800';

    return Stack(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            image: DecorationImage(
              image: NetworkImage(background),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.1),
                Colors.black.withValues(alpha: 0.6),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          height: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Text('♻️', style: TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedCategory != null ? 'Sell $_selectedCategory' : 'Sell Your Scrap',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Expert AI-Powered Recycling',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: Colors.white, size: 16),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Market prices are adjusted dynamically upon pickup',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHowToBookGuide() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How to Book Scrap Pickup?',
            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildGuideStep(1, 'Select & Add', 'Select scrap material and estimate weight, then hit (+).'),
          _buildGuideStep(2, 'Your Details', 'Provide your address and contact info for our expert.'),
          _buildGuideStep(3, 'Confirm Book', 'Tap "Book Pickup" and relax, we take it from here!'),
        ],
      ),
    );
  }

  Widget _buildGuideStep(int step, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppTheme.primaryColor,
            child: Text('$step', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(desc, style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.subtleColor)),
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
        Text(
          'What do you have?',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Select the type of scrap you want to sell',
          style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.subtleColor),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: _categoryIcons.length,
          itemBuilder: (context, index) {
            final category = _categoryIcons.keys.elementAt(index);
            final icon = _categoryIcons[category];
            final isSelected = category == _selectedCategory;

            return InkWell(
              onTap: () => setState(() => _selectedCategory = category),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : Colors.grey.shade100,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? AppTheme.primaryColor.withValues(alpha: 0.2)
                          : Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.2)
                            : AppTheme.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: isSelected
                            ? Colors.white
                            : AppTheme.primaryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _categoryDescriptions[category] ?? '',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 8,
                        color: isSelected
                            ? Colors.white70
                            : AppTheme.subtleColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
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
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Enter the estimated weight of your scrap',
          style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.subtleColor),
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
                    suffixStyle: GoogleFonts.outfit(
                      color: AppTheme.subtleColor,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 56,
              width: 56,
              child: ElevatedButton(
                onPressed: _addScrapItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Icon(Icons.add_rounded, size: 28),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemsList() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Scrap List',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_scrapItems.length} items',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(_scrapItems.length, (index) {
            final item = _scrapItems[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.scaffoldBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _categoryIcons[item['category']] ?? Icons.recycling,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['category'],
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${(item['weight'] as double).toStringAsFixed(1)} kg',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppTheme.subtleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red.shade300,
                      size: 24,
                    ),
                    onPressed: () =>
                        setState(() => _scrapItems.removeAt(index)),
                  ),
                ],
              ),
            );
          }),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Weight',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '${_totalWeight.toStringAsFixed(1)} kg',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primaryColor,
                ),
              ),
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
          'Your Details',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'We need this to contact you for pickup',
          style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.subtleColor),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          _nameController,
          'Full Name',
          Icons.person_outline_rounded,
          TextInputType.name,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          _phoneController,
          'Phone Number',
          Icons.phone_android_rounded,
          TextInputType.phone,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          _addressController,
          'Pickup Address (with Pincode)',
          Icons.location_on_outlined,
          TextInputType.streetAddress,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    TextInputType type, {
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: TextField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.outfit(
            fontSize: 13,
            color: AppTheme.subtleColor,
          ),
          prefixIcon: Icon(icon, color: AppTheme.primaryColor, size: 22),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitScrapPickup,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(
                'Book Pickup Now',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
