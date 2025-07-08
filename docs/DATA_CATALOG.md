## 📘 **Data Dictionary for Gold Layer**

### 🔍 **Overview**
The **Gold Layer** is the business-level data representation, structured to support analytical and reporting use cases. It consists of:

- **Dimension Tables**: Provide descriptive context for business processes.
- **Fact Tables**: Store measurable, quantitative data for analysis.

---

### **1. gold.dim_customers**

**Purpose**:  
Stores customer details enriched with demographic and geographic data.

**Table Structure**:

| **Column Name**    | **Data Type**   | **Description**                                                                 |
|--------------------|------------------|---------------------------------------------------------------------------------|
| `customer_key`     | `INT`            | Surrogate key uniquely identifying each customer record in the dimension.      |
| `customer_id`      | `INT`            | Unique numerical identifier assigned to each customer.                         |
| `customer_number`  | `NVARCHAR(50)`   | Alphanumeric identifier used to track the customer.                            |
| `first_name`       | `NVARCHAR(50)`   | Customer’s first name.                                                         |
| `last_name`        | `NVARCHAR(50)`   | Customer’s last name or family name.                                           |
| `country`          | `NVARCHAR(50)`   | Customer’s country of residence.                                               |
| `marital_status`   | `NVARCHAR(50)`   | Customer’s marital status (e.g., 'Single', 'Married').                         |
| `gender`           | `NVARCHAR(50)`   | Customer’s gender (e.g., 'Male', 'Female', 'Unknown').                         |
| `birthdate`        | `DATE`           | Date of birth in `YYYY-MM-DD` format.                                          |
| `create_date`      | `DATE`           | Date the customer record was created in the source system.                     |



### **2. gold.dim_products**

**Purpose**:  
Provides information about products and their related attributes used in sales and inventory tracking.

**Table Structure**:

| **Column Name**           | **Data Type**   | **Description**                                                                 |
|---------------------------|------------------|---------------------------------------------------------------------------------|
| `product_key`             | `INT`            | Surrogate key uniquely identifying each product in the dimension table.        |
| `product_id`              | `INT`            | Unique identifier assigned to the product.                                     |
| `product_number`          | `NVARCHAR(50)`   | Alphanumeric code used to track or categorize the product.                     |
| `product_name`            | `NVARCHAR(50)`   | Descriptive name of the product.                                               |
| `category_id`             | `NVARCHAR(50)`   | Identifier linking the product to its broader category.                        |
| `category`                | `NVARCHAR(50)`   | General classification of the product (e.g., Bikes, Components).              |
| `subcategory`             | `NVARCHAR(50)`   | More specific classification within the category.                              |
| `maintenance_required`    | `NVARCHAR(50)`   | Indicates whether the product requires maintenance (`Yes`, `No`).             |
| `cost`                    | `INT`            | The base cost or price of the product.                                         |
| `product_line`            | `NVARCHAR(50)`   | Series or brand grouping the product belongs to (e.g., Mountain, Road).        |
| `start_date`              | `DATE`           | Date the product became available for sale or use.                             |


### **3. gold.fact_sales**

**Purpose**:  
Stores transactional sales data used for analytics, reporting, and performance tracking across products and customers.

**Table Structure**:

| **Column Name**   | **Data Type**   | **Description**                                                                 |
|-------------------|------------------|---------------------------------------------------------------------------------|
| `order_number`    | `NVARCHAR(50)`   | Unique identifier for each sales order (e.g., `'SO54496'`).                     |
| `product_key`     | `INT`            | Surrogate key (foreign key) linking to the product dimension.                                 |
| `customer_key`    | `INT`            | Surrogate key (foreign key)linking to the customer dimension.                                |
| `order_date`      | `DATE`           | Date when the order was placed.                                                 |
| `shipping_date`   | `DATE`           | Date the order was shipped to the customer.                                     |
| `due_date`        | `DATE`           | Date payment for the order was due.                                             |
| `sales_amount`    | `INT`            | Total value of the sale for the line item (e.g., 25).                           |
| `quantity`        | `INT`            | Number of units ordered (e.g., 1).                                              |
| `price`           | `INT`            | Price per unit of the product (e.g., 25).                                       |
