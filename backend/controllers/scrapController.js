const { ddbDocClient } = require('../config/db');
const { 
  GetCommand, 
  PutCommand, 
  UpdateCommand, 
  ScanCommand,
  QueryCommand 
} = require('@aws-sdk/lib-dynamodb');

const SCRAP_TABLE = process.env.DYNAMODB_SCRAP_TABLE || 'BlinkleanScrapPickups';
const USERS_TABLE = process.env.DYNAMODB_USERS_TABLE || 'BlinkleanUsers';

const createScrapPickup = async (req, res) => {
  try {
    const pickupData = req.body;
    let uid = req.user?.uid;

    const now = new Date().toISOString();
    const pickupId = `SP-${Date.now()}-${Math.floor(Math.random() * 1000)}`;

    // If guest (no uid), create a guest record
    if (!uid) {
      if (!pickupData.phone) {
        return res.status(400).json({ error: 'Phone number is required for guest pickup' });
      }
      uid = `guest_${pickupData.phone}`;
      
      // Try to create/update guest user in Users table
      try {
        await ddbDocClient.send(new PutCommand({
          TableName: USERS_TABLE,
          Item: {
            amplifyUid: uid,
            name: pickupData.name || 'Guest User',
            phone: pickupData.phone,
            role: 'guest',
            createdAt: now,
            lastLogin: now
          },
          ConditionExpression: 'attribute_not_exists(amplifyUid)'
        }));
      } catch (err) {
        // Guest may already exist, ignore error
      }
    }

    const newPickup = {
      ...pickupData,
      pickupId,
      userId: uid,
      status: 'pending',
      createdAt: now,
      updatedAt: now
    };

    await ddbDocClient.send(new PutCommand({
      TableName: SCRAP_TABLE,
      Item: newPickup
    }));

    // Increment user stats
    try {
      await ddbDocClient.send(new UpdateCommand({
        TableName: USERS_TABLE,
        Key: { amplifyUid: uid },
        UpdateExpression: 'set totalScrapSold = if_not_exists(totalScrapSold, :start) + :inc',
        ExpressionAttributeValues: { ':inc': 1, ':start': 0 }
      }));
    } catch (err) {
      console.warn('Failed to update scrap stats:', err.message);
    }

    res.status(201).json({
      success: true,
      pickup: newPickup
    });
  } catch (error) {
    console.error('Create scrap pickup error:', error);
    res.status(500).json({ error: error.message });
  }
};

const getUserScrapPickups = async (req, res) => {
  try {
    const uid = req.user.uid;
    const { status } = req.query;

    const params = {
      TableName: SCRAP_TABLE,
      FilterExpression: 'userId = :uid',
      ExpressionAttributeValues: { ':uid': uid }
    };

    if (status) {
      params.FilterExpression += ' AND #s = :status';
      params.ExpressionAttributeNames = { '#s': 'status' };
      params.ExpressionAttributeValues[':status'] = status;
    }

    const { Items: pickups } = await ddbDocClient.send(new ScanCommand(params));

    const sortedPickups = (pickups || []).sort((a, b) => 
      new Date(b.createdAt) - new Date(a.createdAt)
    );

    res.json({ pickups: sortedPickups });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getScrapPickupById = async (req, res) => {
  try {
    const { pickupId } = req.params;
    
    const { Item: pickup } = await ddbDocClient.send(new GetCommand({
      TableName: SCRAP_TABLE,
      Key: { pickupId }
    }));

    if (!pickup) {
      return res.status(404).json({ error: 'Pickup not found' });
    }

    res.json({ pickup });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const cancelScrapPickup = async (req, res) => {
  try {
    const { pickupId } = req.params;
    const { reason } = req.body;
    const now = new Date().toISOString();

    const { Attributes: pickup } = await ddbDocClient.send(new UpdateCommand({
      TableName: SCRAP_TABLE,
      Key: { pickupId },
      UpdateExpression: 'set #s = :s, cancellationReason = :r, updatedAt = :u',
      ExpressionAttributeNames: { '#s': 'status' },
      ExpressionAttributeValues: {
        ':s': 'cancelled',
        ':r': reason,
        ':u': now
      },
      ReturnValues: 'ALL_NEW'
    }));

    res.json({ success: true, pickup });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  createScrapPickup,
  getUserScrapPickups,
  getScrapPickupById,
  cancelScrapPickup
};
