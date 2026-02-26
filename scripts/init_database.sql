/*
==============================================================

Create Database and respective schemas

==============================================================

Script Purpose: 
    The purpose of this scripts is to check whether a database named 'DataWarekouse' already exists in the system databases.
    If it exists, then it is dropped completely and recreated with the same database name.
    After the dcreation, three schemas are created in the database: 'bronze', 'silver' and 'gold'.

WARNING:
    Make sure to backup any important data in the 'DataWarehouse' database before running this script.
    This script will permanently drop the entire database and all the data it contains.
    Proceed with atmost caution and ensure proper data backup before executing this script.

*/


USE master;
GO

-- Drop and recreate the 'DataWarehouse' database if it already exists

IF EXISTS (SELECT 1 
           FROM sys.databases 
           WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse 
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE DataWarehouse;
END
GO

-- Create a brand new Database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO


-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO