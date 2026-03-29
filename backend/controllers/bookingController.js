const { ddbDocClient } = require('../config/db');
const { 
  GetCommand, 
  PutCommand, 
  UpdateCommand, 
  ScanCommand,
  QueryCommand 
} = require('@aws-sdk/lib-dynamodb');

const BOOKINGS_TABLE = process.env.DYNAMODB_BOOKINGS_TABLE || 'BlinkleanBookings';
const USERS_TABLE = process.env.DYNAMODB_USERS_TABLE || 'BlinkleanUsers';

const createBooking = async (req, res) => {
  try {
    const bookingData = req.body;
    const uid = req.user.uid;

    if (!uid) {
      return res.status(401).json({ error: 'User UID not found in token' });
    }

    const bookingId = `BK-${Date.now()}-${Math.floor(Math.random() * 1000)}`;
    const now = new Date().toISOString();

    const newBooking = {
      ...bookingData,
      bookingId,
      userId: uid, // Use Cognito UID as the link
      status: 'pending',
      createdAt: now,
      updatedAt: now,
      statusHistory: [{
        status: 'pending',
        timestamp: now,
        note: 'Booking created'
      }]
    };

    await ddbDocClient.send(new PutCommand({
      TableName: BOOKINGS_TABLE,
      Item: newBooking
    }));

    // Increment user stats (Async update)
    try {
      await ddbDocClient.send(new UpdateCommand({
        TableName: USERS_TABLE,
        Key: { amplifyUid: uid },
        UpdateExpression: 'set totalBookings = if_not_exists(totalBookings, :start) + :inc',
        ExpressionAttributeValues: { ':inc': 1, ':start': 0 }
      }));
    } catch (err) {
      console.warn('Failed to update user stats:', err.message);
    }

    res.status(201).json({
      success: true,
      booking: newBooking
    });
  } catch (error) {
    console.error('Create booking error:', error);
    res.status(500).json({ error: error.message });
  }
};

const getUserBookings = async (req, res) => {
  try {
    const uid = req.user.uid;
    const { status } = req.query;

    // Use Query if GSI exists, otherwise Scan (with filter)
    const params = {
      TableName: BOOKINGS_TABLE,
      FilterExpression: 'userId = :uid',
      ExpressionAttributeValues: { ':uid': uid }
    };

    if (status) {
      params.FilterExpression += ' AND #s = :status';
      params.ExpressionAttributeNames = { '#s': 'status' };
      params.ExpressionAttributeValues[':status'] = status;
    }

    const { Items: bookings } = await ddbDocClient.send(new ScanCommand(params));

    // Sort manually since Scan doesn't support OrderBy
    const sortedBookings = (bookings || []).sort((a, b) => 
      new Date(b.createdAt) - new Date(a.createdAt)
    );

    res.json({
      bookings: sortedBookings,
      total: sortedBookings.length
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getBookingById = async (req, res) => {
  try {
    const { bookingId } = req.params;
    
    const { Item: booking } = await ddbDocClient.send(new GetCommand({
      TableName: BOOKINGS_TABLE,
      Key: { bookingId }
    }));

    if (!booking) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    res.json({ booking });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const cancelBooking = async (req, res) => {
  try {
    const { bookingId } = req.params;
    const { reason } = req.body;
    const now = new Date().toISOString();

    const { Attributes: booking } = await ddbDocClient.send(new UpdateCommand({
      TableName: BOOKINGS_TABLE,
      Key: { bookingId },
      UpdateExpression: 'set #s = :s, cancellationReason = :r, updatedAt = :u, statusHistory = list_append(statusHistory, :h)',
      ExpressionAttributeNames: { '#s': 'status' },
      ExpressionAttributeValues: {
        ':s': 'cancelled',
        ':r': reason,
        ':u': now,
        ':h': [{
          status: 'cancelled',
          timestamp: now,
          note: reason
        }]
      },
      ReturnValues: 'ALL_NEW'
    }));

    res.json({ success: true, booking });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const rateBooking = async (req, res) => {
  try {
    const { bookingId } = req.params;
    const { stars, review } = req.body;

    const { Attributes: booking } = await ddbDocClient.send(new UpdateCommand({
      TableName: BOOKINGS_TABLE,
      Key: { bookingId },
      UpdateExpression: 'set rating = :r',
      ExpressionAttributeValues: {
        ':r': {
          given: true,
          stars,
          review,
          timestamp: new Date().toISOString()
        }
      },
      ReturnValues: 'ALL_NEW'
    }));

    res.json({ success: true, booking });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  createBooking,
  getUserBookings,
  getBookingById,
  cancelBooking,
  rateBooking
};
