const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
  bookingId: {
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
  service: {
    serviceId: { type: String, required: true },
    name: { type: String, required: true },
    category: { type: String, required: true },
    icon: { type: String }
  },
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
    time: { type: String, required: true },
    slot: { type: String }
  },
  pricing: {
    basePrice: { type: Number, required: true },
    additionalCharges: { type: Number, default: 0 },
    discount: { type: Number, default: 0 },
    totalPrice: { type: Number, required: true }
  },
  status: {
    type: String,
    enum: ['pending', 'confirmed', 'assigned', 'in_progress', 'completed', 'cancelled'],
    default: 'pending',
    index: true
  },
  payment: {
    method: { type: String, enum: ['online', 'cash', 'pos'], default: 'online' },
    status: { type: String, enum: ['pending', 'paid', 'failed', 'refunded'], default: 'pending' },
    transactionId: { type: String },
    paidAt: { type: Date }
  },
  notes: {
    customer: { type: String },
    provider: { type: String },
    internal: { type: String }
  },
  statusHistory: [{
    status: String,
    timestamp: { type: Date, default: Date.now },
    note: String
  }],
  rating: {
    given: { type: Boolean, default: false },
    stars: { type: Number, min: 1, max: 5 },
    review: { type: String }
  },
  assignedAt: { type: Date },
  startedAt: { type: Date },
  completedAt: { type: Date },
  cancellationReason: { type: String }
}, {
  timestamps: true
});

// Indexes
bookingSchema.index({ 'address.location': '2dsphere' });
bookingSchema.index({ createdAt: -1 });
bookingSchema.index({ 'schedule.date': 1 });
bookingSchema.index({ status: 1, createdAt: -1 });

// Generate booking ID
bookingSchema.pre('save', function(next) {
  if (!this.bookingId) {
    const timestamp = Date.now().toString(36).toUpperCase();
    const random = Math.random().toString(36).substring(2, 6).toUpperCase();
    this.bookingId = `BKN${timestamp}${random}`;
  }
  next();
});

bookingSchema.set('toJSON', {
  transform: (doc, ret) => {
    delete ret.__v;
    return ret;
  }
});

module.exports = mongoose.model('Booking', bookingSchema);
