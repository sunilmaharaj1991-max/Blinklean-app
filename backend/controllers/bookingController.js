const { Booking, User, Provider } = require('../models');

const createBooking = async (req, res) => {
  try {
    const bookingData = req.body;
    
    // Get user from Firebase UID
    const user = await User.findOne({ amplifyUid: req.user.uid });
    if (!user) {
      return res.status(404).json({ error: 'User not found. Please sync your profile first.' });
    }

    bookingData.userId = user._id;
    
    const booking = new Booking(bookingData);
    await booking.save();

    // Update user stats
    user.stats.totalBookings += 1;
    user.stats.totalSpent += booking.pricing.totalPrice;
    await user.save();

    res.status(201).json({
      success: true,
      booking: booking.toJSON()
    });
  } catch (error) {
    console.error('Create booking error:', error);
    res.status(500).json({ error: error.message });
  }
};

const getUserBookings = async (req, res) => {
  try {
    const user = await User.findOne({ amplifyUid: req.user.uid });
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const { status, page = 1, limit = 20 } = req.query;
    const filter = { userId: user._id };
    
    if (status) {
      filter.status = status;
    }

    const bookings = await Booking.find(filter)
      .sort({ createdAt: -1 })
      .skip((page - 1) * limit)
      .limit(parseInt(limit));

    const total = await Booking.countDocuments(filter);

    res.json({
      bookings,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getBookingById = async (req, res) => {
  try {
    const { bookingId } = req.params;
    
    const booking = await Booking.findOne({ bookingId })
      .populate('providerId', 'name phone profileImage stats.rating');

    if (!booking) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    res.json({ booking });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const cancelBooking = async (req, res) => {
  try {
    const { bookingId } = req.params;
    const { reason } = req.body;

    const booking = await Booking.findOne({ bookingId });
    if (!booking) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    booking.status = 'cancelled';
    booking.cancellationReason = reason;
    booking.statusHistory.push({
      status: 'cancelled',
      timestamp: new Date(),
      note: reason
    });
    
    await booking.save();

    res.json({ success: true, booking });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const rateBooking = async (req, res) => {
  try {
    const { bookingId } = req.params;
    const { stars, review } = req.body;

    const booking = await Booking.findOne({ bookingId });
    if (!booking) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    booking.rating = {
      given: true,
      stars,
      review
    };
    
    await booking.save();

    // Update provider rating
    if (booking.providerId) {
      const provider = await Provider.findById(booking.providerId);
      if (provider) {
        const totalRating = provider.stats.rating * provider.stats.totalRatings + stars;
        provider.stats.totalRatings += 1;
        provider.stats.rating = totalRating / provider.stats.totalRatings;
        provider.ratings.push({
          userId: booking.userId,
          bookingId: booking._id,
          stars,
          review
        });
        await provider.save();
      }
    }

    res.json({ success: true, booking });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Provider: Get assigned bookings
const getProviderBookings = async (req, res) => {
  try {
    const { status, type = 'all', page = 1, limit = 20 } = req.query;
    
    // This would filter by provider ID from JWT
    const filter = {};
    
    if (status) {
      filter.status = status;
    }

    const bookings = await Booking.find(filter)
      .populate('userId', 'name phone address')
      .sort({ 'schedule.date': 1, 'schedule.time': 1 })
      .skip((page - 1) * limit)
      .limit(parseInt(limit));

    const total = await Booking.countDocuments(filter);

    res.json({
      bookings,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  createBooking,
  getUserBookings,
  getBookingById,
  cancelBooking,
  rateBooking,
  getProviderBookings
};
