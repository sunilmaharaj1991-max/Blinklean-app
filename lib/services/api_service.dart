import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  static const String baseUrl = 'https://blinklean-api.onrender.com/api';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _idToken;

  Future<String?> getIdToken() async {
    final user = _auth.currentUser;
    if (user != null) {
      _idToken = await user.getIdToken();
    }
    return _idToken;
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
      final response = await http
          .get(
            Uri.parse('$baseUrl$endpoint'),
            headers: _headers(requiresAuth: requiresAuth),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please check your connection.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    await refreshToken();
    try {
      final response = await http
          .post(
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
      throw ApiException('Network error: ${e.toString()}');
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
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> syncUser({
    String? name,
    String? email,
    String? phone,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw ApiException('User not authenticated');

    return post(
      '/auth/sync',
      body: {
        'uid': user.uid,
        'name': name ?? user.displayName,
        'email': email ?? user.email,
        'phone': phone,
      },
      requiresAuth: false,
    );
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    return get('/auth/me');
  }

  Future<Map<String, dynamic>> updateUser(Map<String, dynamic> updates) async {
    return put('/auth/me', body: updates);
  }

  Future<Map<String, dynamic>> updateAddress(
    Map<String, dynamic> address,
  ) async {
    return put('/auth/address', body: {'address': address});
  }

  Future<List<dynamic>> getServices({String? category}) async {
    final endpoint = category != null
        ? '/services?category=$category'
        : '/services';
    final response = await get(endpoint, requiresAuth: false);
    return response['services'] as List<dynamic>;
  }

  Future<List<dynamic>> getServicesByCategory(String category) async {
    final response = await get(
      '/services/category/$category',
      requiresAuth: false,
    );
    return response['services'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> getServiceById(String id) async {
    final response = await get('/services/$id', requiresAuth: false);
    return response['service'] as Map<String, dynamic>;
  }

  Future<List<dynamic>> getCategories() async {
    final response = await get('/services/categories', requiresAuth: false);
    return response['categories'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> createBooking(
    Map<String, dynamic> bookingData,
  ) async {
    return post('/bookings', body: bookingData);
  }

  Future<Map<String, dynamic>> getUserBookings({
    String? status,
    int page = 1,
  }) async {
    String endpoint = '/bookings?page=$page';
    if (status != null) endpoint += '&status=$status';
    return get(endpoint);
  }

  Future<Map<String, dynamic>> getBookingById(String bookingId) async {
    return get('/bookings/$bookingId', requiresAuth: false);
  }

  Future<Map<String, dynamic>> cancelBooking(
    String bookingId, {
    String? reason,
  }) async {
    return put(
      '/bookings/$bookingId/cancel',
      body: {'reason': reason ?? 'Cancelled by user'},
    );
  }

  Future<Map<String, dynamic>> rateBooking(
    String bookingId, {
    required int stars,
    String? review,
  }) async {
    return put(
      '/bookings/$bookingId/rate',
      body: {'stars': stars, 'review': review},
    );
  }

  Future<Map<String, dynamic>> createScrapPickup(
    Map<String, dynamic> pickupData,
  ) async {
    return post('/scrap', body: pickupData);
  }

  Future<List<dynamic>> getUserScrapPickups({String? status}) async {
    String endpoint = '/scrap/my';
    if (status != null) endpoint += '?status=$status';
    final response = await get(endpoint);
    return response['pickups'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> getProviderProfile() async {
    return get('/providers/me');
  }

  Future<Map<String, dynamic>> getProviderBookings({
    String? status,
    String? type,
  }) async {
    String endpoint = '/providers/bookings?';
    if (status != null) endpoint += 'status=$status&';
    if (type != null) endpoint += 'type=$type';
    return get(endpoint);
  }

  Future<Map<String, dynamic>> updateProviderStatus(String status) async {
    return put('/providers/status', body: {'status': status});
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
