const express = require('express');
const router = express.Router();
const { verifyCognitoToken } = require('../middleware/auth');
const {
  getProviderProfile,
  getProviderById,
  updateProviderStatus,
  getProviderBookings,
  assignBookingToProvider,
  updateBookingStatus
} = require('../controllers/providerController');

// Provider routes (all require authentication)
router.get('/me', verifyCognitoToken, getProviderProfile);
router.get('/bookings', verifyCognitoToken, getProviderBookings);
router.put('/status', verifyCognitoToken, updateProviderStatus);
router.put('/assign', verifyCognitoToken, assignBookingToProvider);
router.put('/booking/status', verifyCognitoToken, updateBookingStatus);

// Public routes
router.get('/:providerId', getProviderById);

module.exports = router;
