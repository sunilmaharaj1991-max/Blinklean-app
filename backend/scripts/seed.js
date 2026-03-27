require('dotenv').config();
const { ddbDocClient } = require('../config/db');
const { PutCommand } = require('@aws-sdk/lib-dynamodb');

const SERVICES_TABLE = process.env.DYNAMODB_SERVICES_TABLE || 'BlinkleanServices';
const SCRAP_PRICES_TABLE = process.env.DYNAMODB_SCRAP_PRICES_TABLE || 'BlinkleanScrapPrices';

const seedData = async () => {
  try {
    console.log('🌱 Seeding DynamoDB data...');

    // Services
    const services = [
      { id: 'svc_001', name: 'Deep Cleaning', category: 'Home Cleaning', shortDescription: 'Thorough deep cleaning', startingPrice: 999, icon: 'cleaning_services', isActive: true, order: 1 },
      { id: 'svc_002', name: 'Regular Cleaning', category: 'Home Cleaning', shortDescription: 'Maintenance cleaning', startingPrice: 499, icon: 'home', isActive: true, order: 2 },
      { id: 'svc_009', name: 'Car Wash', category: 'Vehicle Care', shortDescription: 'Waterless car cleaning', startingPrice: 199, icon: 'directions_car', isActive: true, order: 1 },
      { id: 'svc_010', name: 'Bike Wash', category: 'Vehicle Care', shortDescription: 'Waterless bike cleaning', startingPrice: 99, icon: 'motorcycle', isActive: true, order: 2 }
    ];

    console.log(`\n📦 Seeding ${SERVICES_TABLE}...`);
    for (const service of services) {
      await ddbDocClient.send(new PutCommand({
        TableName: SERVICES_TABLE,
        Item: { ...service, createdAt: new Date().toISOString() }
      }));
      console.log(`  ✅ Seeded: ${service.name}`);
    }

    // Scrap Prices
    const scrapPrices = [
      { category: 'Paper', displayName: 'Newspaper', pricePerKg: 12, icon: 'description' },
      { category: 'Plastic', displayName: 'Plastic Bottles', pricePerKg: 18, icon: 'local_drink' },
      { category: 'Metal', displayName: 'Iron', pricePerKg: 28, icon: 'fence' }
    ];

    console.log(`\n📦 Seeding ${SCRAP_PRICES_TABLE}...`);
    for (const item of scrapPrices) {
      const itemId = `${item.category}-${item.displayName}`.toLowerCase().replace(/\s+/g, '_');
      await ddbDocClient.send(new PutCommand({
        TableName: SCRAP_PRICES_TABLE,
        Item: { id: itemId, ...item, updatedAt: new Date().toISOString() }
      }));
      console.log(`  ✅ Seeded: ${item.displayName}`);
    }

    console.log('\n✅ Seeding complete!');
  } catch (error) {
    console.error('❌ Error seeding data:', error.message);
  } finally {
    process.exit(0);
  }
};

seedData();
