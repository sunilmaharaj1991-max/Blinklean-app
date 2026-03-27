import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/foundation.dart';

class BlinkLeanApiService {
  // Replace with your actual API Gateway base URL from Amplify console
  static const String _baseUrl = 'https://YOUR_API_ID.execute-api.eu-north-1.amazonaws.com/prod';

  /// helper to get the Cognito Access Token
  Future<String?> _getAuthToken() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (session is CognitoAuthSession) {
        final tokens = session.userPoolTokensResult.value;
        // Use ID Token for Cognito Authorizers
        return tokens.idToken.raw;
      }
      return null;
    } catch (e) {
      debugPrint('Auth Token Error: $e');
      return null;
    }
  }

  /// 1. Create Provider Account (Admin Endpoint)
  Future<Map<String, dynamic>> createProvider({
    required String name,
    required String phone,
    required String address,
    required String serviceType,
    required String experience,
  }) async {
    final token = await _getAuthToken();
    if (token == null) return {'error': 'Unauthorized'};

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/provider/create'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'address': address,
          'service_type': serviceType,
          'experience': experience,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Failed to create provider: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': 'Exception: $e'};
    }
  }

  /// 2. Fetch Providers by Service (Public/Customer Endpoint)
  Future<List<dynamic>> fetchProviders(String serviceType) async {
    final token = await _getAuthToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/providers?service_type=$serviceType'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      debugPrint('Fetch Providers Error: $e');
      return [];
    }
  }

  /// 3. Create a New Booking (Customer Endpoint)
  Future<bool> createBooking({
    required String customerId,
    required String providerId,
    required String serviceType,
    required String date,
    required double price,
  }) async {
    final token = await _getAuthToken();
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/booking/create'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'customer_id': customerId,
          'provider_id': providerId,
          'service_type': serviceType,
          'date': date,
          'price': price,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      debugPrint('Booking Error: $e');
      return false;
    }
  }

  /// 4. Fetch Provider's Bookings (Partner Endpoint)
  Future<List<dynamic>> fetchProviderBookings(String providerId) async {
    final token = await _getAuthToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/provider/bookings?provider_id=$providerId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      debugPrint('Fetch Bookings Error: $e');
      return [];
    }
  }
}

// Global instance
final blinkLeanApi = BlinkLeanApiService();
