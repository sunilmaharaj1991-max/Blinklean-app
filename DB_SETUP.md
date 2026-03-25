# Blinklean Database Setup

## Quick Setup Instructions

### 1. Go to Supabase Dashboard
Navigate to your Supabase project at: https://supabase.com/dashboard

### 2. Open SQL Editor
- Click on **SQL Editor** in the left sidebar
- Click **New Query**

### 3. Run the Schema
Copy and paste the contents of `supabase_schema.sql` into the SQL editor and click **Run**

### 4. Verify Setup
After running, you should see success messages for all created tables.

## Tables Created

| Table | Purpose |
|-------|---------|
| `users` | User profiles synced with Firebase Auth |
| `services` | Available cleaning services with prices |
| `bookings` | Service booking records |
| `scrap_prices` | Scrap material price list |
| `scrap_pickups` | Scrap collection requests |
| `scrap_pickup_items` | Items in each scrap pickup |
| `pincode_availability` | Service coverage by pincode |
| `notifications` | User notifications |

## Security (RLS)
Row Level Security is enabled on all tables:
- Users can only access their own data
- Services and prices are publicly readable
- Service role has full access

## Testing Locally
The app has fallback/mock data if the database tables don't exist yet, so you can continue development without the database.

## Need Help?
Check the Supabase docs: https://supabase.com/docs
