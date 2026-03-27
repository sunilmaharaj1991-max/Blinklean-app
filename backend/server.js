require('dotenv').config();
const express = require('express');
const { ddbDocClient } = require('./config/db');

const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');

const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/users');
const serviceRoutes = require('./routes/services');
const bookingRoutes = require('./routes/bookings');
const scrapRoutes = require('./routes/scrap');
const providerRoutes = require('./routes/providers');
const paymentRoutes = require('./routes/payments');

const app = express();

app.use(helmet());
app.use(cors()); // Simplified for now
app.use(express.json());

console.log('✅ AWS DynamoDB Client Initialized');

// API Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/services', serviceRoutes);
app.use('/api/bookings', bookingRoutes);
app.use('/api/scrap', scrapRoutes);
app.use('/api/scrap-pickup', scrapRoutes);
app.use('/api/providers', providerRoutes);
app.use('/api/payments', paymentRoutes);

// Direct top-level routes for specific modernization patterns
app.use('/scrap-pickup', scrapRoutes);

// Health Check
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    mongodb: mongoose.connection.readyState === 1 ? 'connected' : 'disconnected'
  });
});

// Error Handler
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(err.status || 500).json({
    error: err.message || 'Internal Server Error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
});

// 404 Handler
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 BlinKlean API running on port ${PORT}`);
});

module.exports = app;
