const express = require('express');
const router = express.Router();
const { verifyFirebaseToken } = require('../middleware/auth');
const {
  getCurrentUser,
  updateUser
} = require('../controllers/userController');

router.get('/me', verifyFirebaseToken, getCurrentUser);
router.put('/me', verifyFirebaseToken, updateUser);

module.exports = router;
