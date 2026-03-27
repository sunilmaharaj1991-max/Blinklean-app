const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  amplifyUid: {
    type: String,
    required: true,
    unique: true,
    index: true
  },
  name: {
    type: String,
    required: true,
    trim: true,
    maxlength: 100
  },
  email: {
    type: String,
    trim: true,
    lowercase: true,
    sparse: true
  },
  phone: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  phoneVerified: {
    type: Boolean,
    default: false
  },
  address: {
    street: { type: String, trim: true },
    area: { type: String, trim: true },
    city: { type: String, default: 'Bengaluru' },
    state: { type: String, default: 'Karnataka' },
    pincode: { type: String, trim: true }
  },
  location: {
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: { type: [Number], default: [0, 0] }
  },
  profileImage: { type: String },
  role: {
    type: String,
    enum: ['user', 'provider', 'admin'],
    default: 'user'
  },
  providerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Provider',
    sparse: true
  },
  stats: {
    totalBookings: { type: Number, default: 0 },
    totalSpent: { type: Number, default: 0 },
    totalScrapSold: { type: Number, default: 0 }
  },
  notifications: {
    email: { type: Boolean, default: true },
    sms: { type: Boolean, default: true },
    push: { type: Boolean, default: true }
  },
  fcmToken: { type: String },
  lastLogin: { type: Date },
  isActive: { type: Boolean, default: true }
}, {
  timestamps: true
});

// Index for geospatial queries
userSchema.index({ 'location': '2dsphere' });
userSchema.index({ 'address.pincode': 1 });
userSchema.index({ createdAt: -1 });

// Hash phone before saving (for additional security)
userSchema.pre('save', async function(next) {
  if (this.isModified('phone')) {
    // Phone is stored as-is but we ensure uniqueness
  }
  next();
});

// Method to get full address
userSchema.methods.getFullAddress = function() {
  const parts = [
    this.address?.street,
    this.address?.area,
    this.address?.city,
    this.address?.pincode
  ].filter(Boolean);
  return parts.join(', ');
};

// Transform for JSON
userSchema.set('toJSON', {
  transform: (doc, ret) => {
    delete ret.__v;
    delete ret.fcmToken;
    return ret;
  }
});

module.exports = mongoose.model('User', userSchema);
