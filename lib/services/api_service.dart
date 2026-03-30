import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class ApiService {
  // === AWS CONFIGURATION ===
  // Primary AWS API Gateway (Mumbai)
  static const String _awsApiUrl = 'https://3090drir79.execute-api.ap-south-1.amazonaws.com/prod';
  
  static String get baseUrl => _awsApiUrl;

  String? _idToken;

  Future<String?> getIdToken() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
      final tokens = session.userPoolTokensResult.value;
      _idToken = tokens.idToken.raw;
      return _idToken;
    } catch (e) {
      debugPrint('Error fetching idToken: $e');
      return null;
    }
  }

  Map<String, String> _headers({bool requiresAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (requiresAuth && _idToken != null) {
      headers['Authorization'] = 'Bearer $_idToken';
    }
    return headers;
  }

  Future<void> refreshToken() async {
    await getIdToken();
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body as Map<String, dynamic>;
    }

    final error = body['error'] ?? 'An error occurred';
    throw ApiException(error, statusCode: response.statusCode);
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    await refreshToken();
    try {
      final url = endpoint.startsWith('http') ? endpoint : '$baseUrl$endpoint';
      final response = await http
          .get(
            Uri.parse(url),
            headers: _headers(requiresAuth: requiresAuth),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('AWS Connection Error: Please check your internet or AWS credentials.');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    await refreshToken();
    try {
      final url = endpoint.startsWith('http') ? endpoint : '$baseUrl$endpoint';
      final response = await http
          .post(
            Uri.parse(url),
            headers: _headers(requiresAuth: requiresAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please check your connection.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('AWS Connection Error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    await refreshToken();
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: _headers(requiresAuth: requiresAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please check your connection.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('AWS Connection Error: ${e.toString()}');
    }
  }

  // === AWS DATA PERSISTENCE (S3 & DYNAMODB) ===

  /// Fetch Master Data (Services/Categories) from S3 satisfy "Saved in AWS"
  Future<List<dynamic>> fetchMasterData(String type) async {
    try {
      final result = await Amplify.Storage.downloadData(
        path: StoragePath.fromString('master/$type.json'),
      ).result;
      
      final String jsonString = utf8.decode(result.bytes);
      return jsonDecode(jsonString) as List<dynamic>;
    } catch (e) {
      debugPrint('S3 Master Data Error ($type): $e');
      return []; // Fallback to empty if S3 file is missing
    }
  }

  Future<void> _storeInAWS(String path, Map<String, dynamic> data) async {
    try {
      final fileName = 'booking_${DateTime.now().millisecondsSinceEpoch}.json';
      final jsonString = jsonEncode(data);
      
      await Amplify.Storage.uploadData(
        data: StorageDataPayload.string(jsonString),
        path: StoragePath.fromString('$path/$fileName'),
      ).result;
      
      debugPrint('Successfully stored $path in AWS S3: $fileName');
    } catch (e) {
      debugPrint('AWS Storage Error: $e');
      throw ApiException('AWS Storage Error: Failed to sync data to the cloud.');
    }
  }

  // === USER & PROFILE MANAGEMENT ===

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      final attrs = await Amplify.Auth.fetchUserAttributes();
      
      final map = {
        'userId': user.userId,
        'username': user.username,
      };
      for (var e in attrs) {
        map[e.userAttributeKey.toString()] = e.value;
      }
      return map;
    } catch (e) {
      // Fallback to API if Cognito fails
      return get('/users/me');
    }
  }

  Future<Map<String, dynamic>> updateUser(Map<String, dynamic> updates) async {
    try {
      // Try to update in Cognito first
      List<AuthUserAttribute> attrs = [];
      if (updates.containsKey('name')) {
        attrs.add(AuthUserAttribute(
          userAttributeKey: AuthUserAttributeKey.name,
          value: updates['name'],
        ));
      }
      if (updates.containsKey('email')) {
        attrs.add(AuthUserAttribute(
          userAttributeKey: AuthUserAttributeKey.email,
          value: updates['email'],
        ));
      }
      
      if (attrs.isNotEmpty) {
        await Amplify.Auth.updateUserAttributes(attributes: attrs);
      }
      
      // Also notify AWS API Gateway to sync DynamoDB
      return put('/users/me', body: updates);
    } catch (e) {
      // If Cognito fails, just use API
      return put('/users/me', body: updates);
    }
  }

  Future<Map<String, dynamic>> updateAddress(Map<String, dynamic> address) async {
    return put('/users/address', body: address);
  }

  // === BOOKING MANAGEMENT (AWS DYNAMODB / API GATEWAY) ===

  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> bookingData) async {
    // 1. Audit trail in S3
    await _storeInAWS('bookings', bookingData);
    
    // 2. Real-time DB write via API Gateway
    return post('/booking/create', body: bookingData);
  }

  Future<Map<String, dynamic>> getUserBookings({String? status, int page = 1}) async {
    return get('/bookings/me?status=$status');
  }

  Future<Map<String, dynamic>> getBookingById(String bookingId) async {
    return get('/bookings/$bookingId');
  }

  Future<Map<String, dynamic>> cancelBooking(String bookingId, {String? reason}) async {
    return post('/bookings/$bookingId/cancel', body: {'reason': reason});
  }

  Future<Map<String, dynamic>> rateBooking(String bookingId, {required int stars, String? review}) async {
    return post('/bookings/$bookingId/rate', body: {'stars': stars, 'review': review});
  }

  // === SCRAP & PICKUP (AWS API GATEWAY) ===

  Future<Map<String, dynamic>> createScrapPickup(Map<String, dynamic> pickupData) async {
    try {
      return await post('/scrap-pickup', body: pickupData);
    } catch (e) {
      await _storeInAWS('scrap', pickupData);
      return {'success': true, 'id': 'AWS_S3_${DateTime.now().millisecondsSinceEpoch}', 'status': 'PENDING_SYNC'};
    }
  }

  Future<List<dynamic>> getUserScrapPickups({String? status}) async {
    final response = await get('/scrap/me?status=$status');
    return response['pickups'] ?? [];
  }

  // === PROVIDER MANAGEMENT (AWS DYNAMODB) ===

  Future<Map<String, dynamic>> createProvider(Map<String, dynamic> data) async {
    return post('/provider/create', body: data);
  }

  Future<List<dynamic>> fetchProviders(String serviceType) async {
    final response = await get('/providers?service_type=$serviceType');
    return response['providers'] ?? [];
  }

  Future<Map<String, dynamic>> getProviderProfile() async {
    return get('/provider/me');
  }

  Future<Map<String, dynamic>> getProviderBookings({String? status, String? type}) async {
    return get('/provider/bookings?status=$status&type=$type');
  }

  Future<Map<String, dynamic>> updateProviderStatus(String status) async {
    return put('/provider/status', body: {'status': status});
  }

  // === ADMIN MANAGEMENT (AWS DYNAMODB AGGREGATIONS) ===

  Future<Map<String, dynamic>> fetchAdminStats() async {
    return get('/admin/stats');
  }

  Future<List<dynamic>> fetchAdminUsers() async {
    final response = await get('/admin/users');
    return response['users'] ?? [];
  }

  Future<List<dynamic>> fetchAdminProviders() async {
    final response = await get('/admin/providers');
    return response['providers'] ?? [];
  }

  // === SERVICE LISTING (S3 MASTER DATA) ===
  
  Future<List<dynamic>> getServices({String? category}) async {
    final data = await fetchMasterData('services');
    if (category != null) {
      return data.where((s) => s['category'] == category).toList();
    }
    return data;
  }

  Future<List<dynamic>> getServicesByCategory(String category) async {
    return getServices(category: category);
  }

  Future<List<dynamic>> getCategories() async {
    try {
      return await fetchMasterData('categories');
    } catch (e) {
      return ['Home Cleaning', 'Vehicle Care', 'Laundry', 'Scrap & Recycling'];
    }
  }

  Future<bool> checkServiceAvailability(String pincode) async {
    return pincode.startsWith('560'); // Bangalore default
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

final apiService = ApiService();
