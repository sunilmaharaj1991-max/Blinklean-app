require('dotenv').config();
const mongoose = require('mongoose');

const seedData = async () => {
  try {
    console.log('🔌 Connecting to MongoDB...');
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('✅ Connected to MongoDB');

    const db = mongoose.connection.db;
    
    console.log('\n📦 Creating collections...');
    
    const collections = ['users', 'services', 'bookings', 'scrap_pickups', 'scrap_prices', 'providers', 'notifications', 'pincode_availability'];
    
    for (const name of collections) {
      try {
        await db.createCollection(name);
        console.log(`  ✅ Created: ${name}`);
      } catch (e) {
        if (e.code === 48) {
          console.log(`  ⏭️  Already exists: ${name}`);
        } else {
          console.log(`  ⚠️  ${name}: ${e.message}`);
        }
      }
    }

    console.log('\n🌱 Seeding data...');

    // Services
    const servicesCollection = db.collection('services');
    const servicesExist = await servicesCollection.countDocuments();
    if (servicesExist === 0) {
      await servicesCollection.insertMany([
        { id: 'svc_001', name: 'Deep Cleaning', category: 'Home Cleaning', shortDescription: 'Thorough deep cleaning for your entire home', fullDescription: 'Professional deep cleaning service that covers all rooms, corners, and hard-to-reach areas.', startingPrice: 999, estimatedDuration: '3 hours', icon: 'cleaning_services', isActive: true },
        { id: 'svc_002', name: 'Regular Cleaning', category: 'Home Cleaning', shortDescription: 'Regular maintenance cleaning', fullDescription: 'Regular cleaning service for maintaining a tidy home.', startingPrice: 499, estimatedDuration: '1.5 hours', icon: 'home', isActive: true },
        { id: 'svc_003', name: 'Bedroom Cleaning', category: 'Home Cleaning', shortDescription: 'Professional bedroom cleaning', fullDescription: 'Deep cleaning for your bedroom including dusting, vacuuming, and bed making.', startingPrice: 349, estimatedDuration: '1 hour', icon: 'bed', isActive: true },
        { id: 'svc_004', name: 'Kitchen Cleaning', category: 'Home Cleaning', shortDescription: 'Deep kitchen cleaning service', fullDescription: 'Thorough kitchen cleaning including appliances, cabinets, and surfaces.', startingPrice: 449, estimatedDuration: '1.5 hours', icon: 'kitchen', isActive: true },
        { id: 'svc_005', name: 'Bathroom Cleaning', category: 'Home Cleaning', shortDescription: 'Hygienic bathroom cleaning', fullDescription: 'Professional bathroom sanitization and cleaning.', startingPrice: 299, estimatedDuration: '45 mins', icon: 'bathtub', isActive: true },
        { id: 'svc_006', name: 'Sofa Cleaning', category: 'Home Cleaning', shortDescription: 'Professional sofa cleaning', fullDescription: 'Deep cleaning for all types of sofas and upholstered furniture.', startingPrice: 599, estimatedDuration: '1 hour', icon: 'chair', isActive: true },
        { id: 'svc_007', name: 'Carpet Cleaning', category: 'Home Cleaning', shortDescription: 'Deep carpet cleaning', fullDescription: 'Professional carpet shampooing and stain removal.', startingPrice: 799, estimatedDuration: '1.5 hours', icon: 'texture', isActive: true },
        { id: 'svc_008', name: 'Window Cleaning', category: 'Home Cleaning', shortDescription: 'Interior window cleaning', fullDescription: 'Cleaning of all interior windows and glass surfaces.', startingPrice: 249, estimatedDuration: '45 mins', icon: 'window', isActive: true },
        { id: 'svc_009', name: 'Electrician', category: 'Vehicle Care', shortDescription: 'Professional electrician service', fullDescription: 'Expert electrical repairs and installations.', startingPrice: 199, estimatedDuration: '1 hour', icon: 'electrical_services', isActive: true },
        { id: 'svc_010', name: 'Plumber', category: 'Vehicle Care', shortDescription: 'Expert plumbing services', fullDescription: 'Professional plumbing repairs and installations.', startingPrice: 199, estimatedDuration: '1 hour', icon: 'plumbing', isActive: true },
        { id: 'svc_011', name: 'AC Service', category: 'Vehicle Care', shortDescription: 'AC servicing and repair', fullDescription: 'Complete AC servicing, gas top-up, and repairs.', startingPrice: 449, estimatedDuration: '1.5 hours', icon: 'ac_unit', isActive: true },
        { id: 'svc_012', name: 'Pest Control', category: 'Scrap & Recycling', shortDescription: 'Complete pest control treatment', fullDescription: 'Professional pest control for bugs, rodents, and insects.', startingPrice: 999, estimatedDuration: '2 hours', icon: 'pest_control', isActive: true },
      ]);
      console.log('  ✅ Seeded: services (12 items)');
    } else {
      console.log('  ⏭️  Services already exist');
    }

    // Scrap Prices
    const scrapPricesCollection = db.collection('scrap_prices');
    const scrapPricesExist = await scrapPricesCollection.countDocuments();
    if (scrapPricesExist === 0) {
      await scrapPricesCollection.insertMany([
        { category: 'Paper', displayName: 'Newspaper', pricePerKg: { min: 10, max: 15, current: 12 }, icon: 'description', description: 'Old newspapers and magazines' },
        { category: 'Cardboard', displayName: 'Cardboard Boxes', pricePerKg: { min: 6, max: 10, current: 8 }, icon: 'inventory_2', description: 'Flattened cardboard boxes' },
        { category: 'Paper', displayName: 'Books', pricePerKg: { min: 12, max: 18, current: 15 }, icon: 'menu_book', description: 'Old books and notebooks' },
        { category: 'Plastic', displayName: 'Plastic Bottles', pricePerKg: { min: 15, max: 22, current: 18 }, icon: 'local_drink', description: 'Clean plastic bottles' },
        { category: 'Plastic', displayName: 'HDPE Plastics', pricePerKg: { min: 18, max: 28, current: 22 }, icon: 'recycling', description: 'High-density polyethylene plastics' },
        { category: 'Metal', displayName: 'Aluminum Cans', pricePerKg: { min: 75, max: 95, current: 85 }, icon: 'inventory', description: 'Aluminum beverage cans' },
        { category: 'Metal', displayName: 'Copper Wire', pricePerKg: { min: 400, max: 500, current: 450 }, icon: 'cable', description: 'Copper electrical wires' },
        { category: 'Metal', displayName: 'Steel', pricePerKg: { min: 25, max: 40, current: 35 }, icon: 'hardware', description: 'Steel and iron scrap' },
        { category: 'Metal', displayName: 'Brass', pricePerKg: { min: 250, max: 310, current: 280 }, icon: 'settings', description: 'Brass fixtures and scrap' },
        { category: 'Glass', displayName: 'Glass Bottles', pricePerKg: { min: 4, max: 8, current: 6 }, icon: 'local_bar', description: 'Clean glass bottles' },
        { category: 'Metal', displayName: 'Iron', pricePerKg: { min: 20, max: 35, current: 28 }, icon: 'fence', description: 'Iron scrap and旧铁' },
        { category: 'E-Waste', displayName: 'Electronic Waste', pricePerKg: { min: 40, max: 60, current: 50 }, icon: 'devices', description: 'Old electronic devices' },
      ]);
      console.log('  ✅ Seeded: scrap_prices (12 items)');
    } else {
      console.log('  ⏭️  Scrap prices already exist');
    }

    // Pincode Availability
    const pincodeCollection = db.collection('pincode_availability');
    const pincodeExist = await pincodeCollection.countDocuments();
    if (pincodeExist === 0) {
      await pincodeCollection.insertMany([
        { pincode: '560001', city: 'Bangalore', available: true },
        { pincode: '560002', city: 'Bangalore', available: true },
        { pincode: '560003', city: 'Bangalore', available: true },
        { pincode: '560004', city: 'Bangalore', available: true },
        { pincode: '560005', city: 'Bangalore', available: true },
        { pincode: '560006', city: 'Bangalore', available: true },
        { pincode: '560007', city: 'Bangalore', available: true },
        { pincode: '560008', city: 'Bangalore', available: true },
        { pincode: '560009', city: 'Bangalore', available: true },
        { pincode: '560010', city: 'Bangalore', available: true },
        { pincode: '560011', city: 'Bangalore', available: true },
        { pincode: '560012', city: 'Bangalore', available: true },
        { pincode: '560016', city: 'Bangalore', available: true },
        { pincode: '560017', city: 'Bangalore', available: true },
        { pincode: '560025', city: 'Bangalore', available: true },
        { pincode: '560034', city: 'Bangalore', available: true },
        { pincode: '560037', city: 'Bangalore', available: true },
        { pincode: '560043', city: 'Bangalore', available: true },
        { pincode: '560048', city: 'Bangalore', available: true },
        { pincode: '560095', city: 'Bangalore', available: true },
      ]);
      console.log('  ✅ Seeded: pincode_availability (20 pincodes)');
    } else {
      console.log('  ⏭️  Pincode availability already exists');
    }

    console.log('\n✅ Database setup complete!');
    console.log('\n📊 Collections:');
    const allCollections = await db.listCollections().toArray();
    allCollections.forEach(c => console.log(`  - ${c.name}`));

  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    await mongoose.disconnect();
    console.log('\n🔌 Disconnected from MongoDB');
    process.exit(0);
  }
};

seedData();
