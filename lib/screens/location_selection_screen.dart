import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../core/app_theme.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  GoogleMapController? _mapController;
  LatLng _selectedLocation = const LatLng(12.9716, 77.5946); // Bengaluru default
  String _address = "Fetching your location...";
  String _pincode = "";
  bool _isAvailable = false;
  bool _isLoading = false;
  final TextEditingController _pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showError("Please enable location services.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError("Location access denied.");
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition();
      final latLng = LatLng(position.latitude, position.longitude);
      
      setState(() {
        _selectedLocation = latLng;
      });

      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
      _getAddressFromLatLng(latLng);
    } catch (e) {
      debugPrint("GPS Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _address = "${place.name ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}";
          _pincode = place.postalCode ?? "";
          _pincodeController.text = _pincode;
          _checkAvailability(_pincode);
        });
      }
    } catch (e) {
      debugPrint("Geocoding Error: $e");
    }
  }

  void _checkAvailability(String pin) {
    // Premium Logic: Available in select Bengaluru pincodes starting with 560
    setState(() {
      _isAvailable = pin.startsWith('560');
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Futuristic Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              // Add custom dark style if possible, or just standard
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onCameraMove: (pos) => _selectedLocation = pos.target,
            onCameraIdle: () => _getAddressFromLatLng(_selectedLocation),
          ),

          // Custom Center Pin Layer
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: ZoomIn(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.cleaning_services_rounded,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    const Icon(
                      Icons.location_on_rounded,
                      color: AppTheme.primaryColor,
                      size: 60,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Top Search bar & Navigation
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  FadeInDown(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textColor),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: TextField(
                              controller: _pincodeController,
                              keyboardType: TextInputType.number,
                              onChanged: _checkAvailability,
                              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: "Enter your pincode",
                                hintStyle: GoogleFonts.outfit(color: Colors.grey, fontWeight: FontWeight.normal),
                                prefixIcon: const Icon(Icons.pin_drop_rounded, color: AppTheme.primaryColor),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Availability Card
          Align(
            alignment: Alignment.bottomCenter,
            child: FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 50,
                      offset: Offset(0, -10),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_isLoading)
                      const CircularProgressIndicator(strokeWidth: 2)
                    else
                      Column(
                        children: [
                          Icon(
                            _isAvailable ? Icons.stars_rounded : Icons.explore_rounded,
                            color: _isAvailable ? AppTheme.primaryColor : Colors.orange,
                            size: 40,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _isAvailable ? "Excellent! We're Available" : "Expanding Soon...",
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _address,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: AppTheme.subtleColor,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isAvailable ? AppTheme.primaryColor : const Color(0xFF1E293B),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 10,
                          shadowColor: (_isAvailable ? AppTheme.primaryColor : Colors.black).withValues(alpha: 0.3),
                        ),
                        onPressed: () {
                          if (_isAvailable) {
                            Navigator.pop(context);
                          } else {
                            _showError("We'll text you when we launch here!");
                          }
                        },
                        child: Text(
                          _isAvailable ? "Confirm Location" : "Notify Me",
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _getCurrentLocation,
                      child: Text(
                        "Re-sync GPS",
                        style: GoogleFonts.outfit(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
