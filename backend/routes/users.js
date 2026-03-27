const express = require('express');
const router = express.Router();
const { verifyCognitoToken } = require('../middleware/auth');
const {
  getCurrentUser,
  updateUser
} = require('../controllers/userController');

router.get('/me', verifyCognitoToken, getCurrentUser);
router.put('/me', verifyCognitoToken, updateUser);

module.exports = router;
