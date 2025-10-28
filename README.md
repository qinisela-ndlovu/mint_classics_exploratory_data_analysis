# mint_classics_exploratory_data_analysis using SQL
 In this project I'm a data analyst for fictional Mint Company - my role is to help analyse data in a relational database with the goal of supporting inventory-related business decisions that lead to the closure of a storage facility.
 # Project Scenario
 Mint Classics Company, a retailer of classic model cars and other vehicles, is looking at closing one of their storage facilities. 

To support a data-based business decision, they are looking for suggestions and recommendations for reorganizing or reducing inventory, while still maintaining timely service to their customers. For example, they would like to be able to ship a product to a customer within 24 hours of the order being placed.

As a data analyst, you have been asked to use MySQL Workbench to familiarize yourself with the general business by examining the current data. You will be provided with a data model and sample data tables to review. You will then need to isolate and identify those parts of the data that could be useful in deciding how to reduce inventory.
# Tools & Technologies
- Databse: Mysql(Classic Model Cars Dataset)
- Tool: Mysql workbench
- Language: SQL
# Invetory Distribution
- Total unique products: 110
- Each product is stored exclusively in a single warehouse
- Producvt exclusively breakdown:
- Warehouse A (North): 25
- Warehouse B (East): 38
- Warehouse C (West): 24
- Warehouse D (South): 23
  # Insights: Closing any warehouse means relocating all its exclusive products.

# Product Sales & Revenue
- Top selling product: 1992 Ferrari 360 spider red
- Price vs Sales correlation: I found 0.007 >> No strong linear relationship between prics and quantity sold.
- Low selling product by warehouse, < 1000 units sold
- Warehouse:
- B(east) = 13
- C(west) = 7
- A(North) = 4
- D(south) = 4
  # Insights: Despite some low-sellers in B, its overall performance is strong.

  # Revenue($) & Capacity Comparison
  - Warehouse A: 2,076,063.66 -- 72%
  - Warehouse B: 3,853,922.49 -- 67%
  - Warehouse C:  1,797,559.63 -- 50%
  - Warehouse D: 1,876,644.83  -- 75%
 
  # ✅ Recommendation
  - Close Warehouse C (West):
  - Why:
  - Lowest storage utilization (50%)
  - Lowest revenue and sales volume
  - Moderate product count (24)
  - Opportunity to relocate products to A or D with better performance
 
    # How to Run the Project

1. Import Database
   - Use the `mintclassicsDB.sql` script to import the Classic Model Cars database into MySQL Workbench.

2. Run SQL Analysis
   - Execute the analysis SQL file provided in this repo (`Mint Classics Exploratory Data Analysis.sql`).
   - Review and interpret the output for business insights.




  
  

  


 




 
