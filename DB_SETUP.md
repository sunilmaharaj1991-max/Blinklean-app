# BlinKlean AWS Database Setup (DynamoDB)

We use **Amazon DynamoDB** as our primary persistence layer in the `ap-south-1` (Mumbai) region. This provides high-speed, scalable data storage compatible with our AWS-native architecture.

## 1. Tables Overview

| Table Name | Partition Key (Hashed) | Sort Key (Range) | Purpose |
| :--- | :--- | :--- | :--- |
| `BlinkleanBookings` | `bookingId` (String) | `None` | Stores cleaning service registrations |
| `BlinkleanScrapPickups` | `pickupId` (String) | `None` | Stores scrap collection requests |
| `BlinkleanUsers` | `userId` (String) | `None` | Stores extended user profiles (Last Login, Stats) |

## 2. Global Secondary Indexes (GSIs)

To enable fast queries by user (e.g., "My Bookings"), create the following GSIs:

**Table: `BlinkleanBookings`**

- Index Name: `UserIndex`
- Partition Key: `userId` (String)
- Attribute Projections: `ALL`

**Table: `BlinkleanScrapPickups`**

- Index Name: `UserIndex`
- Partition Key: `userId` (String)
- Attribute Projections: `ALL`

## 3. Deployment Steps

1. IAM Role: Ensure your Lambda functions have `AmazonDynamoDBFullAccess` (or least-privilege `GetItem`, `PutItem`, `UpdateItem`, `Query`).
2. Environment Variables: In your Lambda configuration, set:
   - `BOOKINGS_TABLE`: `BlinkleanBookings`
   - `SCRAP_TABLE`: `BlinkleanScrapPickups`
3. API Gateway: Create a **REST API** with a **Cognito Authorizer** to protect the routes.

## Need Help?

Check the AWS DynamoDB docs: [DynamoDB Developer Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html)
