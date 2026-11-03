Duka Smart Electronics — Retail Analytics SQL Project
Project Overview
This project uses PostgreSQL to analyze sales and customer data for Duka Smart Electronics, a Kenyan electronics retailer.
The goal is to use SQL to explore customer purchasing behaviour, product performance, revenue trends, order statuses, and other business questions that can support decision-making.
Dataset
The database contains two main tables:
•	Customers: 150 customer records.
•	Orders: 800 order records.
The database used for the project is retail_analytics.
Tools and Technologies
•	PostgreSQL
•	DBeaver
•	SQL
Project Objectives
The project explores how SQL can be used to:
•	Retrieve and filter data.
•	Aggregate sales and customer information.
•	Join related tables.
•	Use subqueries and Common Table Expressions (CTEs).
•	Apply window functions to analyze rankings and trends.
•	Create a database view.
•	Develop a PostgreSQL function.
•	Produce business insights and recommendations.
Project Files
•	README.md — Project overview, objectives, tools, and instructions.
•	schema.sql — SQL statements describing the database tables.
•	queries.sql — SQL queries developed for the assignment.
•	insights.md — Business insights, recommendations, and project limitations.
•	screenshots/ — Screenshots showing relevant SQL queries and their results.
How to Run the Project
1.	Install PostgreSQL and open DBeaver.
2.	Connect to the PostgreSQL database.
3.	Create or select the retail_analytics database.
4.	Run schema.sql if the tables need to be recreated.
5.	Load the provided customer and order data if the tables are empty.
6.	Open queries.sql and execute the queries.
7.	Review insights.md for the business analysis and recommendations.
Note: Do not recreate the tables over existing project data unless you have a backup. The schema file may need to be run in a clean database.
Business Value
The analysis is intended to help management understand customer spending, identify products and categories that perform well, monitor monthly revenue, and examine order statuses.
Recommendations should be based on verified query results. Profitability analysis requires reliable product cost data in addition to sales revenue.
Limitations
•	The quality of the results depends on the accuracy and completeness of the supplied data.
•	Revenue calculations depend on the pricing, quantity, discount, and order-status rules used in the queries.
•	Revenue should not be treated as profit without reliable cost information.
•	The dataset may not explain the reasons behind customer purchasing patterns or changes in sales.
Conclusion
This project demonstrates the use of PostgreSQL for retail data analysis, including data retrieval, aggregation, joins, CTEs, window functions, views, and functions. The resulting analysis can support more informed decisions about customers, products, and sales performance.

