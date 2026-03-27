const { ScrapPickup, User, Provider } = require('../models');

const createScrapPickup = async (req, res) => {
  try {
    const pickupData = req.body;
    
    const user = await User.findOne({ amplifyUid: req.user.uid });
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    pickupData.userId = user._id;

    const pickup = new ScrapPickup(pickupData);
    await pickup.save();

    // Update user stats
    user.stats.totalScrapSold += 1;
    await user.save();

    res.status(201).json({
      success: true,
      pickup: pickup.toJSON()
    });
  } catch (error) {
    console.error('Create scrap pickup error:', error);
    res.status(500).json({ error: error.message });
  }
};

const getUserScrapPickups = async (req, res) => {
  try {
    const user = await User.findOne({ amplifyUid: req.user.uid });
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const { status } = req.query;
    const filter = { userId: user._id };
    
    if (status) {
      filter.status = status;
    }

    const pickups = await ScrapPickup.find(filter)
      .sort({ createdAt: -1 });

    res.json({ pickups });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getScrapPickupById = async (req, res) => {
  try {
    const { pickupId } = req.params;
    
    const pickup = await ScrapPickup.findOne({ pickupId })
      .populate('providerId', 'name phone profileImage');

    if (!pickup) {
      return res.status(404).json({ error: 'Pickup not found' });
    }

    res.json({ pickup });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const cancelScrapPickup = async (req, res) => {
  try {
    const { pickupId } = req.params;
    const { reason } = req.body;

    const pickup = await ScrapPickup.findOne({ pickupId });
    if (!pickup) {
      return res.status(404).json({ error: 'Pickup not found' });
    }

    pickup.status = 'cancelled';
    pickup.cancellationReason = reason;
    await pickup.save();

    res.json({ success: true, pickup });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Provider: Get assigned scrap pickups
const getProviderScrapPickups = async (req, res) => {
  try {
    const pickups = await ScrapPickup.find({})
      .populate('userId', 'name phone address')
      .sort({ createdAt: -1 });

    res.json({ pickups });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  createScrapPickup,
  getUserScrapPickups,
  getScrapPickupById,
  cancelScrapPickup,
  getProviderScrapPickups
};
