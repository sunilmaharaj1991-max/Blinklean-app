const { User } = require('../models');

const syncFirebaseUser = async (req, res) => {
  try {
    const { uid, name, email, phone } = req.body;
    
    if (!uid) {
      return res.status(400).json({ error: 'Firebase UID is required' });
    }

    // Check if user exists
    let user = await User.findOne({ firebaseUid: uid });
    
    if (user) {
      // Update existing user
      if (name) user.name = name;
      if (email) user.email = email;
      if (phone) user.phone = phone;
      user.lastLogin = new Date();
      await user.save();
    } else {
      // Create new user
      user = new User({
        firebaseUid: uid,
        name: name || 'User',
        email: email || '',
        phone: phone || '',
        phoneVerified: phone ? true : false
      });
      await user.save();
    }

    res.json({
      success: true,
      user: user.toJSON()
    });
  } catch (error) {
    console.error('Sync user error:', error);
    res.status(500).json({ error: error.message });
  }
};

const getCurrentUser = async (req, res) => {
  try {
    const user = await User.findOne({ firebaseUid: req.user.uid });
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({ user: user.toJSON() });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateUser = async (req, res) => {
  try {
    const updates = req.body;
    const allowedUpdates = ['name', 'email', 'address', 'notifications', 'fcmToken'];
    const updateData = {};

    for (const key of allowedUpdates) {
      if (updates[key] !== undefined) {
        updateData[key] = updates[key];
      }
    }

    const user = await User.findOneAndUpdate(
      { firebaseUid: req.user.uid },
      updateData,
      { new: true }
    );

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({ success: true, user: user.toJSON() });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateAddress = async (req, res) => {
  try {
    const { address } = req.body;
    
    const user = await User.findOneAndUpdate(
      { firebaseUid: req.user.uid },
      { address },
      { new: true }
    );

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({ success: true, user: user.toJSON() });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getUserStats = async (req, res) => {
  try {
    const user = await User.findOne({ firebaseUid: req.user.uid });
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({ stats: user.stats });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  syncFirebaseUser,
  getCurrentUser,
  updateUser,
  updateAddress,
  getUserStats
};
