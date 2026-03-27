const { ddbDocClient } = require('../config/db');
const { 
  GetCommand, 
  PutCommand, 
  UpdateCommand, 
  ScanCommand,
  QueryCommand 
} = require('@aws-sdk/lib-dynamodb');

const SERVICES_TABLE = process.env.DYNAMODB_SERVICES_TABLE || 'BlinkleanServices';

const getAllServices = async (req, res) => {
  try {
    const { category } = req.query;
    
    const params = {
      TableName: SERVICES_TABLE,
      FilterExpression: 'isActive = :a',
      ExpressionAttributeValues: { ':a': true }
    };
    
    if (category) {
      params.FilterExpression += ' AND category = :c';
      params.ExpressionAttributeValues[':c'] = category;
    }

    const { Items: services } = await ddbDocClient.send(new ScanCommand(params));
    
    // Sort manually by order
    const sortedServices = (services || []).sort((a, b) => (a.order || 0) - (b.order || 0));
    
    res.json({ services: sortedServices });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getServiceById = async (req, res) => {
  try {
    const { id } = req.params;
    
    const { Item: service } = await ddbDocClient.send(new GetCommand({
      TableName: SERVICES_TABLE,
      Key: { id }
    }));
    
    if (!service || !service.isActive) {
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
    
    const { Items: services } = await ddbDocClient.send(new ScanCommand({
      TableName: SERVICES_TABLE,
      FilterExpression: 'category = :c AND isActive = :a',
      ExpressionAttributeValues: { ':c': category, ':a': true }
    }));
    
    const sortedServices = (services || []).sort((a, b) => (a.order || 0) - (b.order || 0));
    
    res.json({ services: sortedServices });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getCategories = async (req, res) => {
  try {
    const { Items: allServices } = await ddbDocClient.send(new ScanCommand({
      TableName: SERVICES_TABLE,
      ProjectionExpression: 'category',
      FilterExpression: 'isActive = :a',
      ExpressionAttributeValues: { ':a': true }
    }));
    
    const categories = [...new Set((allServices || []).map(s => s.category))];
    res.json({ categories });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const createService = async (req, res) => {
  try {
    const serviceData = req.body;
    
    await ddbDocClient.send(new PutCommand({
      TableName: SERVICES_TABLE,
      Item: {
        ...serviceData,
        createdAt: new Date().toISOString()
      }
    }));
    
    res.status(201).json({ success: true, service: serviceData });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  getAllServices,
  getServiceById,
  getServicesByCategory,
  getCategories,
  createService
};
