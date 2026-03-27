const express = require('express');
const router = express.Router();
const Razorpay = require('razorpay');
const { ddbDocClient } = require('../config/db');
const { UpdateCommand } = require('@aws-sdk/lib-dynamodb');

const BOOKINGS_TABLE = process.env.DYNAMODB_BOOKINGS_TABLE || 'BlinkleanBookings';

const razorpay = new Razorpay({
  key_id: process.env.RAZORPAY_KEY_ID,
  key_secret: process.env.RAZORPAY_KEY_SECRET
});

// Create Razorpay order
router.post('/create-order', async (req, res) => {
  try {
    const { bookingId, amount } = req.body;

    const options = {
      amount: Math.round(amount * 100), // Razorpay expects paise
      currency: 'INR',
      receipt: `rcpt_${bookingId}`,
      notes: {
        bookingId,
        type: 'service'
      }
    };

    const order = await razorpay.orders.create(options);
    
    res.json({
      success: true,
      orderId: order.id,
      amount: order.amount,
      currency: order.currency
    });
  } catch (error) {
    console.error('Razorpay error:', error);
    res.status(500).json({ error: error.message });
  }
});

// Verify payment
router.post('/verify', async (req, res) => {
  try {
    const { razorpay_order_id, razorpay_payment_id, razorpay_signature, bookingId } = req.body;

    // Verify signature
    const crypto = require('crypto');
    const generatedSignature = crypto
      .createHmac('sha256', process.env.RAZORPAY_KEY_SECRET)
      .update(`${razorpay_order_id}|${razorpay_payment_id}`)
      .digest('hex');

    if (generatedSignature === razorpay_signature) {
      // Update booking payment status
      await ddbDocClient.send(new UpdateCommand({
        TableName: BOOKINGS_TABLE,
        Key: { bookingId },
        UpdateExpression: 'set #p.#s = :s, #p.transactionId = :t, #p.paidAt = :d',
        ExpressionAttributeNames: {
          '#p': 'payment',
          '#s': 'status'
        },
        ExpressionAttributeValues: {
          ':s': 'paid',
          ':t': razorpay_payment_id,
          ':d': new Date().toISOString()
        }
      }));

      res.json({ success: true, message: 'Payment verified' });
    } else {
      res.status(400).json({ success: false, message: 'Invalid signature' });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
