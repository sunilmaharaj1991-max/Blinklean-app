const { Provider, User, Booking, ScrapPickup } = require('../models');

// Get provider profile
const getProviderProfile = async (req, res) => {
  try {
    const provider = await Provider.findOne({ userId: req.user?.uid })
      .populate('userId', 'name phone email address');
    
    if (!provider) {
      return res.status(404).json({ error: 'Provider profile not found' });
    }

    res.json({ provider });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get provider by ID
const getProviderById = async (req, res) => {
  try {
    const { providerId } = req.params;
    
    const provider = await Provider.findOne({ providerId })
      .select('-ratings');

    if (!provider) {
      return res.status(404).json({ error: 'Provider not found' });
    }

    res.json({ provider });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update provider status (online/offline)
const updateProviderStatus = async (req, res) => {
  try {
    const { status } = req.body;
    
    const provider = await Provider.findOneAndUpdate(
      { userId: req.user?.uid },
      { status, lastActive: new Date() },
      { new: true }
    );

    if (!provider) {
      return res.status(404).json({ error: 'Provider not found' });
    }

    res.json({ success: true, provider });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get provider's bookings (services + scrap combined)
const getProviderBookings = async (req, res) => {
  try {
    const { status, type, page = 1, limit = 20 } = req.query;
    
    const provider = await Provider.findOne({ userId: req.user?.uid });
    if (!provider) {
      return res.status(404).json({ error: 'Provider not found' });
    }

    const filter = { providerId: provider._id };
    if (status) {
      filter.status = status;
    }

    // Get service bookings
    const serviceBookings = await Booking.find(filter)
      .populate('userId', 'name phone address')
      .select('-statusHistory -notes.internal');

    // Get scrap pickups
    const scrapPickups = await ScrapPickup.find({ providerId: provider._id })
      .populate('userId', 'name phone address')
      .select('-notes.provider');

    // Combine and format
    const combinedBookings = [
      ...serviceBookings.map(b => ({
        _id: b._id,
        type: 'service',
        bookingId: b.bookingId,
        customerName: b.userId?.name,
        customerPhone: b.userId?.phone,
        address: b.address,
        serviceName: b.service?.name,
        serviceCategory: b.service?.category,
        schedule: b.schedule,
        status: b.status,
        price: b.pricing?.totalPrice,
        paymentStatus: b.payment?.status,
        createdAt: b.createdAt
      })),
      ...scrapPickups.map(p => ({
        _id: p._id,
        type: 'scrap',
        bookingId: p.pickupId,
        customerName: p.userId?.name,
        customerPhone: p.userId?.phone,
        address: p.address,
        serviceName: 'Scrap Pickup',
        serviceCategory: 'Scrap & Recycling',
        schedule: p.schedule,
        status: p.status,
        price: p.pricing?.totalPrice,
        paymentStatus: p.payment?.status,
        items: p.items,
        createdAt: p.createdAt
      }))
    ];

    // Sort by date (newest first)
    combinedBookings.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

    // Filter by type if specified
    const filtered = type ? combinedBookings.filter(b => b.type === type) : combinedBookings;

    res.json({
      bookings: filtered,
      stats: {
        total: combinedBookings.length,
        upcoming: combinedBookings.filter(b => ['confirmed', 'assigned'].includes(b.status)).length,
        completed: combinedBookings.filter(b => b.status === 'completed').length,
        earnings: provider.stats.totalEarnings
      }
    });
  } catch (error) {
    console.error('Get provider bookings error:', error);
    res.status(500).json({ error: error.message });
  }
};

// Accept/assign booking to provider
const assignBookingToProvider = async (req, res) => {
  try {
    const { bookingId, type } = req.body;
    
    const provider = await Provider.findOne({ userId: req.user?.uid });
    if (!provider) {
      return res.status(404).json({ error: 'Provider not found' });
    }

    if (type === 'scrap') {
      const pickup = await ScrapPickup.findOneAndUpdate(
        { pickupId: bookingId },
        { providerId: provider._id, status: 'assigned' },
        { new: true }
      );
      return res.json({ success: true, pickup });
    } else {
      const booking = await Booking.findOneAndUpdate(
        { bookingId },
        { providerId: provider._id, status: 'assigned' },
        { new: true }
      );
      return res.json({ success: true, booking });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update booking status
const updateBookingStatus = async (req, res) => {
  try {
    const { bookingId, type, status, notes } = req.body;
    
    let record;
    if (type === 'scrap') {
      record = await ScrapPickup.findOneAndUpdate(
        { pickupId: bookingId },
        { status, 'notes.provider': notes },
        { new: true }
      );
    } else {
      record = await Booking.findOneAndUpdate(
        { bookingId },
        { status, 'notes.provider': notes },
        { new: true }
      );
      
      // Update provider stats
      if (status === 'completed') {
        const provider = await Provider.findById(record.providerId);
        if (provider) {
          provider.stats.completedJobs += 1;
          provider.stats.totalEarnings += record.pricing.totalPrice;
          provider.stats.thisMonthEarnings += record.pricing.totalPrice;
          await provider.save();
        }
      }
    }

    res.json({ success: true, record });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  getProviderProfile,
  getProviderById,
  updateProviderStatus,
  getProviderBookings,
  assignBookingToProvider,
  updateBookingStatus
};
