import { dbPromise } from '../lib/mongodb.js';

async function testConnection() {
  try {
    // Wait for the client connection promise to resolve
    const client = await dbPromise;
    
    // Optionally ping the admin database to confirm an active connection
    await client.db('admin').command({ ping: 1 });
    
    console.log('🚀 Blinklean is officially connected!');
  } catch (error) {
    console.error('Failed to connect to Blinklean database:', error);
    process.exit(1);
  } finally {
    // Ensure the node process ends correctly after the test
    process.exit(0);
  }
}

testConnection();
