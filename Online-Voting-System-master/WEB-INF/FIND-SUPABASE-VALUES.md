FINDING SUPABASE CONNECTION VALUES - VISUAL GUIDE
================================================

If you don't have a Supabase project yet, CREATE ONE FIRST:
  1. Go to https://app.supabase.com
  2. Click "Sign up" (use email/Google)
  3. Click "New Project"
  4. Enter:
     - Project Name: "online-voting"
     - Database Password: pick a strong password (WRITE IT DOWN!)
     - Region: pick closest to you
  5. Click "Create new project"
  6. Wait 2-3 minutes for it to be ready

THEN follow steps below to FIND CONNECTION VALUES:

==============================================================================
STEP 1: Go to Supabase Dashboard
==============================================================================

1. Go to https://app.supabase.com
2. Look at the LEFT SIDE of the screen
3. You should see a list of projects
4. Click on your project (e.g., "online-voting")

==============================================================================
STEP 2: Go to Settings
==============================================================================

1. Look at the BOTTOM LEFT corner
2. You should see a gear icon ⚙️ (Settings)
3. Click it

==============================================================================
STEP 3: Click "Database"
==============================================================================

1. In the left menu that opens, look for "Database"
2. Click on it

==============================================================================
STEP 4: Find Connection String
==============================================================================

You should now see a section that says "Connection string" or "Connection info"

Look for a tab or section that says "URI" or shows something like:

    postgresql://postgres:PASSWORD@HOST:5432/postgres

You need to find:
  - Host (the long domain name, e.g., abc123def456.supabase.co)
  - Database name (usually "postgres")
  - User (usually "postgres")
  - Password (what you created when setting up the project)
  - Port (usually 5432)

==============================================================================
STEP 5: Copy the values
==============================================================================

What you're looking for should look like:

    Connection string (URI):
    postgresql://postgres:[PASSWORD]@[HOST]:5432/postgres

BREAK IT DOWN:
  - postgres = USERNAME
  - [PASSWORD] = your DATABASE PASSWORD (the one you created)
  - [HOST] = the domain like "abc123def456.supabase.co"
  - 5432 = PORT (always the same)
  - postgres = DATABASE NAME

Example (fake values):
    postgresql://postgres:MySecure123!@abc123def456.supabase.co:5432/postgres

This means:
  - User: postgres
  - Password: MySecure123!
  - Host: abc123def456.supabase.co
  - Port: 5432
  - Database: postgres

==============================================================================
STEP 6: Put these in web.xml
==============================================================================

Open:
  c:\Users\ADMIN\Downloads\Online-Voting-System-master\Online-Voting-System-master\WEB-INF\web.xml

Find:
  <context-param>
    <param-name>DB_URL</param-name>
    <param-value>jdbc:postgresql://HOST:5432/DBNAME?sslmode=require</param-value>
  </context-param>

  <context-param>
    <param-name>DB_USER</param-name>
    <param-value>DB_USER</param-value>
  </context-param>

  <context-param>
    <param-name>DB_PASS</param-name>
    <param-value>DB_PASSWORD</param-value>
  </context-param>

REPLACE with your values. Example:

 
 

==============================================================================
TROUBLESHOOTING
==============================================================================

Can't find connection string?
  - Make sure you're logged into your Supabase account
  - Make sure you're in the right project (check project name at top)
  - Try refreshing the page
  - Make sure the project is "Active" (green status)

Don't see "postgres" user?
  - It should be default. If not, create a new user:
    1. In Supabase, go to Authentication section
    2. Or click "Users" in left menu
    3. Create a new user or use default "postgres"

Forgot the password?
  - Go to Supabase Settings → Database
  - Look for "Reset database password"
  - Click it and set a new password
  - WRITE IT DOWN!

==============================================================================
STILL STUCK?
==============================================================================

Watch this video (2 min): https://youtu.be/S2bIlTLZSLk
Or check: https://supabase.com/docs/guides/database/connecting-to-postgres

Need help?
  Send me:
    1. A screenshot of where you are on the Supabase website
    2. What you see on the screen
    3. What section/page you're in
  
  And I'll walk you through it step by step.
