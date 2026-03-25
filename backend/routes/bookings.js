const express = require('express');
const router = express.Router();
const { verifyFirebaseToken, optionalAuth } = require('../middleware/auth');
const { 
  createBooking, 
  getUserBookings, 
  getBookingById, 
  cancelBooking, 
  rateBooking 
} = require('../controllers/bookingController');

// User routes
router.post('/', verifyFirebaseToken, createBooking);
router.get('/', verifyFirebaseToken, getUserBookings);
router.get('/:bookingId', optionalAuth, getBookingById);
router.put('/:bookingId/cancel', verifyFirebaseToken, cancelBooking);
router.put('/:bookingId/rate', verifyFirebaseToken, rateBooking);

module.exports = router;
