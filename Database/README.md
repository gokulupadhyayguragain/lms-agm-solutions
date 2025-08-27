# Database Setup Instructions

## Files Overview

1. **00_CreateDatabase.sql** - Creates the AGMSolutions database
2. **01_Schema_And_SampleData.sql** - Complete database schema with sample data
3. **02_BasicData.sql** - Additional basic data setup
4. **03_QuizAttempts.sql** - Quiz attempts table and data

## Setup Steps

### Step 1: Create Database
```sql
-- Run this first to create the database
-- File: 00_CreateDatabase.sql
```

### Step 2: Create Schema and Sample Data
```sql
-- Run this to create all tables and insert sample data
-- File: 01_Schema_And_SampleData.sql
```

### Step 3: Basic Data (Optional)
```sql
-- Run this for additional basic data if needed
-- File: 02_BasicData.sql
```

### Step 4: Quiz Attempts (Optional)
```sql
-- Run this if you need quiz functionality
-- File: 03_QuizAttempts.sql
```

## Demo Accounts

After running the setup scripts, these demo accounts will be available:

- **Admin**: demo.admin@agm.com / demo123
- **Lecturer**: demo.lecturer@agm.com / demo123  
- **Student**: demo.student@agm.com / demo123

## Connection String

Update your Web.config with the appropriate connection string:

```xml
<connectionStrings>
    <add name="DefaultConnection" 
         connectionString="Server=.\SQLEXPRESS;Database=AGMSolutions;Integrated Security=true;" 
         providerName="System.Data.SqlClient" />
</connectionStrings>
```
