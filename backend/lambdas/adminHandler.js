const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, ScanCommand } = require("@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient({ region: "ap-south-1" });
const ddbDocClient = DynamoDBDocumentClient.from(client);

const USERS_TABLE = process.env.USERS_TABLE || "BlinkleanUsers";
const BOOKINGS_TABLE = process.env.BOOKINGS_TABLE || "BlinkleanBookings";
const SCRAP_TABLE = process.env.SCRAP_TABLE || "BlinkleanScrapPickups";

exports.handler = async (event) => {
  console.log("Event:", JSON.stringify(event));
  
  const { httpMethod, path, requestContext } = event;
  
  // Security Check (Admin Role)
  const groups = requestContext.authorizer?.claims["cognito:groups"] || [];
  if (!groups.includes("Admin")) {
    return {
      statusCode: 403,
      body: JSON.stringify({ error: "Access Denied: High-level administration only." }),
    };
  }

  try {
    // 1. GET SYSTEM STATS (GET /admin/stats)
    if (httpMethod === "GET" && path.includes("/admin/stats")) {
      const usersScan = await ddbDocClient.send(new ScanCommand({ TableName: USERS_TABLE, Select: "COUNT" }));
      const bookingsScan = await ddbDocClient.send(new ScanCommand({ TableName: BOOKINGS_TABLE }));
      
      let totalRevenue = 0;
      bookingsScan.Items?.forEach(b => {
        totalRevenue += (b.pricing?.totalPrice || 0);
      });

      return {
        statusCode: 200,
        headers: { "Access-Control-Allow-Origin": "*" },
        body: JSON.stringify({
          usersCount: usersScan.Count || 0,
          revenue: totalRevenue,
          bookingsCount: bookingsScan.Count || 0,
          activeAlerts: 0, // Placeholder
          servicesCount: 18 // Placeholder from master data
        }),
      };
    }

    // 2. GET USERS LIST (GET /admin/users)
    if (httpMethod === "GET" && path.includes("/admin/users")) {
      const result = await ddbDocClient.send(new ScanCommand({ TableName: USERS_TABLE }));
      return {
        statusCode: 200,
        headers: { "Access-Control-Allow-Origin": "*" },
        body: JSON.stringify({ users: result.Items || [] }),
      };
    }

    // 3. GET PROVIDERS LIST (GET /admin/providers)
    if (httpMethod === "GET" && path.includes("/admin/providers")) {
      const result = await ddbDocClient.send(new ScanCommand({ 
        TableName: USERS_TABLE,
        FilterExpression: "#r = :partner",
        ExpressionAttributeNames: { "#r": "role" },
        ExpressionAttributeValues: { ":partner": "partner" }
      }));
      
      return {
        statusCode: 200,
        headers: { "Access-Control-Allow-Origin": "*" },
        body: JSON.stringify({ providers: result.Items || [] }),
      };
    }

    return {
      statusCode: 404,
      body: JSON.stringify({ error: "Route not found" }),
    };

  } catch (error) {
    console.error("error:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message }),
    };
  }
};
