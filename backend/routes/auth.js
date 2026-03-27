const express = require('express');
const router = express.Router();
const { syncAmplifyUser, getCurrentUser, updateUser, updateAddress, getUserStats } = require('../controllers/userController');
const { verifyCognitoToken } = require('../middleware/auth');

// Sync user after Amplify auth (creates or updates user in MongoDB)
router.post('/sync', verifyCognitoToken, syncAmplifyUser);

// Get current user profile
router.get('/me', verifyCognitoToken, getCurrentUser);

// Update user profile
router.put('/me', verifyCognitoToken, updateUser);

// Update user address
router.put('/address', verifyCognitoToken, updateAddress);

// Get user stats
router.get('/stats', verifyCognitoToken, getUserStats);

module.exports = router;
