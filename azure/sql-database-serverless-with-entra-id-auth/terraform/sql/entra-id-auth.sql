-- entra id authentication
-- login as entra id admin user

-- Step 1: Create an AAD User in the Azure SQL Database
CREATE USER [user@domain.com] FROM EXTERNAL PROVIDER;

-- Step 2: Grant the db_owner or custom Role to the AAD/Entra ID User
ALTER ROLE db_owner ADD MEMBER [user@domain.com];