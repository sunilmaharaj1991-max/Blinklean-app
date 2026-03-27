const { ddbDocClient } = require('../config/db');
const { 
  GetCommand, 
  PutCommand, 
  UpdateCommand, 
  ScanCommand,
  QueryCommand 
} = require('@aws-sdk/lib-dynamodb');

const PROVIDERS_TABLE = process.env.DYNAMODB_PROVIDERS_TABLE || 'BlinkleanProviders';
const BOOKINGS_TABLE = process.env.DYNAMODB_BOOKINGS_TABLE || 'BlinkleanBookings';
const SCRAP_TABLE = process.env.DYNAMODB_SCRAP_TABLE || 'BlinkleanScrapPickups';

const getProviderProfile = async (req, res) => {
  try {
    const uid = req.user?.uid;
    
    // Find provider by userId (using Scan if no GSI)
    const { Items: providers } = await ddbDocClient.send(new ScanCommand({
      TableName: PROVIDERS_TABLE,
      FilterExpression: 'userId = :uid',
      ExpressionAttributeValues: { ':uid': uid }
    }));
    
    if (!providers || providers.length === 0) {
      return res.status(404).json({ error: 'Provider profile not found' });
    }

    res.json({ provider: providers[0] });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getProviderById = async (req, res) => {
  try {
    const { providerId } = req.params;
    
    const { Item: provider } = await ddbDocClient.send(new GetCommand({
      TableName: PROVIDERS_TABLE,
      Key: { providerId }
    }));

    if (!provider) {
      return res.status(404).json({ error: 'Provider not found' });
    }

    res.json({ provider });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateProviderStatus = async (req, res) => {
  try {
    const { status } = req.body;
    const uid = req.user?.uid;
    
    // First get the providerId
    const { Items: providers } = await ddbDocClient.send(new ScanCommand({
      TableName: PROVIDERS_TABLE,
      FilterExpression: 'userId = :uid',
      ExpressionAttributeValues: { ':uid': uid }
    }));

    if (!providers || providers.length === 0) {
      return res.status(404).json({ error: 'Provider profile not found' });
    }

    const { Attributes: provider } = await ddbDocClient.send(new UpdateCommand({
      TableName: PROVIDERS_TABLE,
      Key: { providerId: providers[0].providerId },
      UpdateExpression: 'set #s = :s, lastActive = :l',
      ExpressionAttributeNames: { '#s': 'status' },
      ExpressionAttributeValues: {
        ':s': status,
        ':l': new Date().toISOString()
      },
      ReturnValues: 'ALL_NEW'
    }));

    res.json({ success: true, provider });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getProviderBookings = async (req, res) => {
  try {
    const uid = req.user?.uid;
    
    const { Items: providers } = await ddbDocClient.send(new ScanCommand({
      TableName: PROVIDERS_TABLE,
      FilterExpression: 'userId = :uid',
      ExpressionAttributeValues: { ':uid': uid }
    }));

    if (!providers || providers.length === 0) {
      return res.status(404).json({ error: 'Provider profile not found' });
    }

    const providerId = providers[0].providerId;

    // Get service bookings
    const { Items: serviceBookings } = await ddbDocClient.send(new ScanCommand({
      TableName: BOOKINGS_TABLE,
      FilterExpression: 'providerId = :p',
      ExpressionAttributeValues: { ':p': providerId }
    }));

    // Get scrap pickups
    const { Items: scrapPickups } = await ddbDocClient.send(new ScanCommand({
      TableName: SCRAP_TABLE,
      FilterExpression: 'providerId = :p',
      ExpressionAttributeValues: { ':p': providerId }
    }));

    // Combine and format
    const combined = [
      ...(serviceBookings || []).map(b => ({ ...b, type: 'service' })),
      ...(scrapPickups || []).map(p => ({ ...p, type: 'scrap' }))
    ].sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

    res.json({ bookings: combined });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  getProviderProfile,
  getProviderById,
  updateProviderStatus,
  getProviderBookings
};
