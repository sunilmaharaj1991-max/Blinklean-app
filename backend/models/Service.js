const mongoose = require('mongoose');

const serviceSchema = new mongoose.Schema({
  id: {
    type: String,
    required: true,
    unique: true
  },
  name: {
    type: String,
    required: true
  },
  category: {
    type: String,
    required: true,
    enum: ['Home Cleaning', 'Vehicle Care', 'Laundry', 'Scrap & Recycling']
  },
  icon: {
    type: String,
    default: 'cleaning_services'
  },
  shortDescription: {
    type: String,
    required: true
  },
  fullDescription: {
    type: String,
    required: true
  },
  startingPrice: {
    type: Number,
    required: true
  },
  priceUnit: {
    type: String,
    default: ''
  },
  estimatedDuration: {
    type: String,
    required: true
  },
  whatsIncluded: [{
    type: String
  }],
  customerResponsibilities: [{
    type: String
  }],
  howItWorks: [{
    step: Number,
    title: String,
    description: String
  }],
  isActive: {
    type: Boolean,
    default: true
  },
  order: {
    type: Number,
    default: 0
  }
}, {
  timestamps: true
});

serviceSchema.set('toJSON', {
  transform: (doc, ret) => {
    delete ret.__v;
    return ret;
  }
});

module.exports = mongoose.model('Service', serviceSchema);
