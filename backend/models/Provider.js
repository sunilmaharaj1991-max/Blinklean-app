const mongoose = require('mongoose');

const providerSchema = new mongoose.Schema({
  providerId: {
    type: String,
    required: true,
    unique: true,
    index: true
  },
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    unique: true
  },
  name: {
    type: String,
    required: true,
    trim: true
  },
  phone: {
    type: String,
    required: true,
    unique: true
  },
  email: {
    type: String,
    trim: true,
    lowercase: true
  },
  profileImage: { type: String },
  services: [{
    category: { type: String, required: true },
    serviceIds: [{ type: String }]
  }],
  serviceAreas: [{
    area: String,
    city: String,
    pincode: String,
    isActive: { type: Boolean, default: true }
  }],
  workingHours: {
    start: { type: String, default: '09:00' },
    end: { type: String, default: '18:00' },
    days: [{ type: String, enum: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'] }]
  },
  stats: {
    totalJobs: { type: Number, default: 0 },
    completedJobs: { type: Number, default: 0 },
    cancelledJobs: { type: Number, default: 0 },
    totalEarnings: { type: Number, default: 0 },
    thisMonthEarnings: { type: Number, default: 0 },
    rating: { type: Number, default: 0, min: 0, max: 5 },
    totalRatings: { type: Number, default: 0 }
  },
  status: {
    type: String,
    enum: ['online', 'offline', 'busy', 'suspended'],
    default: 'offline',
    index: true
  },
  isVerified: {
    type: Boolean,
    default: false
  },
  documents: {
    aadhar: { type: String },
    pan: { type: String },
    bankAccount: {
      accountNumber: String,
      ifsc: String,
      holderName: String
    }
  },
  currentLocation: {
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: { type: [Number], default: [0, 0] },
    updatedAt: { type: Date }
  },
  ratings: [{
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    bookingId: { type: mongoose.Schema.Types.ObjectId, ref: 'Booking' },
    stars: { type: Number, required: true, min: 1, max: 5 },
    review: { type: String },
    createdAt: { type: Date, default: Date.now }
  }],
  lastActive: { type: Date },
  joinedAt: { type: Date, default: Date.now }
}, {
  timestamps: true
});

// Indexes
providerSchema.index({ 'currentLocation': '2dsphere' });
providerSchema.index({ 'serviceAreas.pincode': 1 });
providerSchema.index({ 'stats.rating': -1 });
providerSchema.index({ status: 1, 'stats.rating': -1 });

// Generate provider ID
providerSchema.pre('save', function(next) {
  if (!this.providerId) {
    const timestamp = Date.now().toString(36).toUpperCase();
    const random = Math.random().toString(36).substring(2, 5).toUpperCase();
    this.providerId = `PRV${timestamp}${random}`;
  }
  next();
});

providerSchema.set('toJSON', {
  transform: (doc, ret) => {
    delete ret.__v;
    delete ret.documents;
    return ret;
  }
});

module.exports = mongoose.model('Provider', providerSchema);
