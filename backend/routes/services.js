const express = require('express');
const router = express.Router();
const { verifyFirebaseToken } = require('../middleware/auth');
const { getAllServices, getServiceById, getServicesByCategory, getCategories } = require('../controllers/serviceController');

// Public routes
router.get('/', getAllServices);
router.get('/categories', getCategories);
router.get('/category/:category', getServicesByCategory);
router.get('/:id', getServiceById);

module.exports = router;
