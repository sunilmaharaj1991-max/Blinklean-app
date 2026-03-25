const express = require('express');
const router = express.Router();
const { verifyFirebaseToken, optionalAuth } = require('../middleware/auth');
const { 
  createScrapPickup, 
  getUserScrapPickups, 
  getScrapPickupById, 
  cancelScrapPickup
} = require('../controllers/scrapController');

// User routes
router.post('/', verifyFirebaseToken, createScrapPickup);
router.get('/my', verifyFirebaseToken, getUserScrapPickups);
router.get('/:pickupId', optionalAuth, getScrapPickupById);
router.put('/:pickupId/cancel', verifyFirebaseToken, cancelScrapPickup);

module.exports = router;
