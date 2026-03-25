import 'api_service.dart';

class DatabaseService {
  ApiService get _api => apiService;

  Future<List<Map<String, dynamic>>> getServices({String? category}) async {
    try {
      final services = await apiService.getServices(category: category);
      return services.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getServicesByCategory(
    String category,
  ) async {
    try {
      final services = await apiService.getServicesByCategory(category);
      return services.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final categories = await apiService.getCategories();
      return categories.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> createBooking(
    Map<String, dynamic> bookingData,
  ) async {
    try {
      return await apiService.createBooking(bookingData);
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getUserBookings({String? status}) async {
    try {
      final response = await apiService.getUserBookings(status: status);
      return (response['bookings'] as List?)?.cast<Map<String, dynamic>>() ??
          [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> getBookingById(String bookingId) async {
    try {
      return await apiService.getBookingById(bookingId);
    } catch (e) {
      return null;
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    try {
      await apiService.cancelBooking(bookingId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> createScrapPickup(
    Map<String, dynamic> pickupData,
  ) async {
    try {
      return await apiService.createScrapPickup(pickupData);
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getUserScrapPickups({
    String? status,
  }) async {
    try {
      final result = await _api.getUserScrapPickups(status: status);
      return result.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> getProviderProfile() async {
    try {
      return await apiService.getProviderProfile();
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getProviderBookings({
    String? status,
    String? type,
  }) async {
    try {
      return await apiService.getProviderBookings(status: status, type: type);
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateProviderStatus(String status) async {
    try {
      await apiService.updateProviderStatus(status);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      return await apiService.getUserProfile();
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateUser(Map<String, dynamic> updates) async {
    try {
      await apiService.updateUser(updates);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateAddress(Map<String, dynamic> address) async {
    try {
      await apiService.updateAddress(address);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final databaseService = DatabaseService();
