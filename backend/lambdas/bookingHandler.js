const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, PutCommand, QueryCommand, ScanCommand } = require("@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient({ region: "ap-south-1" });
const ddbDocClient = DynamoDBDocumentClient.from(client);

const BOOKINGS_TABLE = process.env.BOOKINGS_TABLE || "BlinkleanBookings";

exports.handler = async (event) => {
  console.log("Event:", JSON.stringify(event));
  
  const { httpMethod, path, body, queryStringParameters, requestContext } = event;
  const userId = requestContext.authorizer?.claims?.sub || "guest"; // Cognito Sub ID

  try {
    // 1. CREATE BOOKING (POST /booking/create)
    if (httpMethod === "POST" && path.includes("/booking/create")) {
      const data = JSON.parse(body);
      const bookingId = `BK-${Date.now()}-${Math.floor(Math.random() * 1000)}`;
      
      const newBooking = {
        ...data,
        bookingId: bookingId,
        userId: userId,
        status: "confirmed",
        createdAt: new Date().toISOString(),
      };

      await ddbDocClient.send(new PutCommand({
        TableName: BOOKINGS_TABLE,
        Item: newBooking,
      }));

      return {
        statusCode: 201,
        headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
        body: JSON.stringify({ success: true, booking: newBooking }),
      };
    }

    // 2. GET USER BOOKINGS (GET /bookings/me)
    if (httpMethod === "GET" && path.includes("/bookings/me")) {
      const status = queryStringParameters?.status;
      
      // Use Query if we have a userId GSI, otherwise Scan (Query is preferred)
      const params = {
        TableName: BOOKINGS_TABLE,
        FilterExpression: "userId = :uid",
        ExpressionAttributeValues: { ":uid": userId },
      };

      if (status && status !== "null") {
        params.FilterExpression += " AND #s = :status";
        params.ExpressionAttributeNames = { "#s": "status" };
        params.ExpressionAttributeValues[":status"] = status;
      }

      const result = await ddbDocClient.send(new ScanCommand(params));

      return {
        statusCode: 200,
        headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
        body: JSON.stringify({ bookings: result.Items || [] }),
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
