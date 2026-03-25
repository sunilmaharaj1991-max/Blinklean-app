const { Service } = require('../models');

const getAllServices = async (req, res) => {
  try {
    const { category } = req.query;
    const filter = { isActive: true };
    
    if (category) {
      filter.category = category;
    }

    const services = await Service.find(filter).sort({ order: 1, createdAt: 1 });
    
    res.json({ services });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getServiceById = async (req, res) => {
  try {
    const { id } = req.params;
    const service = await Service.findOne({ id, isActive: true });
    
    if (!service) {
      return res.status(404).json({ error: 'Service not found' });
    }

    res.json({ service });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getServicesByCategory = async (req, res) => {
  try {
    const { category } = req.params;
    const services = await Service.find({ category, isActive: true }).sort({ order: 1 });
    
    res.json({ services });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getCategories = async (req, res) => {
  try {
    const categories = await Service.distinct('category', { isActive: true });
    res.json({ categories });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Admin: Create/Update services
const createService = async (req, res) => {
  try {
    const serviceData = req.body;
    const service = new Service(serviceData);
    await service.save();
    res.status(201).json({ success: true, service });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateService = async (req, res) => {
  try {
    const { id } = req.params;
    const updates = req.body;
    
    const service = await Service.findOneAndUpdate(
      { id },
      updates,
      { new: true }
    );

    if (!service) {
      return res.status(404).json({ error: 'Service not found' });
    }

    res.json({ success: true, service });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  getAllServices,
  getServiceById,
  getServicesByCategory,
  getCategories,
  createService,
  updateService
};
