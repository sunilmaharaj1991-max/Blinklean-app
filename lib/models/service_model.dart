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
        imageUrl: 'https://www.blinklean.com/assets/images/1bhk_cleaning.png',
        name: '1BHK Deep Cleaning',
        icon: Icons.home_rounded,
        shortDescription:
            'Complete home cleaning - floors, kitchen, bathroom & more.',
        fullDescription:
            'Your 1BHK deserves the best care. Our expert team delivers a thorough deep clean that covers every room, the kitchen, and bathrooms. We bring professional-grade equipment and eco-friendly products to transform your space into a pristine haven.',
        category: 'Home Cleaning',
        startingPrice: 1499,
        estimatedDuration: '4-5 hours',
        whatsIncluded: [
          'All rooms dusting & mopping',
          'Kitchen deep cleaning',
          'Bathroom sanitization',
          'Window cleaning (interior)',
          'Floors scrubbing & polishing',
        ],
      ),
      ServiceModel(
        id: 'home_2bhk',
        imageUrl: 'https://www.blinklean.com/assets/images/2bhk_cleaning.png',
        name: '2BHK Deep Cleaning',
        icon: Icons.home_rounded,
        shortDescription: 'Thorough cleaning for your entire 2BHK home.',
        fullDescription:
            'Don\'t let cleaning stress you out. Our trained professionals handle everything - from scrubbing floors to degreasing kitchen appliances, sanitizing bathrooms, and reaching those tricky spots you usually miss. Walk into a home that smells fresh and looks immaculate.',
        category: 'Home Cleaning',
        startingPrice: 2199,
        estimatedDuration: '6-7 hours',
        whatsIncluded: [
          'Complete home dusting & mopping',
          'Kitchen deep cleaning with chimney',
          'Bathroom full sanitization',
          'All rooms carpet vacuuming',
          'Almirah & furniture dusting',
        ],
      ),
      ServiceModel(
        id: 'home_3bhk',
        imageUrl: 'https://www.blinklean.com/assets/images/3bhk_cleaning.png',
        name: '3BHK Deep Cleaning',
        icon: Icons.villa_rounded,
        shortDescription: 'Premium cleaning for large homes & villas.',
        fullDescription:
            'Big home, big cleaning standards. We deploy a dedicated team to ensure every corner of your 3BHK receives meticulous attention. From the master bedroom to the kitchen, every bathroom to the balcony - we leave no spot untouched.',
        category: 'Home Cleaning',
        startingPrice: 2999,
        estimatedDuration: '8-9 hours',
        whatsIncluded: [
          'All rooms comprehensive cleaning',
          'Master bedroom special care',
          'Kitchen & dining area deep clean',
          'All bathrooms sanitization',
          'Balcony cleaning',
        ],
      ),
      ServiceModel(
        id: 'home_kitchen',
        imageUrl: 'https://www.blinklean.com/assets/images/kitchen_deep_cleaning.png',
        name: 'Kitchen Cleaning',
        icon: Icons.kitchen_rounded,
        shortDescription:
            'Deep kitchen cleaning - chimney, cabinets & surfaces.',
        fullDescription:
            'The kitchen is the heart of your home - keep it healthy. Our specialists tackle stubborn grease on chimney filters, stovetops, and cabinets. Countertops are sanitized, tiles gleam, and your kitchen becomes a place you truly enjoy cooking in.',
        category: 'Home Cleaning',
        startingPrice: 1299,
        estimatedDuration: '3-4 hours',
        whatsIncluded: [
          'Chimney degreasing & cleaning',
          'Stovetop & burner cleaning',
          'Cabinet exterior wiping',
          'Countertop sanitization',
          'Tile & grout scrubbing',
        ],
      ),
      ServiceModel(
        id: 'home_bathroom',
        imageUrl: 'https://www.blinklean.com/assets/images/bathroom_cleaning.png',
        name: 'Bathroom Cleaning',
        icon: Icons.bathtub_rounded,
        shortDescription:
            'Sparkling clean bathrooms with anti-bacterial treatment.',
        fullDescription:
            'Nobody enjoys scrubbing bathrooms. Let us handle it. Our team removes hard water stains, eliminates bacteria, and leaves your bathroom sparkling. Fresh, hygienic, and genuinely clean - not just surface-level.',
        category: 'Home Cleaning',
        startingPrice: 599,
        priceUnit: '/bath',
        estimatedDuration: '1-2 hours',
        whatsIncluded: [
          'WC deep cleaning & sanitization',
          'Tile & grout scrubbing',
          'Fitting descaling',
          'Mirror & glass cleaning',
          'Floor mopping & sanitization',
        ],
      ),
      ServiceModel(
        id: 'home_sofa',
        imageUrl: 'https://www.blinklean.com/assets/images/sofa_cleaning.png',
        name: 'Sofa Cleaning',
        icon: Icons.chair_rounded,
        shortDescription: 'Professional sofa cleaning - remove stains & odors.',
        fullDescription:
            'Your sofa sees a lot of action - it\'s time for a refresh. We use advanced extraction methods to pull out embedded dust, stains, and allergens. Your upholstery gets a new lease of life - looking and smelling fresh again.',
        category: 'Home Cleaning',
        startingPrice: 399,
        priceUnit: '/seat',
        estimatedDuration: '1-2 hours',
        whatsIncluded: [
          'Deep vacuuming',
          'Stain removal treatment',
          'Steam sanitization',
          'Fabric conditioning',
          'Odor elimination',
        ],
      ),
      ServiceModel(
        id: 'home_carpet',
        name: 'Carpet Cleaning',
        icon: Icons.square_rounded,
        shortDescription:
            'Industrial carpet cleaning with quick-dry technology.',
        fullDescription:
            'Carpets hide more dirt than you\'d like to think. Our industrial-grade equipment extracts deep-seated dirt and stains, leaving your carpets clean and fresh. Quick-dry technology means you can walk on them the same day.',
        category: 'Home Cleaning',
        startingPrice: 25,
        priceUnit: '/sq.ft',
        estimatedDuration: '2-3 hours',
        whatsIncluded: [
          'Deep vacuuming',
          'Stain pre-treatment',
          'Hot water extraction',
          'Quick-dry treatment',
          'Fiber conditioning',
        ],
      ),
      ServiceModel(
        id: 'home_office',
        name: 'Office Cleaning',
        icon: Icons.business_rounded,
        shortDescription: 'Professional workspace cleaning for productivity.',
        fullDescription:
            'A clean office creates the right impression and boosts productivity. Our trained staff ensure all work areas, meeting rooms, and restrooms meet professional hygiene standards. Your team deserves a workspace that\'s as clean as your home.',
        category: 'Home Cleaning',
        startingPrice: 3,
        priceUnit: '/sq.ft',
        estimatedDuration: 'Based on area',
        whatsIncluded: [
          'Workstation dusting & cleaning',
          'Floor mopping & vacuuming',
          'Common area sanitization',
          'Restroom deep cleaning',
          'Kitchen/pantry cleaning',
        ],
      ),

      // === VEHICLE CLEANING ===
      ServiceModel(
        id: 'vehicle_car_exterior',
        imageUrl: 'https://www.blinklean.com/assets/images/car_exterior_wash.png',
        name: 'Car Waterless Wash',
        icon: Icons.directions_car_rounded,
        shortDescription: 'Eco-friendly car wash - saves 150L of water!',
        fullDescription:
            'Who says car wash needs liters of water? Our innovative waterless technology uses premium detailing sprays and microfiber techniques to safely remove dust, bird droppings, and light grime. Your car gets a showroom shine while you save water.',
        category: 'Vehicle Care',
        startingPrice: 299,
        estimatedDuration: '1 hour',
        whatsIncluded: [
          'Body panel wiping & glossing',
          'Wheel & tire cleaning',
          'Windows & mirrors cleaning',
          'Interior dashboard dusting',
          'Waterless protective coating',
        ],
      ),
      ServiceModel(
        id: 'vehicle_car_full',
        imageUrl: 'https://www.blinklean.com/assets/images/car_interior_cleaning.png',
        name: 'Car Interior + Exterior',
        icon: Icons.directions_car_rounded,
        shortDescription: 'Complete car spa - inside and outside detailing.',
        fullDescription:
            'The complete car care package. We combine waterless exterior detailing with thorough interior cleaning - vacuuming seats, cleaning the dashboard, wiping all surfaces, and freshening up the cabin. Your car feels like new again.',
        category: 'Vehicle Care',
        startingPrice: 499,
        estimatedDuration: '2 hours',
        whatsIncluded: [
          'Waterless exterior wash',
          'Complete interior vacuuming',
          'Dashboard & console cleaning',
          'Seat stain treatment',
          'Air freshener application',
        ],
      ),
      ServiceModel(
        id: 'vehicle_car_polish',
        name: 'Car Premium Polish',
        icon: Icons.auto_fix_high_rounded,
        shortDescription: 'Professional polishing with wax protection.',
        fullDescription:
            'Bring back that factory shine. Our multi-stage polishing removes minor scratches, swirl marks, and oxidation. The final carnauba wax coating provides long-lasting protection and an incredible glossy finish that turns heads on the road.',
        category: 'Vehicle Care',
        startingPrice: 699,
        estimatedDuration: '2-3 hours',
        whatsIncluded: [
          'Hand wash & decontamination',
          'Clay bar treatment',
          'Multi-stage polishing',
          'Premium carnauba wax coating',
          'Tire & trim dressing',
        ],
      ),
      ServiceModel(
        id: 'vehicle_bike_clean',
        imageUrl: 'https://www.blinklean.com/assets/images/bike_detailing.png',
        name: 'Bike Waterless Clean',
        icon: Icons.two_wheeler_rounded,
        shortDescription:
            'Quick bike detailing - chain cleaning & lubrication.',
        fullDescription:
            'Keep your two-wheeler looking pristine without the water waste. Our specialized detailing products safely clean chains, engines, and bodywork. Perfect between major services or when you need a quick refresh before a ride.',
        category: 'Vehicle Care',
        startingPrice: 149,
        estimatedDuration: '45 mins',
        whatsIncluded: [
          'Body panel cleaning & glossing',
          'Chain cleaning & lubrication',
          'Mirror & glass cleaning',
          'Handlebar & switchgear wiping',
          'Protective coating application',
        ],
      ),
      ServiceModel(
        id: 'vehicle_bike_polish',
        name: 'Bike Premium Polish',
        icon: Icons.motorcycle_rounded,
        shortDescription: 'Complete bike detailing with premium finish.',
        fullDescription:
            'Your motorcycle deserves premium care. From thorough body polishing to chrome cleaning, chain maintenance, and protective coating - we give your bike the royal treatment it deserves. Ready to ride in style.',
        category: 'Vehicle Care',
        startingPrice: 249,
        estimatedDuration: '1 hour',
        whatsIncluded: [
          'Full body polish & waxing',
          'Chrome parts cleaning',
          'Chain deep cleaning & lubrication',
          'Engine bay cleaning',
          'Seat conditioning',
        ],
      ),
      ServiceModel(
        id: 'vehicle_auto',
        name: 'Auto Rickshaw Cleaning',
        icon: Icons.electric_rickshaw_rounded,
        shortDescription:
            'Professional auto cleaning - attract more passengers!',
        fullDescription:
            'For auto drivers, a clean vehicle means more passengers and better reviews. Our quick yet thorough waterless service ensures your auto looks presentable and professional. Time-efficient so you can get back on the road faster.',
        category: 'Vehicle Care',
        startingPrice: 299,
        estimatedDuration: '1 hour',
        whatsIncluded: [
          'Exterior body cleaning',
          'Interior vacuuming',
          'Seat & canopy cleaning',
          'Meter & dashboard wiping',
          'Tyre dressing',
        ],
      ),
      ServiceModel(
        id: 'vehicle_cycle',
        name: 'Bicycle Wash',
        icon: Icons.pedal_bike_rounded,
        shortDescription: 'Basic bicycle wash with chain lubrication.',
        fullDescription:
            'Keep your bicycle in top condition. We wash, dry, and lubricate all moving parts including the chain, gears, and brakes. Regular maintenance extends your cycle\'s life and ensures smoother, safer rides.',
        category: 'Vehicle Care',
        startingPrice: 99,
        estimatedDuration: '30 mins',
        whatsIncluded: [
          'Frame & fork cleaning',
          'Wheel cleaning',
          'Chain cleaning & lubrication',
          'Brake check',
          'Gear tuning',
        ],
      ),

      // === LAUNDRY ===
      ServiceModel(
        id: 'laundry_wash_fold',
        imageUrl: 'https://www.blinklean.com/assets/images/wash_and_fold.png',
        name: 'Wash & Fold',
        icon: Icons.local_laundry_service_rounded,
        shortDescription: 'Premium laundry - washed, dried & neatly folded.',
        fullDescription:
            'Your everyday laundry, handled with exceptional care. Premium eco-detergents clean gently, careful handling protects fabrics, and meticulous folding leaves everything organized. Fresh, clean, and ready to wear.',
        category: 'Laundry',
        startingPrice: 79,
        priceUnit: '/kg',
        estimatedDuration: '24 hours',
        whatsIncluded: [
          'Premium eco-detergent wash',
          'Fabric softener treatment',
          'Neat folding',
          'Quality check',
          'Hygienic packing',
        ],
      ),
      ServiceModel(
        id: 'laundry_wash_iron',
        imageUrl: 'https://www.blinklean.com/assets/images/wash_and_iron.png',
        name: 'Wash & Iron',
        icon: Icons.iron_rounded,
        shortDescription: 'Complete laundry with professional steam ironing.',
        fullDescription:
            'The complete laundry solution for busy lives. We wash with care, dry to perfection, and finish with professional steam ironing. Each garment looks crisp and ready to wear - no ironing board needed on your end.',
        category: 'Laundry',
        startingPrice: 99,
        priceUnit: '/kg',
        estimatedDuration: '24 hours',
        whatsIncluded: [
          'Premium wash cycle',
          'Fabric softener treatment',
          'Professional steam ironing',
          'Perfect crease finishing',
          'Neat packing',
        ],
      ),
      ServiceModel(
        id: 'laundry_steam',
        name: 'Steam Iron Only',
        icon: Icons.iron_rounded,
        shortDescription: 'Professional ironing - crisp results every time.',
        fullDescription:
            'Got wrinkled clothes but no time to iron? We\'ve got you covered. Professional-grade steam irons ensure perfect results on every fabric type - from delicate silks to heavy cottons. Wrinkle-free, crisp, and ready to wear.',
        category: 'Laundry',
        startingPrice: 10,
        priceUnit: '/cloth',
        estimatedDuration: 'Same day',
        whatsIncluded: [
          'Professional steam ironing',
          'Temperature adjustment per fabric',
          'Crease perfection',
          'Immediate packaging',
        ],
      ),
      ServiceModel(
        id: 'laundry_dry',
        imageUrl: 'https://www.blinklean.com/assets/images/dry_cleaning.png',
        name: 'Dry Cleaning',
        icon: Icons.dry_cleaning_rounded,
        shortDescription:
            'Expert dry cleaning for delicate & premium garments.',
        fullDescription:
            'For garments that need special handling, trust our expert care. Eco-safe solvents clean gently without damaging delicate fabrics. Suits, sarees, gowns, and designer wear return fresh, impeccably finished, and ready to wear.',
        category: 'Laundry',
        startingPrice: 149,
        priceUnit: '+',
        estimatedDuration: '48 hours',
        whatsIncluded: [
          'Eco-safe dry cleaning',
          'Stain pre-treatment',
          'Professional finishing',
          'Garment shaping',
          'Premium packaging',
        ],
      ),
    ];
  }

  static List<ServiceModel> getHomeCleaningServices() {
    return getAllServices()
        .where((s) => s.category == 'Home Cleaning')
        .toList();
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
