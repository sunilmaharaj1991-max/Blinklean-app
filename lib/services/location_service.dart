import 'package:geolocator/geolocator.dart';
import 'api_service.dart';

class LocationService {

  // List of supported pincodes in the area.
  // In a real app, this should be fetched from Firestore.
  final List<String> _supportedPincodes = [
    '560040', // Vijayanagar
    '560072', // Chandra Layout
    '560023', // Rajajinagar
    '560098', // Rajarajeshwari Nagar
    '560010', // Basaveshwaranagar
  ];

  // Fetch supported pincodes from AWS S3
  Future<List<String>> _getSupportedPincodes() async {
    try {
      final List<dynamic> data = await apiService.fetchMasterData('pincodes');
      if (data.isEmpty) return _supportedPincodes; // Fallback
      return data.map((e) => e.toString()).toList();
    } catch (e) {
      return _supportedPincodes;
    }
  }

  Future<bool> isServiceAvailable(String pincode) async {
    final supported = await _getSupportedPincodes();
    return supported.contains(pincode.trim());
  }

  Future<Map<String, dynamic>> checkServiceAvailability(String pincode) async {
    final available = await isServiceAvailable(pincode);
    return {
      'available': available,
      'area': available ? _getAreaName(pincode) : null,
    };
  }

  String _getAreaName(String pincode) {
    switch (pincode) {
      case '560040': return 'Vijayanagar';
      case '560072': return 'Chandra Layout';
      case '560023': return 'Rajajinagar';
      case '560098': return 'Rajarajeshwari Nagar';
      case '560010': return 'Basaveshwaranagar';
      default: return 'Your Area';
    }
  }

  // Request location permission, get user current location coordinates and return them.
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
