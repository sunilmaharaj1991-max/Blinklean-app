const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, PutCommand, ScanCommand, UpdateCommand } = require("@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient({ region: "ap-south-1" });
const ddbDocClient = DynamoDBDocumentClient.from(client);

const SCRAP_TABLE = process.env.SCRAP_TABLE || "BlinkleanScrapPickups";

exports.handler = async (event) => {
  console.log("Event:", JSON.stringify(event));
  
  const { httpMethod, path, body, queryStringParameters, requestContext } = event;
  const userId = requestContext.authorizer?.claims?.sub || "guest"; // Cognito Sub ID

  try {
    // 1. CREATE SCRAP PICKUP (POST /scrap-pickup)
    if (httpMethod === "POST" && (path.includes("/scrap-pickup") || path === "/")) {
      const data = typeof body === "string" ? JSON.parse(body) : body;
      const pickupId = `SP-${Date.now()}-${Math.floor(Math.random() * 1000)}`;
      
      const newPickup = {
        ...data,
        pickupId: pickupId,
        userId: userId,
        status: "pending",
        createdAt: new Date().toISOString(),
      };

      await ddbDocClient.send(new PutCommand({
        TableName: SCRAP_TABLE,
        Item: newPickup,
      }));

      // Update User Stats (Async potential, but here sequential for reliability)
      try {
        await ddbDocClient.send(new UpdateCommand({
          TableName: process.env.USERS_TABLE || "BlinkleanUsers",
          Key: { userId: userId },
          UpdateExpression: "SET totalScrapSold = if_not_exists(totalScrapSold, :zero) + :inc",
          ExpressionAttributeValues: { ":inc": 1, ":zero": 0 },
        }));
      } catch (e) {
        console.warn("User stats update failed:", e.message);
      }

      return {
        statusCode: 201,
        headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
        body: JSON.stringify({ success: true, pickupId, pickup: newPickup }),
      };
    }

    // 2. GET USER SCRAP PICKUPS (GET /scrap/me)
    if (httpMethod === "GET" && path.includes("/scrap/me")) {
      const status = queryStringParameters?.status;
      
      const params = {
        TableName: SCRAP_TABLE,
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
        body: JSON.stringify({ pickups: result.Items || [] }),
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
