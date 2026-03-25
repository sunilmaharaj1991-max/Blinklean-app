const mongoose = require('mongoose');

const scrapItemSchema = new mongoose.Schema({
  category: {
    type: String,
    required: true,
    enum: ['Paper', 'Plastic', 'Metal', 'E-Waste', 'Cardboard', 'Glass', 'Other']
  },
  weight: {
    type: Number,
    required: true,
    min: 0
  },
  pricePerKg: {
    type: Number,
    default: 0
  },
  estimatedPrice: {
    type: Number,
    default: 0
  }
});

const scrapPickupSchema = new mongoose.Schema({
  pickupId: {
    type: String,
    required: true,
    unique: true,
    index: true
  },
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  providerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Provider',
    index: true
  },
  items: [scrapItemSchema],
  address: {
    street: { type: String, required: true },
    area: { type: String, required: true },
    city: { type: String, default: 'Bengaluru' },
    pincode: { type: String },
    location: {
      type: { type: String, enum: ['Point'], default: 'Point' },
      coordinates: { type: [Number], default: [0, 0] }
    }
  },
  schedule: {
    date: { type: String, required: true },
    time: { type: String, required: true }
  },
  pricing: {
    totalWeight: { type: Number, default: 0 },
    totalPrice: { type: Number, default: 0 },
    marketRateBased: { type: Boolean, default: true }
  },
  status: {
    type: String,
    enum: ['pending', 'confirmed', 'assigned', 'in_transit', 'picked_up', 'completed', 'cancelled'],
    default: 'pending',
    index: true
  },
  payment: {
    method: { type: String, enum: ['online', 'cash', 'bank_transfer'], default: 'cash' },
    status: { type: String, enum: ['pending', 'paid'], default: 'pending' },
    paidAt: { type: Date }
  },
  notes: {
    customer: { type: String },
    provider: { type: String }
  },
  photos: [{
    url: String,
    uploadedAt: { type: Date, default: Date.now }
  }],
  confirmedAt: { type: Date },
  pickedUpAt: { type: Date },
  completedAt: { type: Date },
  cancellationReason: { type: String }
}, {
  timestamps: true
});

// Indexes
scrapPickupSchema.index({ 'address.location': '2dsphere' });
scrapPickupSchema.index({ createdAt: -1 });

// Generate pickup ID
scrapPickupSchema.pre('save', function(next) {
  if (!this.pickupId) {
    const timestamp = Date.now().toString(36).toUpperCase();
    const random = Math.random().toString(36).substring(2, 6).toUpperCase();
    this.pickupId = `SCR${timestamp}${random}`;
  }
  next();
});

scrapPickupSchema.set('toJSON', {
  transform: (doc, ret) => {
    delete ret.__v;
    return ret;
  }
});

module.exports = mongoose.model('ScrapPickup', scrapPickupSchema);
