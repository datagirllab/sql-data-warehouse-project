/*
  Script Purpose:
  This script creates a new database called 'data_warehouse'.
  It also sets up three schemas — bronze, silver, and gold — within the 'data_warehouse' database.
*/

USE master;

-- Create the data_warehouse database
CREATE DATABASE data_warehouse;

USE data_warehouse;

-- Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
