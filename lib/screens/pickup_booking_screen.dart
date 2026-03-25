import 'package:flutter/material.dart';
import '../models/scrap_item_model.dart';
import '../services/api_service.dart';
import '../core/app_theme.dart';

class PickupBookingScreen extends StatefulWidget {
  final List<ScrapItemModel> items;

  const PickupBookingScreen({super.key, required this.items});

  @override
  State<PickupBookingScreen> createState() => _PickupBookingScreenState();
}

class _PickupBookingScreenState extends State<PickupBookingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _addressController = TextEditingController();
  final ApiService _apiService = apiService;
  bool _isLoading = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _confirmBooking() async {
    if (_addressController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all details before continuing'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final pickupData = {
        'items': widget.items.map((item) => {
          'category': item.category,
          'weight': item.estimatedWeight,
        }).toList(),
        'address': {
          'street': _addressController.text,
          'city': 'Bengaluru',
        },
        'schedule': {
          'date': '${_selectedDate!.toLocal()}'.split(' ')[0],
          'time': _selectedTime!.format(context),
        },
        'status': 'pending',
      };

      await _apiService.createScrapPickup(pickupData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your scrap pickup has been scheduled successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
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
      appBar: AppBar(title: const Text('Schedule Pickup'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pickup Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Pickup Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _selectedDate == null
                    ? 'Select Pickup Date'
                    : '${_selectedDate!.toLocal()}'.split(' ')[0],
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now().add(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              leading: const Icon(Icons.access_time),
              title: Text(
                _selectedTime == null
                    ? 'Select Time Slot'
                    : _selectedTime!.format(context),
              ),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 10, minute: 0),
                );
                if (time != null) {
                  setState(() {
                    _selectedTime = time;
                  });
                }
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _confirmBooking,
                icon: _isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                    : const Icon(Icons.check_circle_outline),
                label: Text(_isLoading ? 'Booking...' : 'Confirm Booking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
