import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../core/app_theme.dart';
import '../widgets/glass_card.dart';

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
    setState(() {
      _isAvailable = pin.startsWith('560');
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Map with a subtle overlay
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _setMapStyle(controller);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            onCameraMove: (pos) => _selectedLocation = pos.target,
            onCameraIdle: () => _getAddressFromLatLng(_selectedLocation),
          ),

          // Subtle Map Overlay for better text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.2),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),

          // Custom Center Pin
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.cleaning_services_rounded,
                      color: AppTheme.primaryColor,
                      size: 24,
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).slideY(begin: 0, end: -0.2, duration: 2.seconds, curve: Curves.easeInOut),
                  const Icon(
                    Icons.location_on_rounded,
                    color: AppTheme.primaryColor,
                    size: 60,
                  ),
                ],
              ),
            ),
          ),

          // Search Bar & Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: GlassCard(
                      padding: EdgeInsets.zero,
                      width: 45,
                      height: 45,
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 55,
                      child: Center(
                        child: TextField(
                          controller: _pincodeController,
                          keyboardType: TextInputType.number,
                          onChanged: _checkAvailability,
                          style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Search Pincode...",
                            hintStyle: GoogleFonts.outfit(color: Colors.white38, fontWeight: FontWeight.w500),
                            prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryColor, size: 22),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          ),
                        ),
                      ).animate().fadeIn().slideX(begin: 0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Actions & Info Panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        if (_isLoading)
                          const SizedBox(height: 100, child: Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)))
                        else ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isAvailable ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                                color: _isAvailable ? AppTheme.primaryColor : Colors.orangeAccent,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _isAvailable ? "WE ARE AVAILABLE HERE" : "SERVICE AREA UNAVAILABLE",
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _address,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: _isAvailable ? () => Navigator.pop(context, _selectedLocation) : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isAvailable ? AppTheme.primaryColor : Colors.white10,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 0,
                              ),
                              child: Text(
                                _isAvailable ? "CONFIRM LOCATION" : "NOT AVAILABLE",
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: _isAvailable ? Colors.white : Colors.white24,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: _getCurrentLocation,
                            icon: const Icon(Icons.my_location_rounded, size: 18, color: AppTheme.primaryColor),
                            label: Text(
                              "RE-SYNC GPS",
                              style: GoogleFonts.outfit(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
        ],
      ),
    );
  }

  void _setMapStyle(GoogleMapController controller) {
    // Basic dark mode map style string could be added here
    // For now, keeping it standard but could inject JSON later
  }
}
