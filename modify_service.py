import re

with open('lib/models/service_model.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Add imageUrl field
content = content.replace('  final String name;\n  final IconData icon;\n', '  final String name;\n  final IconData icon;\n  final String imageUrl;\n')
content = content.replace('    required this.name,\n    required this.icon,\n', '    required this.name,\n    required this.icon,\n    this.imageUrl = \'\',\n')

images = {
    'home_1bhk': 'https://www.blinklean.com/assets/images/1bhk_cleaning.png',
    'home_2bhk': 'https://www.blinklean.com/assets/images/2bhk_cleaning.png',
    'home_3bhk': 'https://www.blinklean.com/assets/images/3bhk_cleaning.png',
    'home_kitchen': 'https://www.blinklean.com/assets/images/kitchen_deep_cleaning.png',
    'home_bathroom': 'https://www.blinklean.com/assets/images/bathroom_cleaning.png',
    'home_sofa': 'https://www.blinklean.com/assets/images/sofa_cleaning.png',
    'vehicle_car_exterior': 'https://www.blinklean.com/assets/images/car_exterior_wash.png',
    'vehicle_car_full': 'https://www.blinklean.com/assets/images/car_interior_cleaning.png',
    'vehicle_bike_clean': 'https://www.blinklean.com/assets/images/bike_detailing.png',
    'laundry_wash_fold': 'https://www.blinklean.com/assets/images/wash_and_fold.png',
    'laundry_wash_iron': 'https://www.blinklean.com/assets/images/wash_and_iron.png',
    'laundry_dry': 'https://www.blinklean.com/assets/images/dry_cleaning.png'
}

for k, v in images.items():
    if v:
        content = re.sub(
            f"id: '{k}',",
            f"id: '{k}',\n        imageUrl: '{v}',",
            content
        )

with open('lib/models/service_model.dart', 'w', encoding='utf-8') as f:
    f.write(content)
