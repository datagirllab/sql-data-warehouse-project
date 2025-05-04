/*
 Script Purpose:
    This script creates a new database called 'data_warehouse'. 
    If the database already exists, it will be dropped and recreated. 
    It also sets up three schemas — bronze, silver, and gold within the 'data_warehouse' database.

WARNING:
    This script is designed for local development or portfolio demos only. 
    Running this will permanently delete the 'data_warehouse' database if it already exists. 
    Use only in development/testing environments.Always ensure you back up important data before running this script.
	*/

USE master;
GO

-- Drop and recreate the 'data_warehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'data_warehouse')
BEGIN
    ALTER DATABASE data_warehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE data_warehouse;
	PRINT 'Database dropped successfully.';
END;
ELSE
BEGIN
    PRINT 'Database does not exist.';
END;
GO

-- Create the data_warehouse database
CREATE DATABASE data_warehouse;

USE data_warehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO



