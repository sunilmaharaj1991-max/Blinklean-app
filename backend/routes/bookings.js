const express = require('express');
const router = express.Router();
const { verifyCognitoToken, optionalAuth } = require('../middleware/auth');
const { 
  createBooking, 
  getUserBookings, 
  getBookingById, 
  cancelBooking, 
  rateBooking 
} = require('../controllers/bookingController');

// User routes
router.post('/', verifyCognitoToken, createBooking);
router.get('/', verifyCognitoToken, getUserBookings);
router.get('/:bookingId', optionalAuth, getBookingById);
router.put('/:bookingId/cancel', verifyCognitoToken, cancelBooking);
router.put('/:bookingId/rate', verifyCognitoToken, rateBooking);

module.exports = router;
