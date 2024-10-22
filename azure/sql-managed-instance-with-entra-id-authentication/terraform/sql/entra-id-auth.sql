-- entra id authentication
-- login as entra id admin user
-- https://learn.microsoft.com/en-us/azure/azure-sql/database/authentication-aad-guest-users?view=azuresql

-- Step 1: Create an AAD User in the Azure SQL Database
CREATE USER [user@domain.com] FROM EXTERNAL PROVIDER;
-- Verify the user is created
SELECT * FROM sys.database_principals;

-- Step 2: Grant the db_owner or custom Role to the AAD/Entra ID User
ALTER ROLE db_owner ADD MEMBER [user@domain.com];