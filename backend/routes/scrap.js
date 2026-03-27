const express = require('express');
const router = express.Router();
const { verifyCognitoToken, optionalAuth } = require('../middleware/auth');
const { 
  createScrapPickup, 
  getUserScrapPickups, 
  getScrapPickupById, 
  cancelScrapPickup
} = require('../controllers/scrapController');

// User routes
router.post('/', optionalAuth, createScrapPickup); // Matches both /api/scrap and /scrap-pickup
router.get('/my', verifyCognitoToken, getUserScrapPickups);
router.get('/:pickupId', optionalAuth, getScrapPickupById);
router.put('/:pickupId/cancel', verifyCognitoToken, cancelScrapPickup);

module.exports = router;
