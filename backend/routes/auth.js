const express = require('express');
const router = express.Router();
const { syncFirebaseUser, getCurrentUser, updateUser, updateAddress, getUserStats } = require('../controllers/userController');
const { verifyFirebaseToken } = require('../middleware/auth');

// Sync user after Firebase auth (creates or updates user in MongoDB)
router.post('/sync', verifyFirebaseToken, syncFirebaseUser);

// Get current user profile
router.get('/me', verifyFirebaseToken, getCurrentUser);

// Update user profile
router.put('/me', verifyFirebaseToken, updateUser);

// Update user address
router.put('/address', verifyFirebaseToken, updateAddress);

// Get user stats
router.get('/stats', verifyFirebaseToken, getUserStats);

module.exports = router;
