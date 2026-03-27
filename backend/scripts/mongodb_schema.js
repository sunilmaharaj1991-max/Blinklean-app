// BlinKlean MongoDB Schema Setup
// Database: BlinkLean
// Run with: mongosh < mongodb_schema.sql.js

// ==================== USERS COLLECTION ====================
db.createCollection("users", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["amplifyUid", "email", "name", "phone"],
      properties: {
        amplifyUid: { bsonType: "string" },
        email: { bsonType: "string" },
        name: { bsonType: "string" },
        phone: { bsonType: "string" },
        address: {
          bsonType: "object",
          properties: {
            street: { bsonType: "string" },
            city: { bsonType: "string" },
            state: { bsonType: "string" },
            pincode: { bsonType: "string" }
          }
        },
        profileImage: { bsonType: "string" },
        role: { bsonType: "string", enum: ["user", "provider", "admin"], default: "user" },
        isActive: { bsonType: "bool", default: true },
        stats: {
          bsonType: "object",
          properties: {
            totalBookings: { bsonType: "int", default: 0 },
            totalSpent: { bsonType: "double", default: 0 },
            totalScrapSold: { bsonType: "int", default: 0 }
          }
        },
        createdAt: { bsonType: "date" },
        updatedAt: { bsonType: "date" }
      }
    }
  }
});

db.users.createIndex({ "amplifyUid": 1 }, { unique: true });
db.users.createIndex({ "email": 1 }, { unique: true });
db.users.createIndex({ "phone": 1 });

// ==================== SERVICES COLLECTION ====================
db.createCollection("services", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["id", "name", "category", "startingPrice"],
      properties: {
        id: { bsonType: "string" },
        name: { bsonType: "string" },
        category: { 
          bsonType: "string", 
          enum: ["Home Cleaning", "Vehicle Care", "Laundry", "Scrap & Recycling"] 
        },
        shortDescription: { bsonType: "string" },
        fullDescription: { bsonType: "string" },
        startingPrice: { bsonType: "number" },
        priceUnit: { bsonType: "string" },
        estimatedDuration: { bsonType: "string" },
        icon: { bsonType: "string" },
        whatsIncluded: { bsonType: "array", items: { bsonType: "string" } },
        customerResponsibilities: { bsonType: "array", items: { bsonType: "string" } },
        howItWorks: {
          bsonType: "array",
          items: {
            bsonType: "object",
            properties: {
              step: { bsonType: "number" },
              title: { bsonType: "string" },
              description: { bsonType: "string" }
            }
          }
        },
        isActive: { bsonType: "bool", default: true },
        order: { bsonType: "number", default: 0 },
        rating: { bsonType: "number", default: 0 },
        totalRatings: { bsonType: "number", default: 0 },
        createdAt: { bsonType: "date" },
        updatedAt: { bsonType: "date" }
      }
    }
  }
});

db.services.createIndex({ "id": 1 }, { unique: true });
db.services.createIndex({ "category": 1 });
db.services.createIndex({ "isActive": 1 });
db.services.createIndex({ "order": 1 });

// ==================== BOOKINGS COLLECTION ====================
db.createCollection("bookings", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["bookingId", "userId", "serviceId", "scheduledDate"],
      properties: {
        bookingId: { bsonType: "string" },
        userId: { bsonType: "objectId" },
        serviceId: { bsonType: "string" },
        providerId: { bsonType: "objectId" },
        status: { 
          bsonType: "string", 
          enum: ["pending", "confirmed", "in_progress", "completed", "cancelled"], 
          default: "pending" 
        },
        address: {
          bsonType: "object",
          properties: {
            street: { bsonType: "string" },
            city: { bsonType: "string" },
            state: { bsonType: "string" },
            pincode: { bsonType: "string" },
            latitude: { bsonType: "number" },
            longitude: { bsonType: "number" }
          }
        },
        scheduledDate: { bsonType: "date" },
        scheduledTime: { bsonType: "string" },
        serviceDetails: {
          bsonType: "object",
          properties: {
            name: { bsonType: "string" },
            price: { bsonType: "number" },
            duration: { bsonType: "string" }
          }
        },
        payment: {
          bsonType: "object",
          properties: {
            method: { bsonType: "string" },
            amount: { bsonType: "number" },
            status: { bsonType: "string" },
            transactionId: { bsonType: "string" },
            razorpayOrderId: { bsonType: "string" }
          }
        },
        rating: {
          bsonType: "object",
          properties: {
            stars: { bsonType: "number" },
            review: { bsonType: "string" },
            createdAt: { bsonType: "date" }
          }
        },
        notes: { bsonType: "string" },
        cancellationReason: { bsonType: "string" },
        createdAt: { bsonType: "date" },
        updatedAt: { bsonType: "date" }
      }
    }
  }
});

db.bookings.createIndex({ "bookingId": 1 }, { unique: true });
db.bookings.createIndex({ "userId": 1 });
db.bookings.createIndex({ "providerId": 1 });
db.bookings.createIndex({ "status": 1 });
db.bookings.createIndex({ "scheduledDate": 1 });

// ==================== PROVIDERS COLLECTION ====================
db.createCollection("providers", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["amplifyUid", "name", "phone"],
      properties: {
        amplifyUid: { bsonType: "string" },
        name: { bsonType: "string" },
        phone: { bsonType: "string" },
        email: { bsonType: "string" },
        profileImage: { bsonType: "string" },
        services: { bsonType: "array", items: { bsonType: "string" } },
        categories: { bsonType: "array", items: { bsonType: "string" } },
        status: { bsonType: "string", enum: ["offline", "online", "busy"], default: "offline" },
        location: {
          bsonType: "object",
          properties: {
            type: { bsonType: "string", default: "Point" },
            coordinates: { bsonType: "array", items: { bsonType: "number" } }
          }
        },
        serviceArea: {
          bsonType: "array",
          items: { bsonType: "string" }
        },
        rating: { bsonType: "number", default: 0 },
        totalRatings: { bsonType: "number", default: 0 },
        stats: {
          bsonType: "object",
          properties: {
            totalJobs: { bsonType: "int", default: 0 },
            completedJobs: { bsonType: "int", default: 0 },
            totalEarnings: { bsonType: "double", default: 0 }
          }
        },
        isVerified: { bsonType: "bool", default: false },
        documents: {
          bsonType: "array",
          items: {
            bsonType: "object",
            properties: {
              type: { bsonType: "string" },
              url: { bsonType: "string" },
              verified: { bsonType: "bool" }
            }
          }
        },
        createdAt: { bsonType: "date" },
        updatedAt: { bsonType: "date" }
      }
    }
  }
});

db.providers.createIndex({ "amplifyUid": 1 }, { unique: true });
db.providers.createIndex({ "services": 1 });
db.providers.createIndex({ "status": 1 });
db.providers.createIndex({ "location": "2dsphere" });

// ==================== SCRAP_PICKUPS COLLECTION ====================
db.createCollection("scrap_pickups", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["pickupId", "userId", "items", "address"],
      properties: {
        pickupId: { bsonType: "string" },
        userId: { bsonType: "objectId" },
        providerId: { bsonType: "objectId" },
        items: {
          bsonType: "array",
          items: {
            bsonType: "object",
            properties: {
              category: { bsonType: "string" },
              weight: { bsonType: "number" }
            }
          }
        },
        totalWeight: { bsonType: "number" },
        status: { 
          bsonType: "string", 
          enum: ["pending", "confirmed", "assigned", "picked_up", "completed", "cancelled"], 
          default: "pending" 
        },
        address: {
          bsonType: "object",
          properties: {
            name: { bsonType: "string" },
            phone: { bsonType: "string" },
            street: { bsonType: "string" },
            city: { bsonType: "string" },
            state: { bsonType: "string" },
            pincode: { bsonType: "string" }
          }
        },
        scheduledDate: { bsonType: "date" },
        actualPickupDate: { bsonType: "date" },
        pricing: {
          bsonType: "object",
          properties: {
            totalWeight: { bsonType: "number" },
            marketRateBased: { bsonType: "bool" }
          }
        },
        cancellationReason: { bsonType: "string" },
        notes: { bsonType: "string" },
        createdAt: { bsonType: "date" },
        updatedAt: { bsonType: "date" }
      }
    }
  }
});

db.scrap_pickups.createIndex({ "pickupId": 1 }, { unique: true });
db.scrap_pickups.createIndex({ "userId": 1 });
db.scrap_pickups.createIndex({ "providerId": 1 });
db.scrap_pickups.createIndex({ "status": 1 });

// ==================== NOTIFICATIONS COLLECTION ====================
db.createCollection("notifications", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["userId", "title", "body"],
      properties: {
        userId: { bsonType: "objectId" },
        title: { bsonType: "string" },
        body: { bsonType: "string" },
        type: { 
          bsonType: "string", 
          enum: ["booking", "payment", "promotion", "reminder", "system"] 
        },
        data: { bsonType: "object" },
        isRead: { bsonType: "bool", default: false },
        createdAt: { bsonType: "date" }
      }
    }
  }
});

db.notifications.createIndex({ "userId": 1 });
db.notifications.createIndex({ "isRead": 1 });
db.notifications.createIndex({ "createdAt": -1 });

// ==================== PINCODE_AVAILABILITY COLLECTION ====================
db.createCollection("pincode_availability", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["pincode", "city"],
      properties: {
        pincode: { bsonType: "string" },
        city: { bsonType: "string" },
        state: { bsonType: "string", default: "Karnataka" },
        available: { bsonType: "bool", default: true },
        deliveryAvailable: { bsonType: "bool", default: true },
        createdAt: { bsonType: "date" },
        updatedAt: { bsonType: "date" }
      }
    }
  }
});

db.pincode_availability.createIndex({ "pincode": 1 }, { unique: true });
db.pincode_availability.createIndex({ "city": 1 });
db.pincode_availability.createIndex({ "available": 1 });

// ==================== SEED DATA ====================
print("\n🌱 Seeding data...");

// Seed Services
print("📦 Seeding services...");
db.services.insertMany([
  { id: "svc_001", name: "Deep Cleaning", category: "Home Cleaning", shortDescription: "Thorough deep cleaning for your entire home", fullDescription: "Professional deep cleaning service that covers all rooms, corners, and hard-to-reach areas.", startingPrice: 999, estimatedDuration: "3 hours", icon: "cleaning_services", isActive: true, order: 1, rating: 4.8, totalRatings: 156 },
  { id: "svc_002", name: "Regular Cleaning", category: "Home Cleaning", shortDescription: "Regular maintenance cleaning", fullDescription: "Regular cleaning service for maintaining a tidy home.", startingPrice: 499, estimatedDuration: "1.5 hours", icon: "home", isActive: true, order: 2, rating: 4.6, totalRatings: 234 },
  { id: "svc_003", name: "Bedroom Cleaning", category: "Home Cleaning", shortDescription: "Professional bedroom cleaning", fullDescription: "Deep cleaning for your bedroom including dusting, vacuuming, and bed making.", startingPrice: 349, estimatedDuration: "1 hour", icon: "bed", isActive: true, order: 3, rating: 4.5, totalRatings: 89 },
  { id: "svc_004", name: "Kitchen Cleaning", category: "Home Cleaning", shortDescription: "Deep kitchen cleaning service", fullDescription: "Thorough kitchen cleaning including appliances, cabinets, and surfaces.", startingPrice: 449, estimatedDuration: "1.5 hours", icon: "kitchen", isActive: true, order: 4, rating: 4.7, totalRatings: 123 },
  { id: "svc_005", name: "Bathroom Cleaning", category: "Home Cleaning", shortDescription: "Hygienic bathroom cleaning", fullDescription: "Professional bathroom sanitization and cleaning.", startingPrice: 299, estimatedDuration: "45 mins", icon: "bathtub", isActive: true, order: 5, rating: 4.4, totalRatings: 78 },
  { id: "svc_006", name: "Sofa Cleaning", category: "Home Cleaning", shortDescription: "Professional sofa cleaning", fullDescription: "Deep cleaning for all types of sofas and upholstered furniture.", startingPrice: 599, estimatedDuration: "1 hour", icon: "chair", isActive: true, order: 6, rating: 4.6, totalRatings: 145 },
  { id: "svc_007", name: "Carpet Cleaning", category: "Home Cleaning", shortDescription: "Deep carpet cleaning", fullDescription: "Professional carpet shampooing and stain removal.", startingPrice: 799, estimatedDuration: "1.5 hours", icon: "texture", isActive: true, order: 7, rating: 4.5, totalRatings: 67 },
  { id: "svc_008", name: "Window Cleaning", category: "Home Cleaning", shortDescription: "Interior window cleaning", fullDescription: "Cleaning of all interior windows and glass surfaces.", startingPrice: 249, estimatedDuration: "45 mins", icon: "window", isActive: true, order: 8, rating: 4.3, totalRatings: 45 },
  { id: "svc_009", name: "Electrician", category: "Vehicle Care", shortDescription: "Professional electrician service", fullDescription: "Expert electrical repairs and installations.", startingPrice: 199, estimatedDuration: "1 hour", icon: "electrical_services", isActive: true, order: 9, rating: 4.7, totalRatings: 189 },
  { id: "svc_010", name: "Plumber", category: "Vehicle Care", shortDescription: "Expert plumbing services", fullDescription: "Professional plumbing repairs and installations.", startingPrice: 199, estimatedDuration: "1 hour", icon: "plumbing", isActive: true, order: 10, rating: 4.6, totalRatings: 167 },
  { id: "svc_011", name: "AC Service", category: "Vehicle Care", shortDescription: "AC servicing and repair", fullDescription: "Complete AC servicing, gas top-up, and repairs.", startingPrice: 449, estimatedDuration: "1.5 hours", icon: "ac_unit", isActive: true, order: 11, rating: 4.8, totalRatings: 201 },
  { id: "svc_012", name: "Pest Control", category: "Scrap & Recycling", shortDescription: "Complete pest control treatment", fullDescription: "Professional pest control for bugs, rodents, and insects.", startingPrice: 999, estimatedDuration: "2 hours", icon: "pest_control", isActive: true, order: 12, rating: 4.5, totalRatings: 98 }
]);

// Seed Pincodes
print("📍 Seeding pincode availability...");
db.pincode_availability.insertMany([
  { pincode: "560001", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560002", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560003", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560004", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560005", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560006", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560007", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560008", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560009", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560010", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560011", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560012", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560016", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560017", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560025", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560034", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560037", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560043", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560048", city: "Bangalore", state: "Karnataka", available: true },
  { pincode: "560095", city: "Bangalore", state: "Karnataka", available: true }
]);

// ==================== SUMMARY ====================
print("\n✅ MongoDB schema setup complete!");
print("📊 Collections created:");
db.getCollectionNames().forEach(function(collection) {
  var count = db.getCollection(collection).countDocuments();
  print("  - " + collection + ": " + count + " documents");
});
