const express = require('express');
const router = express.Router();
const { verifyCognitoToken } = require('../middleware/auth');
const {
  syncAmplifyUser,
  getCurrentUser,
  updateUser,
  updateAddress,
  getUserStats
} = require('../controllers/userController');

router.get('/me', verifyCognitoToken, getCurrentUser);
router.post('/sync', verifyCognitoToken, syncAmplifyUser);
router.put('/me', verifyCognitoToken, updateUser);
router.put('/address', verifyCognitoToken, updateAddress);
router.get('/stats', verifyCognitoToken, getUserStats);

module.exports = router;
