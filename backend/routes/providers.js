const express = require('express');
const router = express.Router();
const { verifyFirebaseToken } = require('../middleware/auth');
const {
  getProviderProfile,
  getProviderById,
  updateProviderStatus,
  getProviderBookings,
  assignBookingToProvider,
  updateBookingStatus
} = require('../controllers/providerController');

// Provider routes (all require authentication)
router.get('/me', verifyFirebaseToken, getProviderProfile);
router.get('/bookings', verifyFirebaseToken, getProviderBookings);
router.put('/status', verifyFirebaseToken, updateProviderStatus);
router.put('/assign', verifyFirebaseToken, assignBookingToProvider);
router.put('/booking/status', verifyFirebaseToken, updateBookingStatus);

// Public routes
router.get('/:providerId', getProviderById);

module.exports = router;
