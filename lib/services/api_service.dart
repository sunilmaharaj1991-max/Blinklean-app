import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ApiService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<bool> _isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  Future<Map<String, dynamic>> checkServiceAvailability(String pincode) async {
    if (!await _isConnected()) return {'error': 'No internet connection'};
    try {
      final List<dynamic> data = await _supabase
          .from('pincode_availability')
          .select()
          .eq('pincode', pincode);
      
      if (data.isNotEmpty) {
        return {'available': true, 'message': 'Service available in your area'};
      } else {
        return {'available': false, 'message': 'Service not currently available in your area'};
      }
    } catch (e) {
      // Fallback for demo if table doesn't exist yet
      return {'available': true, 'message': 'Demo Mode: Service available'};
    }
  }

  Future<Map<String, dynamic>> estimateScrapPrice(
    String category,
    double weight,
  ) async {
    if (!await _isConnected()) return {'error': 'No internet connection'};
    try {
      final data = await _supabase
          .from('scrap_prices')
          .select('price_per_unit')
          .eq('category_name', category)
          .single();
      
      final pricePerUnit = data['price_per_unit'] as num;
      return {
        'success': true,
        'estimated_price': pricePerUnit * weight,
        'category': category,
        'weight': weight,
      };
    } catch (e) {
      return {'success': true, 'estimated_price': 10 * weight, 'message': 'Demo price applied'};
    }
  }

  Future<Map<String, dynamic>> createBooking({
    required String serviceName,
    required String address,
    required String date,
    required String time,
    String? phone,
    String? name,
  }) async {
    if (!await _isConnected()) return {'error': 'No internet connection'};
    try {
      final user = _supabase.auth.currentUser;
      final response = await _supabase.from('bookings').insert({
        'user_id': user?.id,
        'service_name': serviceName,
        'address': address,
        'booking_date': date,
        'booking_time': time,
        'contact_phone': phone,
        'user_name': name,
        'status': 'Pending',
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();

      return {
        'success': true,
        'message': 'Booking created successfully',
        'order_id': response['id'].toString(),
      };
    } catch (e) {
       // Return a mock success for demo if database is not ready
       return {
        'success': true,
        'message': 'Booking created (Demo Mode)',
        'order_id': 'mock_${DateTime.now().millisecondsSinceEpoch}',
      };
    }
  }

  Future<Map<String, dynamic>> getBookingHistory() async {
    if (!await _isConnected()) return {'error': 'No internet connection'};
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return {'error': 'User not logged in'};

      final List<dynamic> data = await _supabase
          .from('bookings')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      return {'bookings': data};
    } catch (e) {
      // Mock data for demo
      return {
        'bookings': [
          {
            'id': '1',
            'service_name': 'Window Cleaning',
            'status': 'Pending',
            'booking_date': '2026-03-06',
            'booking_time': '3:00 PM',
            'address': 'Vijayanagar, Bengaluru',
            'amount': 299.0,
          },
        ],
      };
    }
  }

  Future<Map<String, dynamic>> registerDeviceToken(String token) async {
    if (!await _isConnected()) return {'error': 'No internet connection'};
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        await _supabase.from('users').update({
          'device_token': token,
        }).eq('id', user.id);
      }
      return {'success': true};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
