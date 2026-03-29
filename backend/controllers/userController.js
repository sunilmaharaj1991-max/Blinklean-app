const { ddbDocClient } = require('../config/db');
const { 
  GetCommand, 
  PutCommand, 
  UpdateCommand,
  QueryCommand 
} = require('@aws-sdk/lib-dynamodb');

const USERS_TABLE = process.env.DYNAMODB_USERS_TABLE || 'BlinkleanUsers';

const syncAmplifyUser = async (req, res) => {
  try {
    const uid = req.user.uid;
    const { name, email, phone } = req.body;
    
    if (!uid) {
      return res.status(400).json({ error: 'Amplify UID is required from token' });
    }

    const { Item: user } = await ddbDocClient.send(new GetCommand({
      TableName: USERS_TABLE,
      Key: { amplifyUid: uid }
    }));
    
    const now = new Date().toISOString();

    if (user) {
      // Update existing user
      const updateParams = {
        TableName: USERS_TABLE,
        Key: { amplifyUid: uid },
        UpdateExpression: 'set #n = :n, email = :e, phone = :p, lastLogin = :l',
        ExpressionAttributeNames: { '#n': 'name' },
        ExpressionAttributeValues: {
          ':n': name || user.name,
          ':e': email || user.email,
          ':p': phone || user.phone,
          ':l': now
        },
        ReturnValues: 'ALL_NEW'
      };
      const result = await ddbDocClient.send(new UpdateCommand(updateParams));
      return res.json({ success: true, user: result.Attributes });
    } else {
      // Create new user
      const newUser = {
        amplifyUid: uid,
        name: name || 'User',
        email: email || '',
        phone: phone || '',
        createdAt: now,
        lastLogin: now,
        role: 'customer' // Default role
      };
      await ddbDocClient.send(new PutCommand({
        TableName: USERS_TABLE,
        Item: newUser
      }));
      return res.json({ success: true, user: newUser });
    }
  } catch (error) {
    console.error('Sync user error:', error);
    res.status(500).json({ error: error.message });
  }
};

const getCurrentUser = async (req, res) => {
  try {
    const { Item: user } = await ddbDocClient.send(new GetCommand({
      TableName: USERS_TABLE,
      Key: { amplifyUid: req.user.uid }
    }));
    
    if (!user) {
      return res.status(404).json({ error: 'User not found in DynamoDB' });
    }

    res.json({ user });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateUser = async (req, res) => {
  try {
    const updates = req.body;
    const allowedUpdates = ['name', 'email', 'address', 'fcmToken'];
    
    let updateExpression = 'set';
    let ExpressionAttributeNames = {};
    let ExpressionAttributeValues = {};

    allowedUpdates.forEach((key, index) => {
      if (updates[key] !== undefined) {
        const attrName = `#attr${index}`;
        const attrVal = `:val${index}`;
        updateExpression += ` ${attrName} = ${attrVal},`;
        ExpressionAttributeNames[attrName] = key;
        ExpressionAttributeValues[attrVal] = updates[key];
      }
    });

    // Remove trailing comma
    updateExpression = updateExpression.slice(0, -1);

    if (Object.keys(ExpressionAttributeValues).length === 0) {
      return res.status(400).json({ error: 'No valid update fields provided' });
    }

    const { Attributes } = await ddbDocClient.send(new UpdateCommand({
      TableName: USERS_TABLE,
      Key: { amplifyUid: req.user.uid },
      UpdateExpression: updateExpression,
      ExpressionAttributeNames,
      ExpressionAttributeValues,
      ReturnValues: 'ALL_NEW'
    }));

    res.json({ success: true, user: Attributes });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateAddress = async (req, res) => {
  try {
    const { address } = req.body;
    if (!address) {
      return res.status(400).json({ error: 'Address is required' });
    }

    const { Attributes } = await ddbDocClient.send(new UpdateCommand({
      TableName: USERS_TABLE,
      Key: { amplifyUid: req.user.uid },
      UpdateExpression: 'set address = :a',
      ExpressionAttributeValues: { ':a': address },
      ReturnValues: 'ALL_NEW'
    }));

    res.json({ success: true, user: Attributes });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getUserStats = async (req, res) => {
  try {
    // Minimal placeholder stats
    res.json({
      success: true,
      stats: {
        totalBookings: 0,
        completedBookings: 0,
        totalSpent: 0
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  syncAmplifyUser,
  getCurrentUser,
  updateUser,
  updateAddress,
  getUserStats
};
