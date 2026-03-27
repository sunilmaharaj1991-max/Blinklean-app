import 'package:flutter/material.dart';

class ServiceModel {
  final String id;
  final String name;
  final IconData icon;
  final String imageUrl;
  final String shortDescription;
  final String fullDescription;
  final String category;
  final double startingPrice;
  final String priceUnit;
  final String estimatedDuration;
  final List<String> whatsIncluded;
  final String customerProvides; // New field
  final bool isActive;

  ServiceModel({
    this.id = '',
    required this.name,
    required this.icon,
    this.imageUrl = '',
    required this.shortDescription,
    required this.fullDescription,
    required this.category,
    required this.startingPrice,
    this.priceUnit = '',
    required this.estimatedDuration,
    this.whatsIncluded = const [],
    this.customerProvides = '',
    this.isActive = true,
  });

  String get formattedPrice {
    if (priceUnit.isNotEmpty) {
      return '₹${startingPrice.toInt()} $priceUnit';
    }
    return '₹${startingPrice.toInt()}';
  }

  Widget buildIcon({double size = 26, Color? color}) {
    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(icon, color: color, size: size),
      );
    }
    return Icon(icon, color: color, size: size);
  }

  static List<ServiceModel> getAllServices() {
    return [
      // === HOME CLEANING ===
      ServiceModel(
        id: 'home_1bhk',
        imageUrl: 'https://images.unsplash.com/photo-1527352723443-44758e11bca6?auto=format&fit=crop&q=80&w=1200',
        name: '1BHK Normal Cleaning',
        icon: Icons.home_rounded,
        shortDescription: 'Essential home cleaning - dusting, mopping & sanitization.',
        fullDescription: 'Keep your 1BHK fresh and hygienic. Our team focuses on efficient normal cleaning, covering all rooms, floor mopping, and basic kitchen/bathroom sanitization for a comfortable living space.',
        category: 'Home Cleaning',
        startingPrice: 599,
        estimatedDuration: '2-3 hours',
        customerProvides: 'Water & Electricity Connection',
        whatsIncluded: [
          'All rooms dusting & mopping',
          'Basic kitchen slab cleaning',
          'Bathroom floor & WC cleaning',
          'Furniture surface wiping',
          'Trash removal',
        ],
      ),
      ServiceModel(
        id: 'home_2bhk',
        imageUrl: 'https://images.unsplash.com/photo-1581578761528-2f7526bfd89a?auto=format&fit=crop&q=80&w=1200',
        name: '2BHK Normal Cleaning',
        icon: Icons.home_rounded,
        shortDescription: 'Complete essential cleaning for your 2BHK home.',
        fullDescription: 'Professional normal cleaning tailored for 2BHK apartments. We handle the routine chores—dusting, mopping, and sanitizing common areas—so you can enjoy a neat and tidy home without the effort.',
        category: 'Home Cleaning',
        startingPrice: 899,
        estimatedDuration: '3-4 hours',
        customerProvides: 'Water & Electricity Connection',
        whatsIncluded: [
          'Comprehensive dusting & mopping',
          'Kitchen & dining area cleaning',
          'Sanitization of 2 bathrooms',
          'Bedroom mirror & fan dusting',
          'Balcony floor mopping',
        ],
      ),
      ServiceModel(
        id: 'home_3bhk',
        imageUrl: 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&q=80&w=1200',
        name: '3BHK Normal Cleaning',
        icon: Icons.villa_rounded,
        shortDescription: 'Essential cleaning for spacious 3BHK homes.',
        fullDescription: 'Maintain the elegance of your 3BHK with our reliable normal cleaning service. We ensure every room is dusted, floors are polished by hand, and bathrooms are left sparkling and fresh.',
        category: 'Home Cleaning',
        startingPrice: 1199,
        estimatedDuration: '4-5 hours',
        customerProvides: 'Water & Electricity Connection',
        whatsIncluded: [
          'Full house dusting & mopping',
          'Living & dining room focus',
          'Sanitization of 3 bathrooms',
          'Kitchen surface degreasing',
          'Window sill wiping',
        ],
      ),
      ServiceModel(
        id: 'home_kitchen',
        imageUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&q=80&w=1200',
        name: 'Kitchen Cleaning',
        icon: Icons.kitchen_rounded,
        shortDescription: 'Basic kitchen hygiene - slab, stove & tiles.',
        fullDescription: 'Avoid grease buildup with regular kitchen cleaning. We sanitize countertops, clean stove burners, and wipe cabinet exteriors to keep your cooking zone healthy and organized.',
        category: 'Home Cleaning',
        startingPrice: 499,
        estimatedDuration: '1-2 hours',
        customerProvides: 'Water & Electricity Connection',
        whatsIncluded: [
          'Countertop & hob cleaning',
          'Wall tiles wiping (above slab)',
          'Sink sanitization',
          'Cabinet exterior wiping',
          'Floor mopping',
        ],
      ),
      ServiceModel(
        id: 'home_bathroom',
        imageUrl: 'https://images.unsplash.com/photo-1584622781564-1d9876a13d00?auto=format&fit=crop&q=80&w=1200',
        name: 'Bathroom Cleaning',
        icon: Icons.bathtub_rounded,
        shortDescription: 'Hygienic bathroom refresh and sanitization.',
        fullDescription: 'Stop the bacteria! Our normal bathroom service removes stains from the WC, cleans the tiles, and shines the mirrors, leaving your bathroom fresh and odor-free.',
        category: 'Home Cleaning',
        startingPrice: 299,
        priceUnit: '/bath',
        estimatedDuration: '45 mins',
        customerProvides: 'Water & Electricity Connection',
        whatsIncluded: [
          'WC sanitization',
          'Mirror & Tap cleaning',
          'Floor scrubbing',
          'Wall tile wiping (up to 5ft)',
          'Odor control spray',
        ],
      ),

      // === VEHICLE CLEANING (WATERLESS) ===
      ServiceModel(
        id: 'vehicle_car_full',
        imageUrl: 'https://images.unsplash.com/photo-1601362840469-51e4d8d59085?auto=format&fit=crop&q=80&w=1200',
        name: 'Car Waterless Detailing',
        icon: Icons.directions_car_rounded,
        shortDescription: 'Eco-friendly waterless wash with premium shine.',
        fullDescription: 'Experience the future of car wash. Our partner uses specialized waterless cleaning agents and microfiber technology to lift dirt safely. No mess, no water waste, just a brilliant showroom finish.',
        category: 'Vehicle Care',
        startingPrice: 399,
        estimatedDuration: '1 hour',
        customerProvides: 'Partner brings all Waterless Cleaning Kits',
        whatsIncluded: [
          'Waterless body panels wiping',
          'Alloy/Rim cleaning',
          'Glass polishing',
          'Interior vacuuming',
          'Tire dressing',
        ],
      ),
      ServiceModel(
        id: 'vehicle_bike_clean',
        imageUrl: 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?auto=format&fit=crop&q=80&w=1200',
        name: 'Bike Waterless Shine',
        icon: Icons.two_wheeler_rounded,
        shortDescription: 'Eco-safe bike cleaning - chain & body care.',
        fullDescription: 'Waterless cleaning specifically for your two-wheeler. We remove road grime from sensitive parts like the engine and chain without the risk of water damage. Includes body polishing.',
        category: 'Vehicle Care',
        startingPrice: 199,
        estimatedDuration: '30 mins',
        customerProvides: 'Partner brings all Waterless Cleaning Kits',
        whatsIncluded: [
          'Waterless body cleaning',
          'Engine outer cleaning',
          'Chain lubrication check',
          'Mirror polishing',
          'Wheel detailing',
        ],
      ),
      ServiceModel(
        id: 'vehicle_auto',
        imageUrl: 'https://images.unsplash.com/photo-1567113463300-102550d235c5?auto=format&fit=crop&q=80&w=1200',
        name: 'Auto Rickshaw Cleaning',
        icon: Icons.electric_rickshaw_rounded,
        shortDescription: 'Quick waterless refresh for auto rickshaws.',
        fullDescription: 'Improve your passenger experience with a clean auto. Our partner provides a quick, waterless interior and exterior wipe-down that leaves your vehicle presentable and clean.',
        category: 'Vehicle Care',
        startingPrice: 149,
        estimatedDuration: '30 mins',
        customerProvides: 'Partner brings all Waterless Cleaning Kits',
        whatsIncluded: [
          'Exterior body wipe',
          'Floor mat dusting',
          'Seat surface cleaning',
          'Handle & meter wiping',
          'Canopy dusting',
        ],
      ),
      ServiceModel(
        id: 'vehicle_cycle',
        imageUrl: 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?auto=format&fit=crop&q=80&w=1200',
        name: 'Bicycle Waterless Clean',
        icon: Icons.pedal_bike_rounded,
        shortDescription: 'Precision waterless wash for your cycle.',
        fullDescription: 'Keep your gear clean and efficient. We use soft-brush waterless cleaning to remove dust and grease from the frame and wheels without affecting delicate components.',
        category: 'Vehicle Care',
        startingPrice: 99,
        estimatedDuration: '20 mins',
        customerProvides: 'Partner brings all Waterless Cleaning Kits',
        whatsIncluded: [
          'Frame & fork cleaning',
          'Wheel/Rims detailing',
          'Handlebar sanitization',
          'Saddle cleaning',
          'Chain dust removal',
        ],
      ),

      // === LAUNDRY ===
      ServiceModel(
        id: 'laundry_wash_fold',
        imageUrl: 'https://images.unsplash.com/photo-1545173168-9f1947eebb7f?auto=format&fit=crop&q=80&w=1200',
        name: 'Wash & Fold',
        icon: Icons.local_laundry_service_rounded,
        shortDescription: 'Premium laundry - washed, dried & folded.',
        fullDescription: 'Your laundry, perfected. We use gentle eco-detergents and careful cycles to cleanse and refresh your clothes, followed by professional folding for a ready-to-wear finish.',
        category: 'Laundry',
        startingPrice: 79,
        priceUnit: '/kg',
        estimatedDuration: '24 hours',
        customerProvides: 'Clothes in a bag/bin',
        whatsIncluded: [
          'Eco-detergent wash',
          'Fabric softener drying',
          'Crisp folding',
          'Quality check',
          'Hygienic packaging',
        ],
      ),
    ];
  }

  static List<ServiceModel> getHomeCleaningServices() {
    return getAllServices().where((s) => s.category == 'Home Cleaning').toList();
  }

  static List<ServiceModel> getVehicleServices() {
    return getAllServices().where((s) => s.category == 'Vehicle Care').toList();
  }

  static List<ServiceModel> getLaundryServices() {
    return getAllServices().where((s) => s.category == 'Laundry').toList();
  }

  static List<String> getCategories() {
    return ['Home Cleaning', 'Vehicle Care', 'Laundry', 'Scrap & Recycling'];
  }
}
